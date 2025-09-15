package kr.co.hivesys.comm;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class AuthInterceptor extends HandlerInterceptorAdapter {

	public static final Logger logger = LoggerFactory.getLogger(AuthInterceptor.class);

	/**
	 * 컨트롤러 수행전에 세션 정보가 있는지 확인하는 처리..
	 */
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		logger.debug("☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎.AUTH -  프리핸들 request : " + request);
		logger.debug("☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎.AUTH -  프리핸들 request.getSession() : " + request.getSession());
		logger.debug(request.getRequestURL().toString());
		String furl = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		boolean rtn = false;//최종 t/f 리턴값
		boolean ynUrl = false; // 권한관리 체크에 포함된 url인지 아닌지
		// 새로고침이나 유효하지 않은 요청 제외하고는 권한체크
		if (request.getSession().getAttribute("login") != null) {
			logger.debug("☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎.   request.getSession().getAttribute(login) : " + request.getSession().getAttribute("login"));
			String nowUrl = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			String[] urlList = nowUrl.split("/", 11);
			nowUrl="";
			for (int i = 1; i < urlList.length-1; i++) {
				nowUrl += "/"+urlList[i];
			}
		} else {
			logger.debug("♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨세션 값이 존재하지 않음");
			rtn =false;
			return false;
		}
		return rtn;
	}

	/**
	 * 세션에 메뉴권한(SessionVO)이 있는지 여부로 메뉴권한 여부를 체크한다. 계정정보(SessionVO)가 없다면, 로그인 페이지로
	 * 이동한다.
	 */
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		logger.debug("♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨♨.AUTH - postHandle 메소드 진입 : ");
	}
	/**
	 * 
	 */
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		logger.info("★★★★★★★★★★★★★★★★★.Interceptor: afterCompletion");
		super.afterCompletion(request, response, handler, ex);
	}

} // end class