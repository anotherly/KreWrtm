package kr.co.hivesys.company.service;

import java.util.List;

import kr.co.hivesys.company.vo.OrgVO;

public interface OrgService {
	List<OrgVO> selectList(OrgVO thvo);

	void insert(OrgVO thvo);

	List<OrgVO> select(OrgVO thvo);

	void update(OrgVO thvo);
	
	void deleteChk(List<String> paramArr);
}
