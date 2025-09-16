package kr.co.hivesys.obs.service.impl;

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
	
}
