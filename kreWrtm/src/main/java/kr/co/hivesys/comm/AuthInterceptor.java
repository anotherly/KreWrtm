package kr.co.hivesys.comm;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.hivesys.auth.service.AuthService;
import kr.co.hivesys.user.vo.UserVO;

public class AuthInterceptor extends HandlerInterceptorAdapter {
	private static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

	@Resource(name = "authService")
	private AuthService authService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession(false);
		UserVO loginUser = session == null ? null : (UserVO) session.getAttribute("login");

		if (loginUser == null) {
			return rejectLogin(request, response);
		}

		Integer authId = loginUser.getAuthId();
		if (authId == null) {
			logger.warn("AUTH_ID가 없는 로그인 사용자 접근 차단. userId=" + loginUser.getUserId());
			return rejectForbidden(request, response);
		}

		Set<String> allowedUrls = getAllowedUrls(session, authId);
		String url = normalizeUrl(request);
		if (allowedUrls.contains(url)) {
			return true;
		}

		logger.warn("권한 없는 URL 접근 차단. userId=" + loginUser.getUserId()
				+ ", authId=" + authId + ", url=" + url);
		return rejectForbidden(request, response);
	}

	@SuppressWarnings("unchecked")
	private Set<String> getAllowedUrls(HttpSession session, Integer authId) {
		Integer cachedAuthId = (Integer) session.getAttribute("authId");
		Object cached = session.getAttribute("authUrlSet");
		if (authId.equals(cachedAuthId) && cached instanceof Set) {
			return (Set<String>) cached;
		}

		Set<String> allowedUrls = authService.selectAllowedUrls(authId);
		Map<String, Boolean> authUrlMap = new HashMap<String, Boolean>();
		for (String allowedUrl : allowedUrls) {
			authUrlMap.put(allowedUrl, Boolean.TRUE);
		}

		session.setAttribute("authId", authId);
		session.setAttribute("authUrlSet", allowedUrls);
		session.setAttribute("authUrlMap", authUrlMap);
		return allowedUrls;
	}

	private String normalizeUrl(HttpServletRequest request) {
		String contextPath = request.getContextPath();
		String uri = request.getRequestURI();
		String url = uri.substring(contextPath.length());
		return url.replaceFirst("\\.(do|ajax)$", "");
	}

	private boolean rejectLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		if (isAjax(request)) {
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
		} else {
			response.sendRedirect(request.getContextPath() + "/login/login.do");
		}
		return false;
	}

	private boolean rejectForbidden(HttpServletRequest request, HttpServletResponse response) throws IOException {
		if (isAjax(request)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
		} else {
			response.sendRedirect(request.getContextPath() + "/chart/main.do");
		}
		return false;
	}

	private boolean isAjax(HttpServletRequest request) {
		return request.getRequestURI().endsWith(".ajax")
				|| "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
	}
}
