package kr.co.hivesys.chart.service;

import java.util.List;
import java.util.Map;

import kr.co.hivesys.chart.vo.ChartVo;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

public interface ChartService {
	public List<RouterVO> routerList() throws Exception;
	public List<CompanyVO> getComCode() throws Exception;
	public List<CompanyVO> currentList() throws Exception;
	public List<CompanyVO> rsrqAvgList() throws Exception;

	public Map<String, Object> selectDashboardKpi() throws Exception;
	public List<Map<String, Object>> selectDashboardTrendList() throws Exception;
	public List<Map<String, Object>> selectDashboardRadioList() throws Exception;
	public List<Map<String, Object>> selectDashboardRsrpStatusList() throws Exception;
	public List<Map<String, Object>> selectDashboardReceiveList() throws Exception;
}
