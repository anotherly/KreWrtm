package kr.co.hivesys.chart.service;

import java.util.List;

import kr.co.hivesys.chart.vo.ChartVo;


/**
 * 실시간 사용률 현황 서비스 클래스
 * @author 솔루션 디자인팀 최다슬
 * @since 2025.09.22
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2025.09.22  최다슬             최초 생성
 */
 
public interface ChartService {
	
	// 실시간 사용률 현황 테이블 조회
	public List<ChartVo> selectDataList() throws Exception;
}
