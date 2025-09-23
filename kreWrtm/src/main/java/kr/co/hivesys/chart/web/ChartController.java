package kr.co.hivesys.chart.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.chart.vo.ChartVo;

@Controller
public class ChartController {

	public static final Logger logger = LoggerFactory.getLogger(ChartController.class);
	
	public String url="";
	
	@Resource(name="chartService")
	private ChartService chartService;
	
	//주소에 맞게 매핑
	@RequestMapping("/chart/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.단말기 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
	

	
	// 펌웨어 사용량 테이블
	@RequestMapping(value="/main/Datalist.ajax")
	public @ResponseBody ModelAndView reqDataList(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<ChartVo> sList= null;
		
		try {				
			sList = chartService.selectDataList();
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	
	
	
}
