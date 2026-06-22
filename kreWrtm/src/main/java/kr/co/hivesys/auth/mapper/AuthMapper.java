package kr.co.hivesys.auth.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.auth.vo.AuthVO;

@Mapper("authMapper")
public interface AuthMapper {
	List<AuthVO> selectAuthList();
	int countAuthById(Integer authId);
	int countAuthByName(@Param("authDefine") String authDefine, @Param("excludeAuthId") Integer excludeAuthId);
	int selectNextAuthId();
	int insertAuth(AuthVO auth);
	int updateAuthName(AuthVO auth);
	List<String> selectAllowedUrls(Integer authId);
	List<AuthVO> selectAuthUrlSettings(Integer authId);
	int insertMissingAuthUrls(Integer authId);
	int resetAuthUrls(Integer authId);
	int enableAuthUrls(@Param("authId") Integer authId, @Param("urlList") List<String> urlList);
}
