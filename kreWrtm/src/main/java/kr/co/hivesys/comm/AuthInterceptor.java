package kr.co.hivesys.comm;

import java.io.IOException;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
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
	private static final String FORBIDDEN_MESSAGE = "권한이 없습니다. 코레일 관리자에게 문의하세요.";
	private static final Map<String, Set<String>> DEPENDENT_URLS = createDependentUrls();

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
		if (allowedUrls.contains(url) || isDependentUrlAllowed(url, allowedUrls)) {
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

	private boolean isDependentUrlAllowed(String url, Set<String> allowedUrls) {
		Set<String> parentUrls = DEPENDENT_URLS.get(url);
		if (parentUrls == null) {
			return false;
		}
		for (String parentUrl : parentUrls) {
			if (allowedUrls.contains(parentUrl)) {
				return true;
			}
		}
		return false;
	}

	private static Map<String, Set<String>> createDependentUrls() {
		Map<String, Set<String>> urls = new HashMap<String, Set<String>>();
		urls.put("/user/selectOne", urlSet("/user/userInsert"));
		urls.put("/company/chkComCode", urlSet("/company/companyInsert", "/company/companyUpdate"));
		urls.put("/router/selectOne", urlSet("/router/routerInsert", "/router/routerUpdate"));
		urls.put("/router/selectCompany", urlSet("/router/routerInsert", "/router/routerUpdate",
				"/user/userInsert", "/user/userUpdate"));
		urls.put("/org/comCodeOrg", urlSet("/user/userInsert", "/user/userUpdate"));
		urls.put("/org/orgList", urlSet("/company/companyList"));
		urls.put("/org/orgInsert", urlSet("/company/companyInsert"));
		urls.put("/org/orgDetail", urlSet("/company/companyDetail"));
		urls.put("/org/orgUpdate", urlSet("/company/companyUpdate"));
		urls.put("/org/orgDelete", urlSet("/company/companyDelete"));
		urls.put("/search/routerlist", urlSet("/search/monitering"));
		urls.put("/search/subDetail", urlSet("/search/monitering"));
		return Collections.unmodifiableMap(urls);
	}

	private static Set<String> urlSet(String... urls) {
		return Collections.unmodifiableSet(new HashSet<String>(Arrays.asList(urls)));
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
			response.sendError(HttpServletResponse.SC_FORBIDDEN, FORBIDDEN_MESSAGE);
		} else {
			response.setStatus(HttpServletResponse.SC_FORBIDDEN);
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write("<!DOCTYPE html><html><head><meta charset=\"UTF-8\"></head><body>"
					+ "<script>alert('" + FORBIDDEN_MESSAGE + "');"
					+ "if(window.history.length > 1){window.history.back();}"
					+ "else{window.location.replace('" + request.getContextPath() + "/chart/main.do');}"
					+ "</script></body></html>");
		}
		return false;
	}

	private boolean isAjax(HttpServletRequest request) {
		/* .ajax 확장자라도 파일 다운로드처럼 브라우저가 직접 이동하는 요청이 있습니다. */
		return "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"));
	}
}
