package kr.co.hivesys.chart.web;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

@Controller
public class ChartController {

	public static final Logger logger = LoggerFactory.getLogger(ChartController.class);
	
	public String url="";
	
	@Resource(name="chartService")
	private ChartService chartService;
	
	/*
	 * 일반 chart JSP 이동용 매핑.
	 * /chart/main.do는 아래 mainChart()에서 별도로 처리한다.
	 */
	@RequestMapping("/chart/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request, Model model) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	/*
	 * 대시보드 화면 진입.
	 * 여기서는 화면만 반환하고, 실제 DB 데이터는 /chart/dashboardData.ajax에서 조회한다.
	 * main.jsp의 Chart.js 차트는 페이지 로딩 후 dashboardData.ajax를 호출해서 그린다.
	 */
	@RequestMapping(value="/chart/main.do")
	public ModelAndView mainChart(HttpServletRequest request) throws Exception{
		ModelAndView mav = new ModelAndView();
		mav.setViewName("/chart/main");
		return mav;
	}
	
	/*
	 * 대시보드 실제 DB 데이터 조회 API.
	 * main.jsp -> /chart/dashboardData.ajax -> ChartService -> ChartMapper -> DB
	 */
	@RequestMapping(value="/chart/dashboardData.ajax")
	public @ResponseBody ModelAndView dashboardData(HttpServletRequest request) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			Map<String, Object> dashboardData = buildDashboardData();
			mav.addObject("result", "success");
			mav.addObject("dashboardData", dashboardData);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("대시보드 데이터 조회 에러메시지 : " + e.toString());
			mav.addObject("result", "fail");
			mav.addObject("message", "대시보드 데이터 조회 중 오류가 발생했습니다.");
			mav.addObject("dashboardData", getEmptyDashboardData());
		}
		return mav;
	}
	
	private Map<String, Object> buildDashboardData() throws Exception {
		Map<String, Object> kpiRaw = chartService.selectDashboardKpi();
		List<Map<String, Object>> trendList = chartService.selectDashboardTrendList();
		List<Map<String, Object>> radioList = chartService.selectDashboardRadioList();
		List<Map<String, Object>> rsrpStatusList = chartService.selectDashboardRsrpStatusList();
		List<Map<String, Object>> receiveList = chartService.selectDashboardReceiveList();

		int totalDeviceCnt = getInt(kpiRaw, "totalDeviceCnt");
		int lteCnt = getInt(kpiRaw, "lteCnt");
		int vhfCnt = getInt(kpiRaw, "vhfCnt");
		int autoSwitchCnt = getInt(kpiRaw, "autoSwitchCnt");

		Map<String, Object> kpi = new HashMap<String, Object>();
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
		dashboardData.put("trendList", trendList);
		dashboardData.put("radioList", radioList);
		dashboardData.put("rsrpStatusList", rsrpStatusList);
		dashboardData.put("receiveList", receiveList);
		return dashboardData;
	}
	
	private Map<String, Object> getEmptyDashboardData() {
		Map<String, Object> kpi = new HashMap<String, Object>();
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
		dashboardData.put("trendList", java.util.Collections.emptyList());
		dashboardData.put("radioList", java.util.Collections.emptyList());
		dashboardData.put("rsrpStatusList", java.util.Collections.emptyList());
		dashboardData.put("receiveList", java.util.Collections.emptyList());
		return dashboardData;
	}
	
	// 나중에 합칠 예정
	@RequestMapping(value="/chart/routerList.ajax")
	public @ResponseBody ModelAndView reqRouterList(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<RouterVO> routerList = null;
		try {
	        routerList = chartService.routerList();
	        mav.addObject("routerList", routerList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
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

	// 디렉토리 크기 구하기
	private long getFolderSize(File folder) {
	    long result = 0;
	    try {
	        File[] files = folder.listFiles();
	        if (files != null) {
	            for (File file : files) {
	                if (file.isFile()) result += file.length();
	                else result += getFolderSize(file);
	            }
	        }
	    } catch (Exception e) { e.printStackTrace(); }
	    return result;
	}
	
	// 디렉토리 생성날짜 가져오기
	private String getCreationTime(File folder, SimpleDateFormat sdf) {
		try {
	        Path path = folder.toPath();
	        BasicFileAttributes attr = Files.readAttributes(path, BasicFileAttributes.class);
	        return sdf.format(attr.creationTime().toMillis());
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "정보 없음";
	    }
	}
}
