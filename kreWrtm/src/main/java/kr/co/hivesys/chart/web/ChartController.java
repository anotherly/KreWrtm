package kr.co.hivesys.chart.web;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.SimpleDateFormat;

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

import kr.co.hivesys.chart.service.ChartService;

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
	public @ResponseBody ModelAndView mainChart( 
	HttpServletRequest request, HttpServletResponse response ) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];

	    ModelAndView mav = new ModelAndView("jsonView");

	    try {
	        File targetFolder1 = new File("C:/FirmWare/HIVE");
	        File targetFolder2 = new File("C:/FirmWare/KONE");
	        File targetFolder3 = new File("C:/FirmWare/KREG");
	        File targetFolder4 = new File("C:/FirmWare/KREM");

	        long size1 = getFolderSize(targetFolder1);
	        long size2 = getFolderSize(targetFolder2);
	        long size3 = getFolderSize(targetFolder3);
	        long size4 = getFolderSize(targetFolder4);

	        String sizeMB1 = String.format("%.2f", size1 / (1024.0 * 1024.0));
	        String sizeMB2 = String.format("%.2f", size2 / (1024.0 * 1024.0));
	        String sizeMB3 = String.format("%.2f", size3 / (1024.0 * 1024.0));
	        String sizeMB4 = String.format("%.2f", size4 / (1024.0 * 1024.0));

	        // 디렉토리 생성일 포맷 설정
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

	        String created1 = getCreationTime(targetFolder1, sdf);
	        String created2 = getCreationTime(targetFolder2, sdf);
	        String created3 = getCreationTime(targetFolder3, sdf);
	        String created4 = getCreationTime(targetFolder4, sdf);

	        mav.addObject("HIVE", sizeMB1);
	        mav.addObject("KONE", sizeMB2);
	        mav.addObject("KREG", sizeMB3);
	        mav.addObject("KREM", sizeMB4);

	        mav.addObject("hiveRegDt", created1);
	        mav.addObject("koneRegDt", created2);
	        mav.addObject("kregRegDt", created3);
	        mav.addObject("kremRegDt", created4);
	        
	        mav.setViewName(url);

	    } catch (Exception e) {
	        e.printStackTrace();
	        logger.debug("에러메시지 : " + e.toString());
	        mav.addObject("error", "에러 발생");
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
