package kr.co.hivesys.chart.mapper;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.chart.vo.ChartVo;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

@Mapper("chartMapper")
public interface ChartMapper {
	// 실시간 사용률 현황 테이블 조회
	public List<ChartVo> selectDataList() throws Exception;
	
	// 회사별 단말기 현황 조회
	public List<RouterVO> routerList() throws Exception;
	
	// 회사 코드 가져오기
	public List<CompanyVO> getComCode() throws Exception;
	
	// 회사별 금일 데이터 건수 가져오기
	public List<CompanyVO> currentList() throws Exception;
	
	// 회사별 rsrq 금일 평균치 가져오기
	public List<CompanyVO> rsrqAvgList() throws Exception;
}
