package kr.co.hivesys.obs.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.obs.mapper.ObsMapper;
import kr.co.hivesys.obs.service.ObsService;
import kr.co.hivesys.obs.vo.ObsVo;

@Service("obsService")
public class ObsServiceImpl implements ObsService{

	@Resource(name="obsMapper")
	private ObsMapper obsMapper;
	
	
	// 장애이력 관리 조회
	public List<ObsVo> selectDataList(ObsVo inputVo) throws Exception {
		return obsMapper.selectDataList(inputVo);
	}
	
	
	// 장애이력 관리 상세
	public ObsVo selectData(ObsVo inputVo) throws Exception {
		return obsMapper.selectData(inputVo);
	}
	
	
	// 장애이력 관리 등록
	public void insertData(ObsVo inputVo) throws Exception {
		obsMapper.insertData(inputVo);
	}
	
	// 장애이력 관리 수정
	public void updateObs(ObsVo inputVo) throws Exception {
		obsMapper.updateObs(inputVo);
	}
	
	// 장애이력 관리 삭제
	public void deleteData(List<String> dataArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",dataArr);
		obsMapper.deleteData(map);
	}
}
