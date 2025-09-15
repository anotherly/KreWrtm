package kr.co.hivesys.company.service.impl;

import java.util.HashMap;
import java.util.List;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;

import kr.co.hivesys.company.mapper.CompanyMapper;
import kr.co.hivesys.company.service.CompanyService;
import kr.co.hivesys.company.vo.CompanyVO;

@Service("companyService")
public class CompanyServiceImpl implements CompanyService {
	@Resource(name = "companyMapper")
	private CompanyMapper companyMapper;

	@Override
	public List<CompanyVO> selectList(CompanyVO thVo) {
		return companyMapper.selectList(thVo);
	}
	
	@Override
	public void insert(CompanyVO thVo) {
		companyMapper.insert(thVo);
	}

	@Override
	public List<CompanyVO> select(CompanyVO thVo) {
		return companyMapper.select(thVo);
	}

	@Override
	public void update(CompanyVO thVo) {
		companyMapper.update(thVo);
	}

	@Override
	public void deleteChk(List<String> paramArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList",paramArr);
		companyMapper.deleteChk(map);		
	}
}
