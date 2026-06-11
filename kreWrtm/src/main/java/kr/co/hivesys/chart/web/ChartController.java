package kr.co.hivesys.chart.web;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.user.vo.UserVO;

@Controller
public class ChartController {

    public static final Logger logger = LoggerFactory.getLogger(ChartController.class);

    @Resource(name = "chartService")
    private ChartService chartService;

    /* 일반 chart JSP 이동용 매핑. /chart/main.do는 mainChart()에서 별도로 처리한다. */
    @RequestMapping("/chart/*.do")
    public String urlMapping(HttpServletRequest request, Model model) throws Exception {
        String url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
        logger.debug("▶▶▶▶▶▶▶.보내려는 url : " + url);
        return url;
    }

    /* 대시보드 화면 진입. 화면만 반환하고 실제 DB 데이터는 /chart/dashboardData.ajax에서 조회한다. */
    @RequestMapping(value = "/chart/main.do")
    public ModelAndView mainChart(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("/chart/main");
        return mav;
    }

    /* main.jsp -> /chart/dashboardData.ajax -> ChartService -> ChartMapper -> DB */
    @RequestMapping(value = "/chart/dashboardData.ajax")
    public @ResponseBody ModelAndView dashboardData(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView");

        try {
            Map<String, Object> param = makeDashboardSearchParam(request);
            Map<String, Object> dashboardData = buildDashboardData(param);

            mav.addObject("result", "success");
            mav.addObject("dashboardData", dashboardData);
        } catch (Exception e) {
            logger.error("대시보드 데이터 조회 중 오류", e);
            mav.addObject("result", "fail");
            mav.addObject("message", "대시보드 데이터 조회 중 오류가 발생했습니다.");
            mav.addObject("dashboardData", getEmptyDashboardData());
        }

        return mav;
    }


    /* more 클릭 시 tbl_last_data 기준 전체 단말 최신 수신 상태를 조회한다. */
    @RequestMapping(value = "/chart/dashboardLastDataList.ajax")
    public @ResponseBody ModelAndView dashboardLastDataList(HttpServletRequest request) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView");

        try {
            Map<String, Object> param = makeDashboardSearchParam(request);
            param.put("listAll", "Y");

            List<Map<String, Object>> receiveList = normalizeReceiveList(chartService.selectDashboardReceiveList(param));

            mav.addObject("result", "success");
            mav.addObject("receiveList", receiveList);
        } catch (Exception e) {
            logger.error("대시보드 최신 수신 전체 목록 조회 중 오류", e);
            mav.addObject("result", "fail");
            mav.addObject("message", "최신 수신 전체 목록 조회 중 오류가 발생했습니다.");
            mav.addObject("receiveList", Collections.emptyList());
        }

        return mav;
    }

    /*
     * 로그인 사용자 기준 대시보드 조회 범위 생성.
     * - 코레일: router_info에 등록된 전체 단말기 조회
     * - 제조사: 로그인 사용자의 company_code에 등록된 단말기만 조회
     *
     * tbl_receive_data / tbl_last_data에는 부하테스트용 미등록 단말 데이터가 들어갈 수 있으므로
     * mapper에서 tbl_router_info와 VoLTE_NUM 기준으로 INNER JOIN하여 등록 단말만 집계한다.
     */
    private Map<String, Object> makeDashboardSearchParam(HttpServletRequest request) {
        Map<String, Object> param = new HashMap<String, Object>();

        UserVO login = null;
        if (request != null && request.getSession() != null) {
            Object sessionLogin = request.getSession().getAttribute("login");
            if (sessionLogin instanceof UserVO) {
                login = (UserVO) sessionLogin;
            }
        }

        String userType = login == null ? "" : nvl(login.getUserType());
        String companyCode = login == null ? "" : nvl(login.getCompanyCode());

        boolean korailUser = "코레일".equals(userType);

        param.put("userType", userType);
        param.put("companyCode", companyCode);
        param.put("isKorail", korailUser ? "Y" : "N");

        logger.debug("대시보드 조회 범위 - userType: " + userType + ", companyCode: " + companyCode + ", isKorail: " + (korailUser ? "Y" : "N"));
        return param;
    }

    private Map<String, Object> buildDashboardData(Map<String, Object> param) throws Exception {
        Map<String, Object> kpiRaw = chartService.selectDashboardKpi(param);
        List<Map<String, Object>> trendList = chartService.selectDashboardTrendList(param);
        List<Map<String, Object>> radioList = chartService.selectDashboardRadioList(param);
        List<Map<String, Object>> rsrpStatusList = normalizeStatusList(chartService.selectDashboardRsrpStatusList(param));
        List<Map<String, Object>> rsrqStatusList = normalizeStatusList(chartService.selectDashboardRsrqStatusList(param));
        List<Map<String, Object>> receiveList = normalizeReceiveList(chartService.selectDashboardReceiveList(param));

        int manageDeviceCnt = getInt(kpiRaw, "manageDeviceCnt");
        int totalDeviceCnt = getInt(kpiRaw, "totalDeviceCnt");
        int lteCnt = getInt(kpiRaw, "lteCnt");
        int vhfCnt = getInt(kpiRaw, "vhfCnt");
        int autoSwitchCnt = getInt(kpiRaw, "autoSwitchCnt");

        Map<String, Object> kpi = new HashMap<String, Object>();
        kpi.put("manageDeviceCnt", manageDeviceCnt);
        kpi.put("totalDeviceCnt", totalDeviceCnt);
        kpi.put("lteCnt", lteCnt);
        kpi.put("vhfCnt", vhfCnt);
        kpi.put("autoSwitchCnt", autoSwitchCnt);
        kpi.put("lteRatio", calcRatio(lteCnt, totalDeviceCnt));
        kpi.put("vhfRatio", calcRatio(vhfCnt, totalDeviceCnt));
        kpi.put("autoSwitchRatio", calcRatio(autoSwitchCnt, totalDeviceCnt));
        kpi.put("avgRsrp", formatNumber(getDouble(kpiRaw, "avgRsrp")));
        kpi.put("avgRsrq", formatNumber(getDouble(kpiRaw, "avgRsrq")));
        kpi.put("cautionDeviceCnt", getInt(kpiRaw, "cautionDeviceCnt"));
        kpi.put("lastRcvDt", getString(kpiRaw, "lastRcvDt"));

        Map<String, Object> dashboardData = new HashMap<String, Object>();
        dashboardData.put("kpi", kpi);
        dashboardData.put("trendList", trendList == null ? Collections.emptyList() : trendList);
        dashboardData.put("radioList", radioList == null ? Collections.emptyList() : radioList);
        dashboardData.put("rsrpStatusList", rsrpStatusList);
        dashboardData.put("rsrqStatusList", rsrqStatusList);
        dashboardData.put("receiveList", receiveList);

        return dashboardData;
    }

    private Map<String, Object> getEmptyDashboardData() {
        Map<String, Object> kpi = new HashMap<String, Object>();
        kpi.put("manageDeviceCnt", 0);
        kpi.put("totalDeviceCnt", 0);
        kpi.put("lteRatio", 0);
        kpi.put("vhfRatio", 0);
        kpi.put("autoSwitchRatio", 0);
        kpi.put("avgRsrp", "0");
        kpi.put("avgRsrq", "0");
        kpi.put("cautionDeviceCnt", 0);
        kpi.put("lastRcvDt", "-");

        Map<String, Object> dashboardData = new HashMap<String, Object>();
        dashboardData.put("kpi", kpi);
        dashboardData.put("trendList", Collections.emptyList());
        dashboardData.put("radioList", Collections.emptyList());
        dashboardData.put("rsrpStatusList", Collections.emptyList());
        dashboardData.put("rsrqStatusList", Collections.emptyList());
        dashboardData.put("receiveList", Collections.emptyList());
        return dashboardData;
    }

    private List<Map<String, Object>> normalizeStatusList(List<Map<String, Object>> list) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        if (list == null) return result;

        for (Map<String, Object> row : list) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("sortOrder", getMapValue(row, "sortOrder"));
            item.put("status", getString(row, "status"));
            item.put("statusClass", getString(row, "statusClass"));
            item.put("rangeText", getString(row, "rangeText"));
            item.put("cnt", getInt(row, "cnt"));
            result.add(item);
        }
        return result;
    }

    private List<Map<String, Object>> normalizeReceiveList(List<Map<String, Object>> list) {
        List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
        if (list == null) return result;

        for (Map<String, Object> row : list) {
            Map<String, Object> item = new HashMap<String, Object>();
            item.put("volteNum", getString(row, "volteNum"));
            item.put("carNum", getString(row, "carNum"));
            item.put("currentRadioType", getString(row, "currentRadioType"));
            item.put("rsrp", getString(row, "rsrp"));
            item.put("rsrpNum", getMapValue(row, "rsrpNum"));
            item.put("rsrpStatus", getString(row, "rsrpStatus"));
            item.put("rsrpStatusClass", getString(row, "rsrpStatusClass"));
            item.put("rsrq", getString(row, "rsrq"));
            item.put("rsrqNum", getMapValue(row, "rsrqNum"));
            item.put("rsrqStatus", getString(row, "rsrqStatus"));
            item.put("rsrqStatusClass", getString(row, "rsrqStatusClass"));
            item.put("rcvTime", getString(row, "rcvTime"));
            item.put("rcvDtSort", getString(row, "rcvDtSort"));
            result.add(item);
        }
        return result;
    }

    private Object getMapValue(Map<String, Object> map, String key) {
        if (map == null || key == null) return null;
        if (map.containsKey(key)) return map.get(key);
        for (String mapKey : map.keySet()) {
            if (key.equalsIgnoreCase(mapKey)) return map.get(mapKey);
        }
        return null;
    }

    private int getInt(Map<String, Object> map, String key) {
        Object value = getMapValue(map, key);
        if (value == null) return 0;
        if (value instanceof Number) return ((Number) value).intValue();
        try { return Integer.parseInt(String.valueOf(value)); } catch (Exception e) { return 0; }
    }

    private double getDouble(Map<String, Object> map, String key) {
        Object value = getMapValue(map, key);
        if (value == null) return 0;
        if (value instanceof Number) return ((Number) value).doubleValue();
        try { return Double.parseDouble(String.valueOf(value)); } catch (Exception e) { return 0; }
    }

    private String getString(Map<String, Object> map, String key) {
        Object value = getMapValue(map, key);
        return value == null ? "-" : String.valueOf(value);
    }

    private int calcRatio(int value, int total) {
        if (total <= 0) return 0;
        return (int) Math.round((value * 100.0) / total);
    }

    private String formatNumber(double value) {
        if (value == Math.rint(value)) return String.valueOf((int) value);
        return String.format("%.1f", value);
    }

    private String nvl(String value) {
        return value == null ? "" : value.trim();
    }
}
