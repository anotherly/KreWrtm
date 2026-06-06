package kr.co.hivesys.company.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.company.mapper.CompanyMapper;
import kr.co.hivesys.company.mapper.OrgMapper;
import kr.co.hivesys.company.service.CompanyService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.company.vo.OrgVO;

@Service("companyService")
public class CompanyServiceImpl implements CompanyService {
	@Resource(name = "companyMapper")
	private CompanyMapper companyMapper;
	
	@Resource(name = "orgMapper")
	private OrgMapper orgMapper;

	@Override
	public List<CompanyVO> selectList(CompanyVO thVo) {
		return companyMapper.selectList(thVo);
	}
	
	@Override
	public void insert(CompanyVO thVo) {
		companyMapper.insert(thVo);
		insertOrgList(thVo);
	}

	@Override
	public List<CompanyVO> select(CompanyVO thVo) {
		return companyMapper.select(thVo);
	}

	@Override
	public void update(CompanyVO thVo) {
		companyMapper.update(thVo);
		orgMapper.deleteByCompanyCode(thVo.getCompanyCode());
		insertOrgList(thVo);
	}

	@Override
	public void deleteChk(List<String> paramArr) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList", paramArr);
		
		// 회사 삭제 전 하위 본부/처/실 정보를 먼저 삭제한다.
		orgMapper.deleteByCompanyChk(map);
		companyMapper.deleteChk(map);		
	}
	
	private void insertOrgList(CompanyVO thVo) {
		if (thVo == null || thVo.getOrgList() == null || thVo.getOrgList().isEmpty()) {
			return;
		}
		
		for (OrgVO orgVo : thVo.getOrgList()) {
			if (orgVo == null) {
				continue;
			}
			
			String orgId = orgVo.getOrgId();
			String orgName = orgVo.getOrgName();
			
			if (orgId == null || orgId.trim().equals("")) {
				continue;
			}
			
			if (orgName == null || orgName.trim().equals("")) {
				continue;
			}
			
			orgVo.setOrgId(orgId.trim());
			orgVo.setOrgName(orgName.trim());
			orgVo.setCompanyCode(thVo.getCompanyCode());
			orgMapper.insert(orgVo);
		}
	}
}
