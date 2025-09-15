package kr.co.hivesys.company.web;

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

import kr.co.hivesys.company.service.CompanyService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.company.vo.OrgVO;
import kr.co.hivesys.user.vo.UserVO;

@Controller
public class CompanyController{
	@Resource(name = "companyService")
	private CompanyService companyService;

	public static final Logger logger = LoggerFactory.getLogger(CompanyController.class);
	
	public String url="";
	
	//주소에 맞게 매핑
	@RequestMapping("/company/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.단말기 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	//목록 조회
	@RequestMapping(value="/company/companyList.ajax")
	public @ResponseBody ModelAndView List( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("CompanyVO") CompanyVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<CompanyVO> sList= null;
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		CompanyVO ovo = nlvo;
		inputVo.setUserType(ovo.getUserType());
		inputVo.setCompanyCode(ovo.getCompanyCode());
		try {
			sList = companyService.selectList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//목록 조회
	@RequestMapping(value="/company/chkComCode.ajax")
	public @ResponseBody ModelAndView chkComCode( 
			HttpServletRequest request
			,@ModelAttribute("CompanyVO") CompanyVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<CompanyVO> sList= null;
		try {
			sList = companyService.select(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//등록 저장
	@RequestMapping(value="/company/companyInsert.ajax")
	public ModelAndView insert(HttpSession httpSession, 
			HttpServletRequest request,Model model
			,@ModelAttribute("CompanyVO") CompanyVO inputVo
			) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			companyService.insert(inputVo);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
			mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	//(상셰)
	@RequestMapping(value= {"/company/companyDetail.do","/company/companyUpdate.do"})
	public @ResponseBody ModelAndView Detail( 
	HttpServletRequest request, HttpServletResponse response
	,@ModelAttribute("CompanyVO") CompanyVO inputVo
	) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView(url);
		CompanyVO data= null;
		try {
			data = companyService.selectList(inputVo).get(0);
			mav.addObject("data", data);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//수정 저장
	@RequestMapping(value="/company/companyUpdate.ajax")
	public @ResponseBody ModelAndView Update(
			 HttpServletRequest request, HttpServletResponse response
			,@ModelAttribute("CompanyVO") CompanyVO inputVo
			) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		CompanyVO thvo= null;
		try {
			companyService.update(inputVo);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//사용자 삭제
	@RequestMapping(value="/company/companyDelete.ajax")
	public @ResponseBody ModelAndView Delete
	( @RequestParam(value="idArr[]")List<String> dataArr,HttpServletRequest request) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.회원정보 삭제!!!!!!!!!!!!!!!!");
		
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			companyService.deleteChk(dataArr);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
}
