package kr.co.hivesys.search.web;

import java.util.List;

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
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
	
	
	
	// 검색 & 모니터링 첫 검색 화면 진입
	@RequestMapping(value="/search/list.do")
	public @ResponseBody ModelAndView dataListdo(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		
		return mav;
	}
	
	
	
	// 검색 & 모니터링 검색어 입력 후 진입 화면
	@RequestMapping(value="/search/search.do")
	public @ResponseBody ModelAndView searchDo(HttpServletRequest request, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView("jsonView");

		String searchVal = inputVo.getSearchValue();
		
		mav.addObject("searchVal", searchVal);
		mav.setViewName(url);
		
		return mav;
	}
	
	
	// 장치 & 모니터링 실제 검색 기능
	@RequestMapping(value="/search/list.ajax")
	public @ResponseBody ModelAndView reqList(HttpServletRequest request, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<SearchVo> sList = null;
		List<SearchVo> companyList = null;
		List<SearchVo> deviceNameList = null;
		
		try {				
			applyCompanyScope(inputVo, request);
			String beforeComCode = inputVo.getCompanyCode();
			//beforeComCode가 비어있다면, 첫 진입
			if(beforeComCode == null || beforeComCode.isEmpty()) {
				UserVO reqLoginVo = (UserVO) request.getSession().getAttribute("login");
				String companyCode = reqLoginVo.getCompanyCode();
				String userT = reqLoginVo.getUserType();
				
				if(userT.equals("코레일")) { // 관리자 계정이라면 all로 전부 조회
					inputVo.setCompanyCode("all");
				} else {
					inputVo.setCompanyCode(companyCode);
				}
				
			} 

			sList = searchService.searchDataList(inputVo);  // 검색 결과
			companyList = searchService.companyTypeList(inputVo); 
			deviceNameList = searchService.deviceNameTypeList(inputVo);	
			
			mav.addObject("data", sList);
			mav.addObject("comData", companyList);
			mav.addObject("dnData", deviceNameList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	// 장치 & 모니터링 진입 후 검색 기능 
	@RequestMapping(value="/search/routerlist.ajax")
	public @ResponseBody ModelAndView reqRouterList(HttpServletRequest request, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<SearchVo> sList = null;
		
		try {				
			applyCompanyScope(inputVo, request);
			sList = searchService.searchRouterDataList(inputVo);  // 검색 결과
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	
	// 검색 & 모니터링 모니터링(상세)으로 이동
	@RequestMapping(value="/search/monitering.do")
	public @ResponseBody ModelAndView reqDetail( 
		HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
			url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			ModelAndView mav = new ModelAndView("jsonView");
			SearchVo data= null;
			try {
				if (inputVo.getDeviceId() == null || inputVo.getDeviceId().isEmpty()
						|| "undefined".equals(inputVo.getDeviceId())) {
					return new ModelAndView("redirect:/search/list.do");
				}
				applyCompanyScope(inputVo, request);
				data = searchService.selectDetail(inputVo);
				mav.addObject("data", data);
				mav.setViewName(url);
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug(""+e);
				mav.addObject("msg","에러가 발생했습니다.");
			}
			return mav;
	}
	

	@RequestMapping(value="/search/subDetail.do")
	public @ResponseBody ModelAndView reqSearchDetail( 
		HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
			url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			ModelAndView mav = new ModelAndView("jsonView");
			SearchVo data= null;
			try {
				applyCompanyScope(inputVo, request);
				data = searchService.selectDetail(inputVo);
				
				// datetime type 포맷팅
				String date = data.getRcvDt();
				if(date != null && !date.isEmpty()) {
					String dateFtm = date.substring(0, date.length() - 2);
					data.setRcvDt(dateFtm);
				}
				
				mav.addObject("data", data);
				mav.setViewName(url);
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug(""+e);
				mav.addObject("msg","에러가 발생했습니다.");
			}
			return mav;
	}
	
	
	

    /**
     * 무선품질시스템 전송 여부 설정.
     * 반드시 POST로, 세션의 회사 범위를 적용하여 해당 장비의 flag_send 한 컬럼만 변경한다.
     */
    @RequestMapping(value="/search/updateSendFlag.ajax", method=RequestMethod.POST)
    public @ResponseBody ModelAndView updateSendFlag(HttpServletRequest request,
            @ModelAttribute("SearchVo") SearchVo inputVo) {
        ModelAndView mav = new ModelAndView("jsonView");
        mav.addObject("result", 0);
        if (inputVo.getDeviceId() == null || inputVo.getDeviceId().trim().isEmpty()
                || !("0".equals(inputVo.getFlagSend()) || "1".equals(inputVo.getFlagSend()))) {
            mav.addObject("msg", "장비 정보 또는 전송 설정 값이 올바르지 않습니다.");
            return mav;
        }

        try {
            applyCompanyScope(inputVo, request);
            // 존재하지 않거나 타사 소속인 장비에 대한 수정은 차단한다.
            SearchVo existing = searchService.selectDetail(inputVo);
            if (existing == null) {
                mav.addObject("msg", "장비를 찾을 수 없거나 접근 권한이 없습니다.");
                return mav;
            }
            // 동일한 값 재저장도 정상 처리한다.
            int updated = searchService.updateSendFlag(inputVo);
            if (updated == 0) {
                // 동일 값이 이미 설정된 경우는 정상이나, 중간에 삭제된 장비는 실패 처리.
                SearchVo current = searchService.selectDetail(inputVo);
                if (current == null || !inputVo.getFlagSend().equals(current.getFlagSend())) {
                    mav.addObject("msg", "전송 설정을 저장하지 못했습니다. 장비 상태를 확인해 주세요.");
                    return mav;
                }
            }
            mav.addObject("result", 1);
            mav.addObject("flagSend", inputVo.getFlagSend());
        } catch (Exception e) {
            logger.error("무선품질시스템 전송 설정 저장 실패. deviceId=" + inputVo.getDeviceId(), e);
            mav.addObject("msg", "전송 설정 저장 중 오류가 발생했습니다.");
        }
        return mav;
    }


	// 원격 제어 버튼 클릭 시 실행
	@RequestMapping(value="/remote/remoteControll.ajax")
	public void remoteController(HttpServletRequest request, HttpServletResponse response, @ModelAttribute("SearchVo") SearchVo inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");

		try {			
			applyCompanyScope(inputVo, request);
			//수정 -> ip port pw 입력하여 로그인 처리
			SearchVo rvo = new SearchVo();
			rvo=searchService.findVnc(inputVo);
			
			if (rvo != null && rvo.getVncIp()!=null && rvo.getVncPort()!=null&& rvo.getVncPw()!=null
			) {
				
				String ip = rvo.getVncIp();
		        String port = rvo.getVncPort();
		        String pw = rvo.getVncPw();

		        // ---- 동적 파일 생성 (bat) ----
		        String fileName = "VNC_" + inputVo.getVolteNum() + ".bat";
		        //기존 ultra vnc
		        /*String content = "@echo off\r\n" +
		            "start \"\" \"C:\\\\Program Files\\\\uvnc bvba\\\\UltraVNC\\\\vncviewer.exe\" " +
		            "-autoconnect -connect " + ip + ":" + port + " -password " + pw + " -quickoption 4\r\n" +
		            "exit\r\n";*/
		        //신규 tight vnc
		        String content = "@echo off\r\n" +
		        	    "start \"\" \"C:\\Program Files (x86)\\TightVNC\\vncviewer.exe\" " +
		        	    "connect " + ip + ":" + port + "\r\n" +
		        	    "exit\r\n";
		        
		        // 응답 헤더 세팅
		        response.setContentType("application/octet-stream");
		        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		        response.getWriter().write(content);
				
		    }else {
		    	response.setContentType("text/html; charset=UTF-8");
		        response.getWriter().write(
		            "<script>alert('선택한 단말기 원격접속에 대한 IP/PORT/PW 정보가 없습니다.'); history.back();</script>"
		        );
		        response.getWriter().flush();
		        return;   // 중단
		    }

		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
	}

	private void applyCompanyScope(SearchVo inputVo, HttpServletRequest request) {
		UserVO login = (UserVO) request.getSession().getAttribute("login");
		if (!"코레일".equals(login.getUserType())) {
			inputVo.setScopeCompanyId(login.getCompanyId());
			inputVo.setCompanyCode(login.getCompanyCode());
		}
	}
}
