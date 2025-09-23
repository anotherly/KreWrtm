package kr.co.hivesys.chart.mapper;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.chart.vo.ChartVo;

@Mapper("chartMapper")
public interface ChartMapper {
	// 실시간 사용률 현황 테이블 조회
	public List<ChartVo> selectDataList() throws Exception;
}
