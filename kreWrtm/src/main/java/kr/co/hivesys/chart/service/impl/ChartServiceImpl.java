package kr.co.hivesys.chart.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.chart.mapper.ChartMapper;
import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.chart.vo.ChartVo;

@Service("chartService")
public class ChartServiceImpl implements ChartService{

	@Resource(name="chartMapper")
	private ChartMapper chartMapper;
	
	// 실시간 사용률 현황 테이블 조회
	public List<ChartVo> selectDataList() throws Exception {
		return chartMapper.selectDataList();
	}
	
}
