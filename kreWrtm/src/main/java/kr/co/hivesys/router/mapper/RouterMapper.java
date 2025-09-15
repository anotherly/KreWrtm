package kr.co.hivesys.router.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.router.vo.RouterVO;

@Mapper("routerMapper")
public interface RouterMapper {
	List<RouterVO> selectList(RouterVO thvo);

	void insert(RouterVO thvo);

	List<RouterVO> select(RouterVO thvo);

	void update(RouterVO thvo);
	
	void deleteChk(HashMap<String, Object> map);
}
