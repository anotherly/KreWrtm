package kr.co.hivesys.dataroom.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import kr.co.hivesys.comm.file.FileUploadSave;
import kr.co.hivesys.comm.file.vo.FileVo;
import kr.co.hivesys.dataroom.service.DataroomService;
import kr.co.hivesys.dataroom.vo.DataroomVO;
import kr.co.hivesys.user.vo.UserVO;
import kr.co.hivesys.user.web.UserController;

@Controller
public class DataroomController implements ApplicationContextAware{

	public static final Logger logger = LoggerFactory.getLogger(UserController.class);
	public String url="";
	private WebApplicationContext context = null;
	
	@Resource(name="dataroomService")
	private DataroomService dataroomService;
	
	
	//주소에 맞게 매핑
	@RequestMapping(value= "/dataroom/*.do")
	public String urlMapping(HttpSession httpSession, HttpServletRequest request,Model model
			) throws Exception{
		logger.debug("▶▶▶▶▶▶▶.자료실 최초 컨트롤러");
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		logger.debug("▶▶▶▶▶▶▶.보내려는 url : "+url);
		return url;
	}
		
	
	// 자료실 목록 화면 진입
	@RequestMapping(value="/dataroom/list.do")
	public @ResponseBody ModelAndView dataListdo(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		
		return mav;
	}
	
	// 자료실 게시판 목록 화면 진입    
	@RequestMapping(value="/dataroom/board/list.do")
	public @ResponseBody ModelAndView databoardListdo(HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
			
		return mav;
	}
	
	
	// 자료실 목록 조회 (검색)
	@RequestMapping(value="/dataroom/list.ajax")
	public @ResponseBody ModelAndView reqList(HttpServletRequest request, @ModelAttribute("DataroomVO") DataroomVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		List<DataroomVO> sList= null;
		
		try {				
			UserVO reqLoginVo = (UserVO) request.getSession().getAttribute("login");
			sList = dataroomService.selectDataList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	// 자료실 게시판 목록 조회 (검색)
	@RequestMapping(value="/dataroom/board/list.ajax")
	public @ResponseBody ModelAndView reqBoardList(HttpServletRequest request, @ModelAttribute("DataroomVO") DataroomVO inputVo) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
		ModelAndView mav = new ModelAndView("jsonView");
		List<DataroomVO> sList= null;
			
		try {				
			UserVO reqLoginVo = (UserVO) request.getSession().getAttribute("login");
			sList = dataroomService.selectDataBoardList(inputVo);
			mav.addObject("data", sList);
		} catch (Exception e) {
			e.printStackTrace();
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	// 자료실 상세 화면으로 이동
	@RequestMapping(value="/dataroom/detail.do")
	public @ResponseBody ModelAndView reqDetail( 
		HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("DataroomVO") DataroomVO inputVo) throws Exception{
			url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			ModelAndView mav = new ModelAndView("jsonView");
			DataroomVO data= null;
			try {
				data = dataroomService.selectData(inputVo);
				mav.addObject("data", data);
				mav.setViewName(url);
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug(""+e);
				mav.addObject("msg","에러가 발생했습니다.");
			}
			return mav;
	}
	
	// 자료실 게시판 상세 화면으로 이동
	@RequestMapping(value="/dataroom/board/detail.do")
	public @ResponseBody ModelAndView reqBoardDetail( 
		HttpServletRequest request, HttpServletResponse response ,@ModelAttribute("DataroomVO") DataroomVO inputVo) throws Exception{
			url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
			ModelAndView mav = new ModelAndView("jsonView");
			DataroomVO data= null;
			try {
				data = dataroomService.selectDataBoard(inputVo);
				mav.addObject("data", data);
				mav.setViewName(url);
				
			} catch (Exception e) {
				e.printStackTrace();
				logger.debug(""+e);
				mav.addObject("msg","에러가 발생했습니다.");
			}
			return mav;
	}
	
	
	// 자료 등록 화면으로 이동   
	@RequestMapping(value="/dataroom/insert.do")
	public @ResponseBody ModelAndView reqInsert (HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
		
		try {

		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	// 게시판 등록 화면으로 이동   
	@RequestMapping(value="/dataroom/board/insert.do")
	public @ResponseBody ModelAndView reqBoardInsert (HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		ModelAndView mav = new ModelAndView(url);
			
		try {

		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
		}
		return mav;
	}
	
	
	
	// 자료 등록
	@RequestMapping(value="/dataroom/insert.ajax")
	public ModelAndView insertReq(HttpSession httpSession, HttpServletRequest request, Model model
			,@ModelAttribute("FileVo") FileVo inputVo, @RequestParam("multiFile") List<MultipartFile> multiFileList ) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");	
		try {
			String fileType = "I";
			String fdir = context.getServletContext().getRealPath("/")+"dataroomFile/";
			FileUploadSave fus = new FileUploadSave();
			FileVo fileList = fus.fileUploadMultipleDataroom(multiFileList,fdir,inputVo, fileType);
			
			dataroomService.insertFile(fileList);
		} catch (Exception e) {
				logger.debug("에러메시지 : "+e.toString());
				e.printStackTrace();
				mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	
	// 게시판 등록
	@RequestMapping(value="/dataroom/board/insert.ajax")
	public ModelAndView insertReqBoard(HttpSession httpSession, HttpServletRequest request, Model model
		,@ModelAttribute("FileVo") FileVo inputVo, @RequestParam("multiFile") List<MultipartFile> multiFileList ) throws Exception{
		ModelAndView mav = new ModelAndView("jsonView");	
		try {
			String fileType = "I";  // 파일 타입 설정 (I : insert)
			String fdir = context.getServletContext().getRealPath("/")+"dataBoardFile/"; // 기본 경로 설정
				
			FileUploadSave fus = new FileUploadSave();
			FileVo fileList = fus.fileUploadMultipleDataroom(multiFileList,fdir,inputVo, fileType);

			// 추가 정보 삽입
			UserVO user = (UserVO) request.getSession().getAttribute("login");  // 세션에서 로그인 정보 가져오기
			String writerId = user.getUserId(); // 세션에서 userId 추출
				
			fileList.setWriterId(writerId); // 작성자 id 삽입
			fileList.setBoardContent(inputVo.getBoardContent());  // 게시판 내용 삽입
			
			// 첨부파일 없을 경우
			if(multiFileList.size() == 0) {
				String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	            String randomString = new java.security.SecureRandom()
	                .ints(5, 0, characters.length())
	                .mapToObj(a -> characters.charAt(a))
	                .collect(StringBuilder::new, StringBuilder::append, StringBuilder::append)
	                .toString();
	            
				fileList.setFileTitle(inputVo.getFileTitle());
				fileList.setFileId(randomString);
				fileList.setFileDir("/" + randomString + "/");
			}
			
			dataroomService.insertFileBoard(fileList);  // insert 작업
		} catch (Exception e) {
				logger.debug("에러메시지 : "+e.toString());
				e.printStackTrace();
				mav.addObject("msg","저장에 실패하였습니다");
		}
		return mav;
	}
	
	
	// 자료실 수정 화면으로 이동
	@RequestMapping(value="/dataroom/update.do")
	public @ResponseBody ModelAndView userUpdate(HttpServletRequest request, HttpServletResponse response , @RequestParam("fileId") String fileId) throws Exception{	
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];		
		ModelAndView mav = new ModelAndView("jsonView");
		
		DataroomVO data= null;
		DataroomVO param = new DataroomVO();
		param.setFileId(fileId);
		
		try {
			data = dataroomService.selectData(param);
	
			mav.addObject("data", data);
			mav.setViewName(url);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
		}
		
		return mav;
	}
	
	
	// 게시판 수정 화면으로 이동
	@RequestMapping(value="/dataroom/board/update.do")
	public @ResponseBody ModelAndView dataBoardUpdate(HttpServletRequest request, HttpServletResponse response , @RequestParam("fileId") String fileId) throws Exception{	
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];		
		ModelAndView mav = new ModelAndView("jsonView");
			
		DataroomVO data= null;
		DataroomVO param = new DataroomVO();
		param.setFileId(fileId);
			
		try {
			data = dataroomService.selectDataBoard(param);
		
			mav.addObject("data", data);
			mav.setViewName(url);
		} catch (Exception e) {
			logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
		}
			
		return mav;
	}
	
	
	
	// 자료실 자료 수정 기능
	@RequestMapping(value="/dataroom/update.ajax")
    public ModelAndView updateNotice(@RequestParam("multiFile") List<MultipartFile> multiFileList, HttpSession httpSession, HttpServletRequest request, Model model, 
    		@ModelAttribute FileVo inputVo) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView"); 

        try {
        	FileVo fileList = null;
        	
        	if(multiFileList != null && !multiFileList.isEmpty()) {  // 수정 할 첨부파일이 있다면 실행
        		String fileId = inputVo.getFileId();   
            	String fileName = multiFileList.get(0).getOriginalFilename();
            	String fileDir = context.getServletContext().getRealPath("/")+"dataroomFile/" + fileId + "/";
            	String fileType = "U";
            	
            	FileUploadSave fus = new FileUploadSave();
            	fus.deleteFile(fileDir, fileName); // 기존 파일 삭제
            	fileList = fus.fileUploadMultipleDataroom(multiFileList, fileDir, inputVo , fileType);  // 신규 파일 업로드(수정)
            	
            	dataroomService.updateFile(fileList);
        	} else {
                dataroomService.updateFile(inputVo); // DB 정보 수정
        	}
        
        } catch (Exception e) {
        	logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
        }

        return mav;
    }
	
	
	// 게시판 수정 기능
	@RequestMapping(value="/dataroom/board/update.ajax")
    public ModelAndView updateBoard(@RequestParam("multiFile") List<MultipartFile> multiFileList, HttpSession httpSession, HttpServletRequest request, Model model, 
    		@ModelAttribute FileVo inputVo) throws Exception {
        ModelAndView mav = new ModelAndView("jsonView"); 

        try {
        	FileVo fileList = null;
        	
        	if(multiFileList != null && !multiFileList.isEmpty()) {  // 수정 할 첨부파일이 있다면 실행
        		String fileId = inputVo.getFileId();   
            	String fileName = multiFileList.get(0).getOriginalFilename();
            	String fileDir = context.getServletContext().getRealPath("/")+"dataBoardFile/" + fileId + "/";
            	String fileType = "U";
            	
            	FileUploadSave fus = new FileUploadSave();
            	fus.deleteFile(fileDir, fileName); // 기존 파일 삭제
            	fileList = fus.fileUploadMultipleDataroom(multiFileList, fileDir, inputVo , fileType);  // 신규 파일 업로드(수정)
            	
            	fileList.setBoardContent(inputVo.getBoardContent());
            	
            	dataroomService.updateFileBoard(fileList);
        	} else {
                dataroomService.updateFileBoard(inputVo); // DB 정보 수정
        	}
        
        } catch (Exception e) {
        	logger.debug("에러메시지 : "+e.toString());
			e.printStackTrace();
        }

        return mav;
    }
	
	
	// 자료실 자료 삭제  
	@RequestMapping(value="/dataroom/delete.ajax")
	public @ResponseBody ModelAndView dataroomDelete
	( @RequestParam(value="idArr[]")List<String> dataArr,HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
		
		ModelAndView mav = new ModelAndView("jsonView");
		try {
        	String fileDir = context.getServletContext().getRealPath("/")+"dataroomFile/";
        	
			FileUploadSave fus = new FileUploadSave();
			fus.ArrdeleteFile(fileDir, dataArr); 
			
			dataroomService.deleteData(dataArr);
		} catch (Exception e) {
			mav.addObject("msg","에러가 발생하였습니다");
		}
		return mav;
	}
	
	
	
	// 게시판 자료 삭제  
	@RequestMapping(value="/dataroom/board/delete.ajax")
	public @ResponseBody ModelAndView dataroomBoardDelete (@RequestParam(value="idArr[]") List<String> dataArr, HttpServletRequest request) throws Exception{
		url = request.getRequestURI().substring(request.getContextPath().length()).split(".do")[0];
			
		ModelAndView mav = new ModelAndView("jsonView");
		try {
	        String fileDir = context.getServletContext().getRealPath("/")+"dataBoardFile/";
	        	
			FileUploadSave fus = new FileUploadSave();
			fus.ArrdeleteFile(fileDir, dataArr); 
				
			dataroomService.deleteDataBaord(dataArr);
		} catch (Exception e) {
			mav.addObject("msg","에러가 발생하였습니다");
		}
		
		return mav;
	}	

	
	// 자료실 자료 다운로드
	@RequestMapping("/dataroom/fileDownload.ajax")
	public ModelAndView fileDownload(String fileId, ModelAndView mView) {
		DataroomVO fvo = new DataroomVO();
		DataroomVO dvo = new DataroomVO();  
		
		try {
			dvo.setFileId(fileId);
			fvo = dataroomService.selectData(dvo);
			
			String filePath = fvo.getFileDir()+fvo.getFileName();
			fvo.setFilePath(filePath);
			
			String fileType = "dataroom";
			
			mView.addObject("fvo", fvo);
			mView.addObject("fileType", fileType);
			
			mView.setViewName("DatafileDownView");
			
		} catch (Exception e) {
			mView.addObject("msg","에러가 발생하였습니다");
		}

		return mView;
	}
	
	
	// 게시판 자료 다운로드
	@RequestMapping("/dataroom/board/fileDownload.ajax")
	public ModelAndView fileBoardDownload(String fileId, ModelAndView mView) {
		DataroomVO fvo = new DataroomVO();
		DataroomVO dvo = new DataroomVO();  
		
		try {
			dvo.setFileId(fileId);
			fvo = dataroomService.selectDataBoard(dvo);
			
			String filePath = fvo.getFileDir()+fvo.getFileName();
			fvo.setFilePath(filePath);
			
			String fileType = "board";
			
			mView.addObject("fvo", fvo);
			mView.addObject("fileType", fileType);
			
			mView.setViewName("DatafileDownView");
			
		} catch (Exception e) {
			mView.addObject("msg","에러가 발생하였습니다");
		}

		return mView;
	}
	
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		this.context = (WebApplicationContext) applicationContext;
	}
	
}
