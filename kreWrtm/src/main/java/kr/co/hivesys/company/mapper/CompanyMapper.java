package kr.co.hivesys.company.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.company.vo.CompanyVO;

@Mapper("companyMapper")
public interface CompanyMapper {
	List<CompanyVO> selectList(CompanyVO thvo);

	void insert(CompanyVO thvo);

	List<CompanyVO> select(CompanyVO thvo);

	void update(CompanyVO thvo);
	
	void deleteChk(HashMap<String, Object> map);
}
