package kr.co.hivesys.search.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.dataroom.vo.DataroomVO;
import kr.co.hivesys.search.service.SearchService;
import kr.co.hivesys.search.vo.SearchVo;
import kr.co.hivesys.user.vo.UserVO;
import kr.co.hivesys.user.web.UserController;

@Controller
public class SearchController {
	
	public static final Logger logger = LoggerFactory.getLogger(UserController.class);
	public String url="";
	
	@Resource(name="searchService")
	private SearchService searchService;
	
	
	//주소에 맞게 매핑
	@RequestMapping(value= "/search/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶ 검색 & 모니터링 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	
	
	// 검색 & 모니터링 목록 화면 진입
	@RequestMapping(value="/search/list.do")
	public @ResponseBody ModelAndView dataListdo(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		
		return mav;
	}
	
	
	
	// 검색 & 모니터링 검색 기능
	@RequestMapping(value="/search/search.do")
	public @ResponseBody ModelAndView searchDo(HttpServletRequest request, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");

		String searchVal = inputVo.getSearchValue();
		
		mav.addObject("searchVal", searchVal);
		mav.setViewName(url);
		
		return mav;
	}
	
	
	
	@RequestMapping(value="/search/list.ajax")
	public @ResponseBody ModelAndView reqList(HttpServletRequest request, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<SearchVo> sList= null;
		
		try {				
			sList = searchService.searchDataList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	
}
