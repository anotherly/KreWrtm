package kr.co.hivesys.chart.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.chart.mapper.ChartMapper;
import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.chart.vo.ChartVo;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

@Service("chartService")
public class ChartServiceImpl implements ChartService{

	@Resource(name="chartMapper")
	private ChartMapper chartMapper;
	
	@Override
	public List<ChartVo> selectDataList() throws Exception { return chartMapper.selectDataList(); }
	
	@Override
	public List<RouterVO> routerList() throws Exception { return chartMapper.routerList(); }
	
	@Override
	public List<CompanyVO> getComCode() throws Exception { return chartMapper.getComCode(); }
	
	@Override
	public List<CompanyVO> currentList() throws Exception { return chartMapper.currentList(); }
	
	@Override
	public List<CompanyVO> rsrqAvgList() throws Exception { return chartMapper.rsrqAvgList(); }

	@Override
	public Map<String, Object> selectDashboardKpi() throws Exception { return chartMapper.selectDashboardKpi(); }
	
	@Override
	public List<Map<String, Object>> selectDashboardTrendList() throws Exception { return chartMapper.selectDashboardTrendList(); }
	
	@Override
	public List<Map<String, Object>> selectDashboardRadioList() throws Exception { return chartMapper.selectDashboardRadioList(); }
	
	@Override
	public List<Map<String, Object>> selectDashboardRsrpStatusList() throws Exception { return chartMapper.selectDashboardRsrpStatusList(); }
	
	@Override
	public List<Map<String, Object>> selectDashboardRsrqStatusList() throws Exception { return chartMapper.selectDashboardRsrqStatusList(); }
	
	@Override
	public List<Map<String, Object>> selectDashboardReceiveList() throws Exception { return chartMapper.selectDashboardReceiveList(); }
}
