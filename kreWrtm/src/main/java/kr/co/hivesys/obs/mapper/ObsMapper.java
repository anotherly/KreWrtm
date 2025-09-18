package kr.co.hivesys.obs.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.obs.vo.ObsVo;

@Mapper("obsMapper")
public interface ObsMapper {

	// 장애이력 관리 조회
	public List<ObsVo> selectDataList(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 상세
	public ObsVo selectData(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 등록
	public void insertData(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 수정
	public void updateObs(ObsVo inputVo) throws Exception;
	
	// 장애이력 관리 삭제
	public void deleteData(HashMap<String, Object> map);
}
