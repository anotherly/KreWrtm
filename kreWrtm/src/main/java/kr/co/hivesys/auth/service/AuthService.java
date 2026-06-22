package kr.co.hivesys.auth.service;

import java.util.List;
import java.util.Set;

import kr.co.hivesys.auth.vo.AuthVO;

public interface AuthService {
	List<AuthVO> selectAuthList();
	AuthVO createAuth(String authDefine);
	void updateAuthName(Integer authId, String authDefine);
	void deleteAuth(Integer authId);
	Set<String> selectAllowedUrls(Integer authId);
	List<AuthVO> selectAuthUrlSettings(Integer authId);
	void updateAuthUrls(Integer authId, List<String> urlList);
}
