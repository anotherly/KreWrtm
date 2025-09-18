package kr.co.hivesys.obs.service;

import java.util.List;

import kr.co.hivesys.obs.vo.ObsVo;

/**
 * 자료실 서비스 클래스
 * @author 솔루션 디자인팀 최다슬
 * @since 2025.09.11
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2025.09.11  최다슬             최초 생성
 */

public interface ObsService {
	
	// 장애이력 관리 조회
	public List<ObsVo> selectDataList(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 상세
	public ObsVo selectData(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 등록
	public void insertData(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 수정
	public void updateObs(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 삭제
	public void deleteData(List<String> dataArr);
}
