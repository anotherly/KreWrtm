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
		RouterVO sList= null;
		try {
			normalizeVolteNum(inputVo);
			// VoLTE 번호는 테이블 전체에서 UNIQUE이므로 중복 확인 시 회사 범위를 적용하지 않는다.
			// 장치 PK로 조회하는 경우에만 로그인 사용자의 회사 범위를 적용한다.
			if (inputVo.getTagId() != null && !inputVo.getTagId().isEmpty()) {
				applyCompanyScope(inputVo, (UserVO) request.getSession().getAttribute("login"));
			}
			sList = routerService.select(inputVo);
			if (sList == null) {
		        mav.addObject("result", 0);
		    } else {
		        // 결과가 있는 경우
		        mav.addObject("result", 1);
		    }
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
		inputVo.setCompanyId(ovo.getCompanyId());
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
			orgList = routerService.userTypeSelect(ovo);
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
			normalizeVolteNum(inputVo);
			applyCompanyScope(inputVo, (UserVO) request.getSession().getAttribute("login"));
			routerService.insert(inputVo);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
			mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	//(상세)
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
			applyCompanyScope(inputVo, nlvo);
			orgList = routerService.userTypeSelect(ovo);
			data = routerService.select(inputVo);
			
			mav.addObject("orgList", orgList);
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
			normalizeVolteNum(inputVo);
			UserVO login = (UserVO) request.getSession().getAttribute("login");
			applyCompanyScope(inputVo, login);
			if (!"코레일".equals(login.getUserType())) inputVo.setScopeCompanyId(login.getCompanyId());
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
			UserVO login = (UserVO) request.getSession().getAttribute("login");
			String companyId = "코레일".equals(login.getUserType()) ? null : login.getCompanyId();
			routerService.deleteChk(dataArr, companyId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	
	
	// 옵션 변경 시 실행
	@RequestMapping(value="/router/selectCompany.ajax")
	public @ResponseBody ModelAndView selectCompany
	( @ModelAttribute("RouterVO") RouterVO inputVo ,HttpServletRequest request) throws Exception{
	
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		 
		ModelAndView mav = new ModelAndView("jsonView");
		List<RouterVO> comList = null;
		
		try {
			UserVO login = (UserVO) request.getSession().getAttribute("login");
			if (!"코레일".equals(login.getUserType())) inputVo.setCompanyId(login.getCompanyId());
			comList = routerService.selectCompany(inputVo);
			mav.addObject("data",comList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}

	private void applyCompanyScope(RouterVO inputVo, UserVO login) {
		if (!"코레일".equals(login.getUserType())) {
			inputVo.setCompanyId(login.getCompanyId());
			inputVo.setCompanyCode(login.getCompanyCode());
			inputVo.setScopeCompanyId(login.getCompanyId());
		}
	}

	private void normalizeVolteNum(RouterVO inputVo) {
		if (inputVo.getVolteNum() != null) {
			inputVo.setVolteNum(inputVo.getVolteNum().replaceAll("[^0-9]", ""));
		}
	}
	
	
}
