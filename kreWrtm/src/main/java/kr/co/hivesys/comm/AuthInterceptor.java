package kr.co.hivesys.comm;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashSet;
import java.util.Set;

import javax.sql.DataSource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.co.hivesys.user.vo.UserVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AuthInterceptor extends HandlerInterceptorAdapter {

	public static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

	private DataSource dataSource;

	public void setDataSource(DataSource dataSource) {
		this.dataSource = dataSource;
	}

	@Override
	@SuppressWarnings("unchecked")
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		String url = normalizeUrl(request);

		if (isPublicUrl(url)) {
			return true;
		}

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("login") == null) {
			if (isAjaxRequest(request)) {
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
			} else {
				response.sendRedirect(request.getContextPath() + "/login/login.do");
			}
			return false;
		}

		UserVO loginUser = (UserVO) session.getAttribute("login");
		Integer authId = loginUser.getAuthId();
		if (authId == null) {
			authId = 4;
		}

		Integer sessionAuthId = (Integer) session.getAttribute("authId");
		Set<String> allowedUrls = (Set<String>) session.getAttribute("authUrlSet");
		if (allowedUrls == null || !authId.equals(sessionAuthId)) {
			allowedUrls = selectAllowedUrls(authId);
			session.setAttribute("authId", authId);
			session.setAttribute("authUrlSet", allowedUrls);
		}

		if (!isManagedUrl(url)) {
			return true;
		}

		if (allowedUrls.contains(url)) {
			return true;
		}

		logger.debug("권한 없는 URL 접근 차단. userId="+ loginUser.getUserId()+ ", authId=" + authId+ ", url=" + url);
		if (isAjaxRequest(request)) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "권한이 없습니다.");
		} else {
			response.sendRedirect(request.getContextPath() + "/chart/main.do");
		}
		return false;
	}

	private String normalizeUrl(HttpServletRequest request) {
		String uri = request.getRequestURI();
		String contextPath = request.getContextPath();
		if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
			uri = uri.substring(contextPath.length());
		}
		int semicolonIndex = uri.indexOf(';');
		if (semicolonIndex >= 0) {
			uri = uri.substring(0, semicolonIndex);
		}
		if (uri.endsWith(".do")) {
			uri = uri.substring(0, uri.length() - 3);
		} else if (uri.endsWith(".ajax")) {
			uri = uri.substring(0, uri.length() - 5);
		}
		return uri;
	}

	private boolean isPublicUrl(String url) {
		return url == null
				|| url.isEmpty()
				|| "/".equals(url)
				|| url.startsWith("/login/")
				|| url.startsWith("/cmn/")
				|| url.startsWith("/images/")
				|| url.startsWith("/css/")
				|| url.startsWith("/js/")
				|| url.startsWith("/resources/")
				|| url.startsWith("/firmwareFile/")
				|| url.startsWith("/dataroomFile/");
	}

	private boolean isAjaxRequest(HttpServletRequest request) {
		String uri = request.getRequestURI();
		String requestedWith = request.getHeader("X-Requested-With");
		return uri.endsWith(".ajax") || "XMLHttpRequest".equalsIgnoreCase(requestedWith);
	}

	private boolean isManagedUrl(String url) throws Exception {
		String sql = "SELECT COUNT(*) FROM tbl_auth_url WHERE URL = ? AND USE_YN = 'Y'";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, url);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() && rs.getInt(1) > 0;
			}
		}
	}

	private Set<String> selectAllowedUrls(Integer authId) throws Exception {
		Set<String> allowedUrls = new HashSet<>();
		String sql = "SELECT URL FROM tbl_auth_url WHERE AUTH_ID = ? AND USE_YN = 'Y'";
		try (Connection conn = dataSource.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, authId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					allowedUrls.add(rs.getString("URL"));
				}
			}
		}
		return allowedUrls;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		super.afterCompletion(request, response, handler, ex);
	}
}
