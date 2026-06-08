package kr.co.hivesys.router.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.company.vo.OrgVO;
import kr.co.hivesys.router.mapper.RouterMapper;
import kr.co.hivesys.router.service.RouterService;
import kr.co.hivesys.router.vo.RouterVO;

@Service("routerService")
public class RouterServiceImpl implements RouterService {
	@Resource(name = "routerMapper")
	private RouterMapper routerMapper;

	@Override
	public List<RouterVO> selectList(RouterVO thVo) {
		return routerMapper.selectList(thVo);
	}
	
	@Override
	public void insert(RouterVO thVo) {
		routerMapper.insert(thVo);
	}

	@Override
	public RouterVO select(RouterVO thVo) throws Exception{
		return routerMapper.select(thVo);
	}

	@Override
	public void update(RouterVO thVo) {
		routerMapper.update(thVo);
	}

	@Override
	public void deleteChk(List<String> paramArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",paramArr);
		routerMapper.deleteChk(map);		
	}
	
	@Override
	public void deleteCompany(List<String> paramArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",paramArr);
		routerMapper.deleteCompany(map);		
	}
	
	@Override
	public List<OrgVO> userTypeSelect(OrgVO inputVo) throws Exception {
		return routerMapper.userTypeSelect(inputVo);
	}

	
	@Override
	public List<RouterVO> selectCompany(RouterVO inputVo) throws Exception {
		return routerMapper.selectCompany(inputVo);
	}
}
