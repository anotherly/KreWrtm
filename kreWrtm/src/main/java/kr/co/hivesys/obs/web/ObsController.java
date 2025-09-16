package kr.co.hivesys.obs.web;

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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.dataroom.vo.DataroomVO;
import kr.co.hivesys.obs.service.ObsService;
import kr.co.hivesys.obs.vo.ObsVo;
import kr.co.hivesys.user.vo.UserVO;
import kr.co.hivesys.user.web.UserController;



@Controller
public class ObsController {

	public static final Logger logger = LoggerFactory.getLogger(UserController.class);
	public String url="";
	
	@Resource(name="obsService")
	private ObsService obsService;
	
	
	//주소에 맞게 매핑
	@RequestMapping(value= "/obs/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.장애이력 관리 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	// 장애이력 관리 목록 화면 진입
	@RequestMapping(value="/obs/list.do")
	public @ResponseBody ModelAndView dataListdo(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		
		return mav;
	}
	
	
	// 장애이력 관리 목록 조회 (검색)
	@RequestMapping(value="/obs/list.ajax")
	public @ResponseBody ModelAndView reqList(HttpServletRequest request, @ModelAttribute("ObsVo") ObsVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<ObsVo> sList= null;
		
		try {				
			UserVO reqLoginVo = (UserVO) request.getSession().getAttribute("login");
			sList = obsService.selectDataList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	
}
