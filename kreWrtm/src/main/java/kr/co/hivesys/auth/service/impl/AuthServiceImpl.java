package kr.co.hivesys.auth.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

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
	public Set<String> selectAllowedUrls(Integer authId) {
		return new HashSet<String>(authMapper.selectAllowedUrls(authId));
	}
}
