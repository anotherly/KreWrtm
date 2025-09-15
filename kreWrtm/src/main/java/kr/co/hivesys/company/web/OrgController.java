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
import org.stringtemplate.v4.compiler.CodeGenerator.list_return;

import kr.co.hivesys.company.service.OrgService;
import kr.co.hivesys.company.vo.OrgVO;

@Controller
public class OrgController {
	
	public static final Logger logger = LoggerFactory.getLogger(OrgController.class);
	
	@Resource(name = "orgService")
	private OrgService orgService;

	public String url="";
	
	//주소에 맞게 매핑
	@RequestMapping("/org/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.단말기 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	
	//목록 조회
	@RequestMapping(value="/org/orgList.ajax")
	public @ResponseBody ModelAndView reqList( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("OrgVO") OrgVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<OrgVO> sList= null;
		try {
			sList = orgService.selectList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	//회사코드에 따른 조회
	@RequestMapping(value="/org/comCodeOrg.ajax")
	public @ResponseBody ModelAndView comCodeOrg( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("OrgVO") OrgVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<OrgVO> sList= null;
		try {
			sList = orgService.select(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	//등록 화면
	@RequestMapping(value="/org/orgInsert.do")
	public @ResponseBody ModelAndView reqInsert (HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		List<OrgVO> DataList = new ArrayList<>();
		try {
			DataList = orgService.selectList(new OrgVO());
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	//등록 저장
	@RequestMapping(value="/org/orgInsert.ajax")
	public ModelAndView insertReq(HttpSession httpSession, 
			HttpServletRequest request,Model model
			,@ModelAttribute("OrgVO") OrgVO inputVo
			) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			orgService.insert(inputVo);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
			mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	//(상셰)
	@RequestMapping(value="/org/orgDetail.do")
	public @ResponseBody ModelAndView reqDetail( 
	HttpServletRequest request, HttpServletResponse response
	,@ModelAttribute("OrgVO") OrgVO inputVo
	) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<OrgVO> data= new ArrayList<>();
		try {
			data = orgService.select(inputVo);
			mav.addObject("data", data);
			mav.setViewName(url);
			
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//사용자 수정 페이지 진입
	@RequestMapping(value="/org/orgUpdate.do")
	public @ResponseBody ModelAndView userUpdate( 
			HttpServletRequest request, HttpServletResponse response
			,@ModelAttribute("OrgVO") OrgVO inputVo
	) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.회원정보 조회 목록!!!!!!!!!!!!!!!!");
		
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		OrgVO data= null;
		
		List<OrgVO> DataList = new ArrayList<>();
		
		try {
			data = orgService.select(inputVo).get(0);
			mav.addObject("data", data);
			mav.setViewName(url);
		} catch (Exception e) {
			// TODO: handle exception
		}
		return mav;
	}
	
	//수정 저장
	@RequestMapping(value="/org/orgUpdate.ajax")
	public @ResponseBody ModelAndView reqUpdate(
			 HttpServletRequest request, HttpServletResponse response
			,@ModelAttribute("OrgVO") OrgVO inputVo
			) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		OrgVO thvo= null;
		try {
			orgService.update(inputVo);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//사용자 삭제
	@RequestMapping(value="/org/orgDelete.ajax")
	public @ResponseBody ModelAndView userDelete
	( @RequestParam(value="idArr[]")List<String> dataArr,HttpServletRequest request) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.회원정보 삭제!!!!!!!!!!!!!!!!");
		
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			orgService.deleteChk(dataArr);
		} catch (Exception e) {
			mav.addObject("msg","에러가 발생하였습니다");
		}
		return mav;
	}
	
}
