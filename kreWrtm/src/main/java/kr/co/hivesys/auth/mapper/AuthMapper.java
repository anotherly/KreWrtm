package kr.co.hivesys.auth.mapper;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.hivesys.auth.vo.AuthVO;

@Mapper("authMapper")
public interface AuthMapper {
	List<AuthVO> selectAuthList();
	List<String> selectAllowedUrls(Integer authId);
}
