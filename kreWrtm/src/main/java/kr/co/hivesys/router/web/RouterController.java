package kr.co.hivesys.router.web;

import java.util.*;
import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.mysql.fabric.xmlrpc.base.Array;

import kr.co.hivesys.company.service.CompanyService;
import kr.co.hivesys.company.service.OrgService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.company.vo.OrgVO;
import kr.co.hivesys.router.service.RouterService;
import kr.co.hivesys.router.vo.RouterVO;
import kr.co.hivesys.user.vo.UserVO;

@Controller
public class RouterController{
	
	@Resource(name = "routerService")
	private RouterService routerService;
	
	@Resource(name = "orgService")
	private OrgService orgService;
	
	@Resource(name = "companyService")
	private CompanyService companyService;

	public static final Logger logger = LoggerFactory.getLogger(RouterController.class);
	
	public String url="";
	
	//주소에 맞게 매핑
	@RequestMapping("/router/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.단말기 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	//단일 단말기 또는 volte조회
	@RequestMapping(value="/router/selectOne.ajax")
	public @ResponseBody ModelAndView selectOne( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("routerVO") RouterVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<RouterVO> sList= null;
		try {
			sList =
					routerService.select(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//목록 조회
	@RequestMapping(value="/router/routerList.ajax")
	public @ResponseBody ModelAndView List( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("routerVO") RouterVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<RouterVO> sList= null;
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		CompanyVO ovo = nlvo;
		inputVo.setUserType(ovo.getUserType());
		inputVo.setCompanyCode(ovo.getCompanyCode());
		try {
			sList = routerService.selectList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}

	//등록 화면
	@RequestMapping(value="/router/routerInsert.do")
	public ModelAndView insertPage(HttpSession httpSession, 
			HttpServletRequest request,Model model
			) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView(url);
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		OrgVO ovo = nlvo;
		List<OrgVO> orgList = new ArrayList<>();
		List<CompanyVO> comList = new ArrayList<>();
		try {
			orgList = orgService.select(ovo);
			comList=companyService.select(ovo);

			mav.addObject("orgList", orgList);
			mav.addObject("comList", comList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//등록 저장
	@RequestMapping(value="/router/routerInsert.ajax")
	public ModelAndView insert(HttpSession httpSession, 
			HttpServletRequest request,Model model
			,@ModelAttribute("routerVO") RouterVO inputVo
			) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			routerService.insert(inputVo);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
			mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	//(상셰)
	@RequestMapping(value= {"/router/routerDetail.do","/router/routerUpdate.do"})
	public @ResponseBody ModelAndView Detail( 
	HttpServletRequest request, HttpServletResponse response
	,@ModelAttribute("routerVO") RouterVO inputVo
	) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView(url);
		RouterVO data= null;
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		OrgVO ovo = nlvo;
		List<OrgVO> orgList = new ArrayList<>();
		List<CompanyVO> comList = new ArrayList<>();
		try {
			orgList = orgService.select(ovo);
			comList=companyService.select(ovo);
			data = routerService.select(inputVo).get(0);
			mav.addObject("orgList", orgList);
			mav.addObject("comList", comList);
			mav.addObject("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//수정 저장
	@RequestMapping(value="/router/routerUpdate.ajax")
	public @ResponseBody ModelAndView Update(
			 HttpServletRequest request, HttpServletResponse response
			,@ModelAttribute("routerVO") RouterVO inputVo
			) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		RouterVO thvo= null;
		try {
			routerService.update(inputVo);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//사용자 삭제
	@RequestMapping(value="/router/routerDelete.ajax")
	public @ResponseBody ModelAndView Delete
	( @RequestParam(value="idArr[]")List<String> dataArr,HttpServletRequest request) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.회원정보 삭제!!!!!!!!!!!!!!!!");
		
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		 
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			routerService.deleteChk(dataArr);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
}
