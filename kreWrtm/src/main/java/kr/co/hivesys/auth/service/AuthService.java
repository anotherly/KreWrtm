package kr.co.hivesys.auth.service;

import java.util.List;
import java.util.Set;

import kr.co.hivesys.auth.vo.AuthVO;

public interface AuthService {
	List<AuthVO> selectAuthList();
	Set<String> selectAllowedUrls(Integer authId);
}
