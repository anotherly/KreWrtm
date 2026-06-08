package kr.co.hivesys.chart.mapper;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.chart.vo.ChartVo;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

@Mapper("chartMapper")
public interface ChartMapper {

	public Map<String, Object> selectDashboardKpi() throws Exception;
	public List<Map<String, Object>> selectDashboardTrendList() throws Exception;
	public List<Map<String, Object>> selectDashboardRadioList() throws Exception;
	public List<Map<String, Object>> selectDashboardRsrpStatusList() throws Exception;
	public List<Map<String, Object>> selectDashboardRsrqStatusList() throws Exception;
	public List<Map<String, Object>> selectDashboardReceiveList() throws Exception;
}
