package kr.co.hivesys.chart.web;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.hivesys.chart.service.ChartService;
import kr.co.hivesys.company.vo.CompanyVO;
import kr.co.hivesys.router.vo.RouterVO;

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
	
	
	@RequestMapping(value="/chart/main.do")
	public ModelAndView mainChart( 
	HttpServletRequest request, HttpServletResponse response ) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];

	    ModelAndView mav = new ModelAndView("jsonView");

	    try {
	        
	        // 제조사별 수신량/성능 차트를 위한 데이터 가져오기
	        // 1. 사용량 값 넣기
		        // 회사코드 가져오기
	        	List<CompanyVO> companyList = null;;
	        	companyList = chartService.getComCode();  // 비교용, 기본형
	        	
	        	List<CompanyVO> firmUseList = new ArrayList<>();  // 사용량 반환 
	        	
		        // 회사코드 별 C 드라이브 내 디렉토리 크기 및 생성된 날짜 구하기
	        	String basePath = "C:/SFTP/";
	            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	            
	            for (CompanyVO origin : companyList) {

	                CompanyVO copy = new CompanyVO();
	                copy.setCompanyCode(origin.getCompanyCode()); 
	                copy.setCompanyName(origin.getCompanyName()); 

	                // 디렉토리 크기
	                File targetFolder = new File(basePath + origin.getCompanyCode());
	                long size = getFolderSize(targetFolder);
	                String sizeMB = String.format("%.2f", size / (1024.0 * 1024.0));

	                // 생성일
	                String created = getCreationTime(targetFolder, sdf);

	                copy.setDirMb(sizeMB);
	                copy.setDirRegDt(created);

	                firmUseList.add(copy);
	            }
	            
	        	// 2. 회사별 금일 수신 데이터 가져오기 (회사별 데이터 개수 group)
	            List<CompanyVO> currentList = chartService.currentList();
	        
	        	// 3. 회사별 RSRQ 금일 데이터 평균치 계산 가져오기
	            List<CompanyVO> rsrqAvgList = chartService.rsrqAvgList();
	        
	        
	        	
	        // 화면으로 반환시킬 데이터
	        Map<String, Object> result = new HashMap<>();
	        result.put("x", companyList.stream().map(CompanyVO::getCompanyName).collect(Collectors.toList()));

	        result.put("사용량", firmUseList.stream().map(CompanyVO::getDirMb) .map(Double::valueOf).collect(Collectors.toList()));

	        result.put("수신 데이터량", currentList.stream().map(CompanyVO::getTodayCnt).collect(Collectors.toList()));

	        result.put("RSRQ", rsrqAvgList.stream().map(CompanyVO::getRsrqAvg).collect(Collectors.toList()));
	        
	        ObjectMapper mapper = new ObjectMapper();
	        String resultJson = mapper.writeValueAsString(result);
	        mav.addObject("resultJson", resultJson);
	        
	        
	        // 디렉토리 크기 합계 값 구하기
	        double firmUseCnt = firmUseList.stream().mapToDouble(vo -> Double.parseDouble(vo.getDirMb())).sum();
	        
	        mav.addObject("firmUseList", firmUseList);
	        mav.addObject("firmUseCnt",firmUseCnt);
	        
	        mav.setViewName(url);

	    } catch (Exception e) {
	        e.printStackTrace();
	        logger.debug("에러메시지 : " + e.toString());
	        mav.addObject("error", "에러 발생");
	    }
	    return mav;
	}
	
	
	
	// 나중에 합칠 예정
	@RequestMapping(value="/chart/routerList.ajax")
	public @ResponseBody ModelAndView reqRouterList(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<RouterVO> routerList = null;
		
		try {				
	        // 회사별 단말기 현황
	        routerList = chartService.routerList();
	        mav.addObject("routerList", routerList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	

	
	// 디렉토리 크기 구하기
	private long getFolderSize(File folder) {
	    long result = 0;

	    try {
	        File[] files = folder.listFiles();
	        if (files != null) {
	            for (File file : files) {
	                if (file.isFile()) {
	                    result += file.length();
	                } else {
	                    result += getFolderSize(file);
	                }
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return result;
	}
	
	
	// 디렉토리 생성날짜 가져오기
	private String getCreationTime(File folder, SimpleDateFormat sdf) {
		try {
	        Path path = folder.toPath();
	        BasicFileAttributes attr = Files.readAttributes(path, BasicFileAttributes.class);
	        return sdf.format(attr.creationTime().toMillis());
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "정보 없음";
	    }
	}
	
	
	
}
