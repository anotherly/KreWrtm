package kr.co.hivesys.company.service;

import java.util.List;

import kr.co.hivesys.company.vo.CompanyVO;

public interface CompanyService {
	List<CompanyVO> selectList(CompanyVO thvo);

	void insert(CompanyVO thvo);

	List<CompanyVO> select(CompanyVO thvo);

	void update(CompanyVO thvo);
	
	void deleteChk(List<String> paramArr);
}
