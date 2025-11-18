package kr.co.hivesys.search.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.search.mapper.SearchMapper;
import kr.co.hivesys.search.service.SearchService;
import kr.co.hivesys.search.vo.SearchVo;

/**
 * 검색&모니터링 서비스 구현 클래스
 * @author 솔루션 디자인팀 최다슬
 * @since 2025.09.19
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2025.09.19  최다슬           최초 생성
 */

@Service("searchService")
public class SearchServiceImpl implements SearchService{

	@Resource(name="searchMapper")
	private SearchMapper searchMapper;
	
	// 장치 관리 검색
	public List<SearchVo> searchDataList(SearchVo inputVo) throws Exception {
		return searchMapper.searchDataList(inputVo);
	}
	
	// 단말기 조회
	public List<SearchVo> searchRouterDataList (SearchVo inputVo) throws Exception {
		return searchMapper.searchRouterDataList(inputVo);		
	}
	
	
	// 실시간 데이터 - 단말기 조회 검색 옵션 셋팅
	public List<SearchVo> companyTypeList(SearchVo inputVo) throws Exception {
		return searchMapper.companyTypeList(inputVo);
	}
	
	public List<SearchVo> deviceNameTypeList(SearchVo inputVo) throws Exception {
		return searchMapper.deviceNameTypeList(inputVo);
	}
		
	// 장치 상세 정보 검색
	public SearchVo selectDetail(SearchVo inputVo) throws Exception {
		return searchMapper.selectDetail(inputVo);
	}

	//받아온 voltenum 으로 ip port pw 조회
	@Override
	public SearchVo findVnc(SearchVo inputVo) throws Exception {
		return searchMapper.findVnc(inputVo);
	}
	
	
}
