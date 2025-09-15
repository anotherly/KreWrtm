package kr.co.hivesys.router.service;

import java.util.List;

import kr.co.hivesys.router.vo.RouterVO;

public interface RouterService {
	List<RouterVO> selectList(RouterVO thvo);

	void insert(RouterVO thvo);

	List<RouterVO> select(RouterVO thvo);

	void update(RouterVO thvo);
	
	void deleteChk(List<String> paramArr);
}
