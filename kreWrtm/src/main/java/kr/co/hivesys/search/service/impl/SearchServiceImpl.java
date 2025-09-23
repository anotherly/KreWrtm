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
}
