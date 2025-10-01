package kr.co.hivesys.chart.service.impl;

import java.util.List;

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
	
	// 실시간 사용률 현황 테이블 조회
	@Override
	public List<ChartVo> selectDataList() throws Exception {
		return chartMapper.selectDataList();
	}
	
	// 회사별 단말기 현황 조회
	@Override
	public List<RouterVO> routerList() throws Exception {
		return chartMapper.routerList();
	}
	
	// 회사 코드 가져오기
	@Override
	public List<CompanyVO> getComCode() throws Exception {
		return chartMapper.getComCode();
	}
	
	// 회사별 금일 데이터 건수 가져오기
	@Override
	public List<CompanyVO> currentList() throws Exception {
		return chartMapper.currentList();
	}
	
	// 회사별 rsrq 금일 평균치 가져오기
	@Override
	public List<CompanyVO> rsrqAvgList() throws Exception {
		return chartMapper.rsrqAvgList();
	}
	
}
