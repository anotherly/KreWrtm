package kr.co.hivesys.router.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.company.vo.OrgVO;
import kr.co.hivesys.router.vo.RouterVO;

@Mapper("routerMapper")
public interface RouterMapper {
	List<RouterVO> selectList(RouterVO thvo);

	void insert(RouterVO thvo);

	public RouterVO select(RouterVO thvo) throws Exception;

	void update(RouterVO thvo);
	
	void deleteChk(HashMap<String, Object> map);
	
	public List<OrgVO> userTypeSelect(OrgVO inputVo) throws Exception;
	
	public List<RouterVO> selectCompany(RouterVO inputVo) throws Exception;

	void deleteCompany(HashMap<String, Object> map);
}
