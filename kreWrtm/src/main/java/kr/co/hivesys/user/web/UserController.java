package kr.co.hivesys.user.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import org.springframework.ui.Model;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.company.service.CompanyService;
import kr.co.hivesys.company.service.OrgService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.company.vo.OrgVO;
import kr.co.hivesys.user.service.UserService;
import kr.co.hivesys.user.vo.UserVO;

/**
 * 사용자 컨트롤러 클래스
 * @author 솔루션사업팀 정다빈
 * @since 2021.07.23
 * @version 1.0
 * @see
 *
 * << 개정이력(Modification Information) >>
 *
 *   수정일            수정자              수정내용
 *  -------    -------- ---------------------------
 *  2021.07.23  정다빈           최초 생성
 */

@Controller
public class UserController {

	public static final Logger logger = LoggerFactory.getLogger(UserController.class);
	public String url="";
	
	@Resource(name="userService")
	private UserService userService;
	
	@Resource(name = "orgService")
	private OrgService orgService;
	
	@Resource(name = "companyService")
	private CompanyService companyService;

	
	//주소에 맞게 매핑
	@RequestMapping(value= "/user/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.단말기 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}

	//단일 단말기 또는 volte조회
	@RequestMapping(value="/user/selectOne.ajax")
	public @ResponseBody ModelAndView selectOne( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("UserVO") UserVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<UserVO> sList= null;
		try {
			sList =userService.select(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//목록 조회
	@RequestMapping(value="/user/userList.ajax")
	public @ResponseBody ModelAndView List( 
			HttpServletRequest request
			//@RequestParam(required=false, value="idArr[]")List<String> listArr
			,@ModelAttribute("UserVO") UserVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");
		List<UserVO> sList= null;
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		CompanyVO ovo = nlvo;
		inputVo.setUserType(ovo.getUserType());
		inputVo.setCompanyCode(ovo.getCompanyCode());
		try {
			sList = userService.selectList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}

	//등록 화면
	@RequestMapping(value="/user/userInsert.do")
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
	@RequestMapping(value="/user/userInsert.ajax")
	public ModelAndView insert(HttpSession httpSession, 
			HttpServletRequest request,Model model
			,@ModelAttribute("UserVO") UserVO inputVo
			) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			//패스워드 암호화 처리
			String hashedPw = BCrypt.hashpw(inputVo.getUserPw(), BCrypt.gensalt());
			//vo에 암호화된 password 삽입
			inputVo.setUserPw(hashedPw);
			//쿼리
			userService.insert(inputVo);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
			mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	//(상셰)
	@RequestMapping(value= {"/user/userDetail.do","/user/userUpdate.do"})
	public @ResponseBody ModelAndView Detail( 
	HttpServletRequest request, HttpServletResponse response
	,@ModelAttribute("UserVO") UserVO inputVo
	) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView(url);
		UserVO data= null;
		//로그인한 세션을 받아와 주입
		UserVO nlvo = (UserVO) request.getSession().getAttribute("login");
		OrgVO ovo = nlvo;
		List<OrgVO> orgList = new ArrayList<>();
		List<CompanyVO> comList = new ArrayList<>();
		inputVo.setUserId(inputVo.getTagId());
		try {
			orgList = orgService.select(ovo);
			comList=companyService.select(ovo);
			data = userService.select(inputVo).get(0);
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
	@RequestMapping(value="/user/userUpdate.ajax")
	public @ResponseBody ModelAndView Update(
			 HttpServletRequest request, HttpServletResponse response
			,@ModelAttribute("UserVO") UserVO inputVo
			) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		UserVO thvo= null;
		try {
			//패스워드 암호화 처리
			if (inputVo.getUserPw()!=null && !inputVo.getUserPw().equals("")) {
				String hashedPw = BCrypt.hashpw(inputVo.getUserPw(), BCrypt.gensalt());
				//vo에 암호화된 password 삽입
				inputVo.setUserPw(hashedPw);
			}
			//쿼리
			userService.update(inputVo);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug(""+e);
			mav.addObject("msg","에러가 발생했습니다.");
		}
		return mav;
	}
	
	//사용자 삭제
	@RequestMapping(value="/user/userDelete.ajax")
	public @ResponseBody ModelAndView userDelete
	( @RequestParam(value="idArr[]")List<String> dataArr,HttpServletRequest request) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.회원정보 삭제!!!!!!!!!!!!!!!!");
		
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			userService.deleteChk(dataArr);
		} catch (Exception e) {
			mav.addObject("msg","에러가 발생하였습니다");
		}
		return mav;
	}
	
}
