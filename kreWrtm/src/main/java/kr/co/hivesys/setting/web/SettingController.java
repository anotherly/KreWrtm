package kr.co.hivesys.setting.web;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.auth.service.AuthService;
import kr.co.hivesys.auth.vo.AuthVO;
import kr.co.hivesys.comm.SessionListener;
import kr.co.hivesys.setting.service.SettingService;
import kr.co.hivesys.user.vo.UserVO;

@Controller
public class SettingController {

    private static final Logger logger = LoggerFactory.getLogger(SettingController.class);

    @Resource(name = "authService")
    private AuthService authService;

    @Resource(name = "settingService")
    private SettingService settingService;

    @RequestMapping(value = "/setting/main.do")
    public ModelAndView main(HttpServletRequest request) throws Exception {
        if (!isKorailAdmin(request)) {
            return new ModelAndView("redirect:/chart/main.do");
        }

        ModelAndView mav = new ModelAndView("/setting/main");
        mav.addObject("authList", authService.selectAuthList());
        mav.addObject("dashboardRefreshSeconds", settingService.selectDashboardRefreshSeconds());
        return mav;
    }

    @RequestMapping(value = "/setting/saveRefresh.ajax")
    public @ResponseBody ModelAndView saveRefresh(HttpServletRequest request,
            @RequestParam("refreshSeconds") Integer refreshSeconds) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView");
        if (!isKorailAdmin(request)) {
            mav.addObject("result", "fail");
            mav.addObject("message", "권한이 없습니다.");
            return mav;
        }

        try {
            settingService.updateDashboardRefreshSeconds(refreshSeconds == null ? 0 : refreshSeconds.intValue());
            mav.addObject("result", "success");
            mav.addObject("message", "대시보드 갱신 주기를 적용했습니다.");
        } catch (Exception e) {
            logger.error("대시보드 갱신 주기 저장 중 오류", e);
            mav.addObject("result", "fail");
            mav.addObject("message", "갱신 주기를 저장하지 못했습니다.");
        }
        return mav;
    }

    @RequestMapping(value = "/setting/authUrls.ajax")
    public @ResponseBody ModelAndView authUrls(HttpServletRequest request,
            @RequestParam("authId") Integer authId) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView");
        if (!isKorailAdmin(request)) {
            mav.addObject("result", "fail");
            mav.addObject("message", "권한이 없습니다.");
            return mav;
        }

        try {
            List<AuthVO> urlList = authService.selectAuthUrlSettings(authId);
            mav.addObject("result", "success");
            mav.addObject("urlList", urlList);
        } catch (Exception e) {
            logger.error("권한 URL 목록 조회 중 오류", e);
            mav.addObject("result", "fail");
            mav.addObject("message", "접근 메뉴를 조회하지 못했습니다.");
            mav.addObject("urlList", Collections.emptyList());
        }
        return mav;
    }

    @RequestMapping(value = "/setting/saveAuthUrls.ajax")
    public @ResponseBody ModelAndView saveAuthUrls(HttpServletRequest request,
            @RequestParam("authId") Integer authId,
            @RequestParam(value = "urlList[]", required = false) List<String> urlList) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView");
        if (!isKorailAdmin(request)) {
            mav.addObject("result", "fail");
            mav.addObject("message", "권한이 없습니다.");
            return mav;
        }

        try {
            authService.updateAuthUrls(authId, urlList);
            SessionListener.getInstance().clearAuthCacheByAuthId(authId);
            mav.addObject("result", "success");
            mav.addObject("message", "접근 권한을 저장했습니다.");
        } catch (Exception e) {
            logger.error("권한 URL 저장 중 오류", e);
            mav.addObject("result", "fail");
            mav.addObject("message", "접근 권한 저장에 실패했습니다.");
        }
        return mav;
    }

    private boolean isKorailAdmin(HttpServletRequest request) {
        Object sessionLogin = request.getSession().getAttribute("login");
        if (!(sessionLogin instanceof UserVO)) {
            return false;
        }
        UserVO login = (UserVO) sessionLogin;
        return Integer.valueOf(1).equals(login.getAuthId()) && "코레일".equals(login.getUserType());
    }
}
