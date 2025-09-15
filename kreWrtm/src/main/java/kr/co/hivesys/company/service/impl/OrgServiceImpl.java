package kr.co.hivesys.company.service.impl;

import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.company.mapper.OrgMapper;
import kr.co.hivesys.company.service.OrgService;
import kr.co.hivesys.company.vo.OrgVO;


@Service("orgService")
public class OrgServiceImpl implements OrgService {
	@Resource(name = "orgMapper")
	private OrgMapper orgMapper;

	@Override
	public List<OrgVO> selectList(OrgVO thVo) {
		return orgMapper.selectList(thVo);
	}
	
	@Override
	public void insert(OrgVO thVo) {
		orgMapper.insert(thVo);
	}

	@Override
	public List<OrgVO> select(OrgVO thVo) {
		return orgMapper.select(thVo);
	}

	@Override
	public void update(OrgVO thVo) {
		orgMapper.update(thVo);
	}

	@Override
	public void deleteChk(List<String> paramArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",paramArr);
		orgMapper.deleteChk(map);		
	}

}
