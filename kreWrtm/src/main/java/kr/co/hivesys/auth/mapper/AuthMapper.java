package kr.co.hivesys.auth.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.auth.vo.AuthVO;

@Mapper("authMapper")
public interface AuthMapper {
	List<AuthVO> selectAuthList();
	List<String> selectAllowedUrls(Integer authId);
	List<AuthVO> selectAuthUrlSettings(Integer authId);
	int insertMissingAuthUrls(Integer authId);
	int resetAuthUrls(Integer authId);
	int enableAuthUrls(@Param("authId") Integer authId, @Param("urlList") List<String> urlList);
}
