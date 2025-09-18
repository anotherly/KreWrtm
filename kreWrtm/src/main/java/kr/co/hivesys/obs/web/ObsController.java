package kr.co.hivesys.obs.web;

import java.util.List;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.comm.file.FileUploadSave;
import kr.co.hivesys.comm.file.vo.FileVo;
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
	
	
	// 자료실 게시판 상세 화면으로 이동
	@RequestMapping(value="/obs/detail.do")
	public @ResponseBody ModelAndView reqBoardDetail( 
		HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("ObsVO") ObsVo inputVo) throws Exception{
			url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			ModelAndView mav = new ModelAndView("jsonView");
			ObsVo data= null;
			try {
				data = obsService.selectData(inputVo);
				mav.addObject("data", data);
				mav.setViewName(url);
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug(""+e);
				mav.addObject("msg","에러가 발생했습니다.");
			}
			return mav;
	}
	
	
	
	// 장애이력 관리 등록 화면으로 이동   
	@RequestMapping(value="/obs/insert.do")
	public @ResponseBody ModelAndView reqInsert (HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);			
		
		return mav;
	}
		
	// 장애이력 등록
	@RequestMapping(value="/obs/insert.ajax")
	public ModelAndView insertReq(HttpSession httpSession, HttpServletRequest request, Model model ,@ModelAttribute("ObsVo") ObsVo inputVo) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");	
		try {		
			String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
			StringBuilder sb = new StringBuilder();
			Random random = new Random();

			for (int i = 0; i < 5; i++) { // 5자리 랜덤 문자열
			    sb.append(chars.charAt(random.nextInt(chars.length())));
			}

			String randomId = sb.toString();
			inputVo.setObsId(randomId);  // 랜덤 문자열 5자 삽입
			
			obsService.insertData(inputVo);
		} catch (Exception e) {
				logger.debug("에러메시지 : "+e.toString());
				e.printStackTrace();
				mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
		
		
	
	// 장애이력 관리 수정으로 이동
	@RequestMapping(value="/obs/update.do")
	public @ResponseBody ModelAndView userUpdate(HttpServletRequest request, HttpServletResponse response , @RequestParam("obsId") String obsId) throws Exception{	
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];		
		ModelAndView mav = new ModelAndView("jsonView");
		
		ObsVo data= null;
		ObsVo param = new ObsVo();
		param.setObsId(obsId);
		
		try {
			data = obsService.selectData(param);	
			mav.addObject("data", data);
			mav.setViewName(url);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
		}		
		return mav;
	}
	
	
	
	
	// 장애이력 수정 기능
	@RequestMapping(value="/obs/update.ajax")
    public ModelAndView updateNotice(HttpSession httpSession, HttpServletRequest request, Model model, @ModelAttribute ObsVo inputVo) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView"); 

        try {
        	obsService.updateObs(inputVo);
        
        } catch (Exception e) {
        	logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
        }

        return mav;
    }
	
	
	
	
	// 장애이력 관리 삭제
	@RequestMapping(value="obs/delete.ajax")
	public @ResponseBody ModelAndView obsDelete
	( @RequestParam(value="idArr[]")List<String> dataArr, HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
		ModelAndView mav = new ModelAndView("jsonView");
		try {
			obsService.deleteData(dataArr);
		} catch (Exception e) {
			mav.addObject("msg","에러가 발생하였습니다");
		}
		return mav;
	}
	
	
	
	
	
}
