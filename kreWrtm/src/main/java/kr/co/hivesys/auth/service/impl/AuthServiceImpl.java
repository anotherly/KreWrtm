package kr.co.hivesys.auth.service.impl;

import java.util.HashSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.hivesys.auth.mapper.AuthMapper;
import kr.co.hivesys.auth.service.AuthService;
import kr.co.hivesys.auth.vo.AuthVO;

@Service("authService")
public class AuthServiceImpl implements AuthService {
	@Resource(name = "authMapper")
	private AuthMapper authMapper;

	@Override
	public List<AuthVO> selectAuthList() {
		return authMapper.selectAuthList();
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public AuthVO createAuth(String authDefine) {
		String normalizedName = validateAuthName(authDefine, null);
		AuthVO auth = new AuthVO();
		auth.setAuthId(Integer.valueOf(authMapper.selectNextAuthId()));
		auth.setAuthDefine(normalizedName);
		auth.setUsedYn(Integer.valueOf(1));
		authMapper.insertAuth(auth);

		authMapper.insertMissingAuthUrls(auth.getAuthId());
		authMapper.enableAuthUrls(auth.getAuthId(), Arrays.asList(
				"/chart/main", "/chart/dashboardData", "/chart/dashboardLastDataList"));
		return auth;
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateAuthName(Integer authId, String authDefine) {
		validateAuthId(authId);
		AuthVO auth = new AuthVO();
		auth.setAuthId(authId);
		auth.setAuthDefine(validateAuthName(authDefine, authId));
		if (authMapper.updateAuthName(auth) != 1) {
			throw new IllegalStateException("권한명을 변경하지 못했습니다.");
		}
	}

	@Override
	public Set<String> selectAllowedUrls(Integer authId) {
		return new HashSet<String>(authMapper.selectAllowedUrls(authId));
	}

	@Override
	public List<AuthVO> selectAuthUrlSettings(Integer authId) {
		validateAuthId(authId);
		return authMapper.selectAuthUrlSettings(authId);
	}

	@Override
	@Transactional(rollbackFor = Exception.class)
	public void updateAuthUrls(Integer authId, List<String> urlList) {
		validateAuthId(authId);

		List<String> selectedUrls = urlList == null
				? new ArrayList<String>() : new ArrayList<String>(new HashSet<String>(urlList));
		normalizeScreenDependencies(selectedUrls);

		/* 로그인 후 기본 진입 및 권한 차단 시 복귀 화면이므로 모든 권한에 필수입니다. */
		addRequiredUrl(selectedUrls, "/chart/main");
		addRequiredUrl(selectedUrls, "/chart/dashboardData");
		addRequiredUrl(selectedUrls, "/chart/dashboardLastDataList");

		/* 코레일 관리자가 설정 화면 접근 권한을 스스로 제거하지 못하게 보호합니다. */
		if (Integer.valueOf(1).equals(authId)) {
			addRequiredUrl(selectedUrls, "/setting/main");
			addRequiredUrl(selectedUrls, "/setting/saveRefresh");
			addRequiredUrl(selectedUrls, "/setting/authUrls");
			addRequiredUrl(selectedUrls, "/setting/saveAuthUrls");
		}

		authMapper.insertMissingAuthUrls(authId);
		authMapper.resetAuthUrls(authId);
		if (!selectedUrls.isEmpty()) {
			authMapper.enableAuthUrls(authId, selectedUrls);
		}
	}

	private void normalizeScreenDependencies(List<String> selectedUrls) {
		normalizeCrudGroup(selectedUrls, "/user/userList", "/user/userInsert",
				"/user/userDetail", "/user/userUpdate", "/user/userDelete");
		normalizeCrudGroup(selectedUrls, "/company/companyList", "/company/companyInsert",
				"/company/companyDetail", "/company/companyUpdate", "/company/companyDelete");
		normalizeCrudGroup(selectedUrls, "/router/routerList", "/router/routerInsert",
				"/router/routerDetail", "/router/routerUpdate", "/router/routerDelete");
		normalizeCrudGroup(selectedUrls, "/obs/list", "/obs/insert",
				"/obs/detail", "/obs/update", "/obs/delete");
		normalizeCrudGroup(selectedUrls, "/dataroom/list", "/dataroom/insert",
				"/dataroom/detail", "/dataroom/update", "/dataroom/delete",
				"/dataroom/fileDownload");
	}

	private void normalizeCrudGroup(List<String> selectedUrls, String listUrl, String insertUrl,
			String detailUrl, String updateUrl, String deleteUrl, String... additionalUrls) {
		if (selectedUrls.contains(updateUrl)) {
			addRequiredUrl(selectedUrls, detailUrl);
		}

		boolean hasChildPermission = selectedUrls.contains(insertUrl)
				|| selectedUrls.contains(detailUrl)
				|| selectedUrls.contains(updateUrl)
				|| selectedUrls.contains(deleteUrl);
		for (String additionalUrl : additionalUrls) {
			if (selectedUrls.contains(additionalUrl)) {
				hasChildPermission = true;
				addRequiredUrl(selectedUrls, detailUrl);
			}
		}

		if (hasChildPermission) {
			addRequiredUrl(selectedUrls, listUrl);
		}
	}

	private void validateAuthId(Integer authId) {
		if (authId == null || authId.intValue() < 1 || authMapper.countAuthById(authId) != 1) {
			throw new IllegalArgumentException("관리할 수 없는 권한 ID입니다.");
		}
	}

	private String validateAuthName(String authDefine, Integer excludeAuthId) {
		String name = authDefine == null ? "" : authDefine.trim();
		if (name.length() == 0) {
			throw new IllegalArgumentException("권한명을 입력해 주세요.");
		}
		if (name.length() > 16) {
			throw new IllegalArgumentException("권한명은 16자 이내로 입력해 주세요.");
		}
		if (authMapper.countAuthByName(name, excludeAuthId) > 0) {
			throw new IllegalArgumentException("이미 사용 중인 권한명입니다.");
		}
		return name;
	}

	private void addRequiredUrl(List<String> urlList, String url) {
		if (!urlList.contains(url)) {
			urlList.add(url);
		}
	}
}
