package kr.co.hivesys.company.service.impl;

import java.util.HashMap;
import java.util.List;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
		if (thVo.getCompanyId() == null || thVo.getCompanyId().trim().equals("")) {
			thVo.setCompanyId(thVo.getCompanyCode() + "_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")));
		}
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
		orgMapper.deleteByCompanyCode(thVo.getCompanyId());
		insertOrgList(thVo);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void deleteChk(List<String> paramArr) {
		if (paramArr == null || paramArr.isEmpty()) {
			throw new IllegalArgumentException("삭제할 소속기관을 선택해 주세요.");
		}
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("chkList", paramArr);

		if (companyMapper.countUsersByCompanyChk(map) > 0) {
			throw new IllegalStateException("해당 소속기관을 사용하는 사용자가 존재합니다. 먼저 해당 사용자들을 삭제해 주세요.");
		}
		if (companyMapper.countRoutersByCompanyChk(map) > 0) {
			throw new IllegalStateException("해당 소속기관을 사용하는 단말기가 존재합니다. 먼저 해당 단말기들을 삭제해 주세요.");
		}

		// 참조 데이터가 없을 때 하위 본부/처/실을 일괄 삭제한 후 소속기관을 삭제한다.
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
			orgVo.setCompanyId(thVo.getCompanyId());
			orgMapper.insert(orgVo);
		}
	}
}
