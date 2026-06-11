package kr.co.hivesys.comm;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.hivesys.user.service.UserService;
import kr.co.hivesys.user.vo.UserVO;

//로그인 로그아웃 처리시 처음과 끝을 관장하며
//세션, 세션 어트리뷰트 값 생성 및 삭제를 담당
public class LoginInterceptor extends HandlerInterceptorAdapter {

	public static final String LOGIN = "login";
	public static final Logger logger = LoggerFactory.getLogger(LoginInterceptor.class);

	@Resource(name = "userService")
	private UserService userService;

	// 로그인 로그아웃시 본 메소드 진행 전 접속
	// 세션 값이 존재한다면 삭제 (로그아웃 처리)
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		logger.debug("▶▶▶▶▶▶▶.preHandle 메소드 진입");
		HttpSession httpSession = request.getSession();
		String requestUri = request.getRequestURI();

		logger.debug("▶▶▶▶▶▶▶.requestUri : " + requestUri);
		logger.debug("▶▶▶▶▶▶▶.httpSession : " + httpSession);
		logger.debug("▶▶▶▶▶▶▶.httpSession.getId : " + httpSession.getId());
		logger.debug("▶▶▶▶▶▶▶.httpSession : " + httpSession.getAttribute(LOGIN));
		try {
			// 로그아웃 요청이면 기존 로그인 정보 제거
			if (requestUri.endsWith("/login/logout.do")) {
				if (httpSession.getAttribute(LOGIN) != null) {
					logger.debug("▶▶▶▶▶▶▶.logout clear login data before");
					UserVO logoutVo = new UserVO();
					String uid = SessionListener.getInstance().getUserID(httpSession);
					logoutVo.setUserId(uid);

					httpSession.removeAttribute(LOGIN);
					SessionListener.getInstance().removeSession(httpSession);
					// userService.logoutUpdate(logoutVo);
				}
				return true;
			}

			// 로그인 화면/로그인 처리 진입 전에 기존 로그인 정보 제거
			if (httpSession.getAttribute(LOGIN) != null) {
				logger.debug("▶▶▶▶▶▶▶.clear login data before");
				UserVO logoutVo = new UserVO();
				String uid = SessionListener.getInstance().getUserID(httpSession);
				logoutVo.setUserId(uid);

				httpSession.removeAttribute(LOGIN);
				SessionListener.getInstance().removeSession(httpSession);
				// userService.logoutUpdate(logoutVo);
			}
		} catch (Exception e) {
			logger.error("LoginInterceptor preHandle 처리 중 오류 발생", e);
			return false;
		}
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		logger.debug("▶▶▶▶▶▶▶.postHandle 메소드 진입");
		logger.debug("▶▶▶▶▶▶▶.httpSession.getId : " + request.getSession().getId());

		if (modelAndView == null) {
			logger.debug("▶▶▶▶▶▶▶.modelAndView is null");
			return;
		}

		HttpSession httpSession = request.getSession();
		ModelMap modelMap = modelAndView.getModelMap();
		// UserController에서 받은 모델 어트리뷰트 값
		Object userVo = modelMap.get("user");

		// 정상적으로 로그인이 된 경우
		try {
			if (userVo != null) {
				logger.debug("▶▶▶▶▶▶▶.new login success");
				UserVO lvo = (UserVO) userVo;
				logger.debug("▶▶▶▶▶▶▶.login userId : " + lvo.getUserId());
				// web으로 어트리뷰트값 전송
				httpSession.setAttribute(LOGIN, userVo);
			}
		} catch (Exception e) {
			logger.error("LoginInterceptor postHandle 처리 중 오류 발생", e);
		}
	}

}
