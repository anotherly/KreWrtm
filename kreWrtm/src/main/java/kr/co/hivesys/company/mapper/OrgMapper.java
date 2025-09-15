package kr.co.hivesys.company.mapper;

import java.util.HashMap;
import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.company.vo.OrgVO;

@Mapper("orgMapper")
public interface OrgMapper {
	List<OrgVO> selectList(OrgVO thvo);

	void insert(OrgVO thvo);

	List<OrgVO> select(OrgVO thvo);

	void update(OrgVO thvo);
	
	void deleteChk(HashMap<String, Object> map);
}
