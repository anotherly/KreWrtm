package kr.co.hivesys.comm.file;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.multipart.MultipartFile;

import kr.co.hivesys.comm.file.vo.FileVo;


public class FileUploadSave implements ApplicationContextAware{

	private WebApplicationContext context = null;
	public static final Logger logger = LoggerFactory.getLogger(FileUploadSave.class);
	
	// 자료실 파일 등록
		public FileVo fileUploadMultipleDataroom(List<MultipartFile> files, String inputPath, FileVo inputVo, String fileType) {
		    FileVo fileList = new FileVo();

		    try {
		        for (MultipartFile mfile : files) {
		            String originalFileName = mfile.getOriginalFilename();

		            // 랜덤 문자열 생성
		            String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
		            String randomString = new java.security.SecureRandom()
		                .ints(5, 0, characters.length())
		                .mapToObj(a -> characters.charAt(a))
		                .collect(StringBuilder::new, StringBuilder::append, StringBuilder::append)
		                .toString();

		            File targetFile;
		            File file = new File(inputPath + originalFileName); // 기본 경로

		            if ("I".equalsIgnoreCase(fileType)) {
		                // I 타입: 랜덤폴더 포함 경로
		                targetFile = new File(inputPath + randomString + "/" + originalFileName);
		            } else if ("U".equalsIgnoreCase(fileType)) {
		                // U 타입: 기본 경로
		                targetFile = file;
		            } else {
		                continue;
		            }

		            if (mfile.getSize() != 0) {
		                // targetFile 경로에 파일 저장
		                if (!targetFile.exists()) {
		                    targetFile.getParentFile().mkdirs();
		                    mfile.transferTo(targetFile);
		                } else {
		                    targetFile.delete();
		                    mfile.transferTo(targetFile);
		                }

		                // I 타입일 때만 기본 경로(file)로 복사 (경로 없으면 생성)
		                if ("I".equalsIgnoreCase(fileType)) {
		                    if (!file.exists()) {
		                        file.getParentFile().mkdirs();
		                    }
		                }
		            }

		            // 리턴 값 세팅
		            if ("I".equalsIgnoreCase(fileType)) {
		            	fileList.setFileId(randomString);
		                fileList.setFileDir("/" + randomString + "/");
		                fileList.setFileName(originalFileName);
			            fileList.setFileTitle(inputVo.getFileTitle());
		            } else {
		            	fileList.setFileId(inputVo.getFileId());
		            	fileList.setFileName(originalFileName);
			            fileList.setFileTitle(inputVo.getFileTitle());
		            }
		            
		            
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    }

		    return fileList;
		}
		
		
	/*채택*/
	// 여러 개의 파일 업로드
    public List<FileVo> fileUploadMultiple(List<MultipartFile> files, String inputPath,FileVo inputVo) {
    	List<FileVo> fileList = new ArrayList<>();
    	try {
	        // 1. 파일 저장 경로 설정 : 실제 서비스되는 위치(프로젝트 외부에 저장)
	        // 여러 개의 원본 파일을 저장할 리스트 생성
    		int i =0;
	        for(MultipartFile mfile : files) {
	        	FileVo fvo = new FileVo();
	            // 2. 원본 파일 이름 알아오기
	            String originalFileName = mfile.getOriginalFilename();
	            // 3. 파일 이름 중복되지 않게 이름 변경(서버에 저장할 이름) UUID 사용
	            UUID uuid = UUID.randomUUID();
	            // 4. 파일 생성 (이승철이사 사용 파일과 버전 폴더 파일로 구별)
	            //일반 버전 적재 파일
	            File file = new File(inputPath + originalFileName);
	            //펌웨어 프로그램에서 사용할 (700P/m)
	            String inputFuckPath=inputPath.split("firmwareFile/")[0]+"firmwareFile/";
	            
	            if(originalFileName.contains("700M")) {//700M
	            	/*String[] fuckPath = originalFileName.split("-");
	            	if(fuckPath[1].equals("I")) {//펌웨어 파일
	            		
	            	}else {//버전명시 파일
	            		
	            	}*/
	            	inputFuckPath=inputFuckPath+"700M/";
	            } else {//700P
	            	inputFuckPath=inputFuckPath+"700P/";
	            }
	            File fuckFile = new File(inputFuckPath + originalFileName);
	            
	            if(mfile.getSize() != 0) {
	            	//펌웨어 프로그램에서 사용할 (700P/m) 경로 생성
	            	
	            	if(!fuckFile.exists()) {
	            		fuckFile.getParentFile().mkdirs();
	            		//fuckFile.createNewFile();
	            		mfile.transferTo(fuckFile);
	                }else {//존재한다면 기존거 삭제하고 덮어씌움
	                	fuckFile.delete();
	                	//fuckFile.createNewFile();
	                	mfile.transferTo(fuckFile);
	                }
	            	
		           /* if(!fuckFile.exists()) {
	                    if(file.getParentFile().mkdir()) {
	                        file.createNewFile();
	                    }
	                }else {//존재한다면 기존거 삭제하고 덮어씌움
	                	
	                }*/
	            	//버전 리스트
	            	//경로가 없으면 새로 경로 생성
		            if(!file.exists()) {
//		            	if(file.getParentFile().mkdir()) {
//		            		file.createNewFile();
//		            	}
		            	file.getParentFile().mkdirs();
		            	//한번 트랜스퍼 된건 또다시 트랜스퍼 되지 않음 거지같은...
		            	FileUtils.copyFile(fuckFile, file);
	                }
	            }
	            //6.리턴값 적재
	            fvo.setFileId("firmware_version_"+inputVo.getFileVersion()+"_("+i+")");
	            fvo.setFileDir(inputPath.split("firmwareFile")[1]);
	            fvo.setFileName(originalFileName);
	            fvo.setFileVersion(inputVo.getFileVersion());
	            fvo.setFileType(inputVo.getFileType());
				fileList.add(fvo);
	            i++;
	        }
    	}catch (Exception e) {
    		e.printStackTrace();
		}
       return fileList;
    }
    
/*	//폴더내 받아온 이름제외 나머지 파일 삭제 (이전)
	public void deleteFile (String filepath,String fileName){      
		File dirFile = new File(filepath);
		String fileList[] = dirFile.list();
		for(int i = 0; i < fileList.length; i++) {
		    String chkFileNm = fileList[i];
		    if(!chkFileNm.equals(fileName)) {
		        File delFile = new File(filepath + File.separator + chkFileNm);
		        delFile.delete();
		    }
		}
	}*/
    
    
    
  //폴더내 받아온 이름제외 나머지 파일 삭제
  	public void deleteFile (String filepath,String fileName){      
  		File dirFile = new File(filepath);
  		String fileList[] = dirFile.list();
  		
  		if(fileList != null) {
  			for(int i = 0; i < fileList.length; i++) {
  			    String chkFileNm = fileList[i];
  			    if(!chkFileNm.equals(fileName)) {
  			        File delFile = new File(filepath + File.separator + chkFileNm);
  			        delFile.delete();
  			    }
  			}
  		}
  		
  	}
  	
 // 여러개 삭제   
 	public void ArrdeleteFile(String filepath, List<String> dataArr) {      
 	    // dataArr의 각 항목에 대해 반복
 	    for (String fileName : dataArr) {
 	        // fileName에 해당하는 폴더 경로 설정
 	        File dirFile = new File(filepath + File.separator + fileName);

 	        // 폴더가 존재하고 디렉토리일 경우
 	        if (dirFile.exists() && dirFile.isDirectory()) {
 	            // 폴더 내의 파일과 서브디렉토리 삭제
 	            File[] files = dirFile.listFiles();
 	            if (files != null) {
 	                for (File file : files) {
 	                    if (file.isDirectory()) {
 	                        // 서브디렉토리도 재귀적으로 삭제
 	                        File[] subFiles = file.listFiles();
 	                        if (subFiles != null) {
 	                            for (File subFile : subFiles) {
 	                                subFile.delete();
 	                            }
 	                        }
 	                    } 
 	                    // 파일 삭제
 	                    file.delete();
 	                }
 	            }
 	            // 폴더 삭제
 	            dirFile.delete();
 	        }
 	    }
 	}
    
	public void setApplicationContext(org.springframework.context.ApplicationContext applicationContext) throws BeansException {
		// TODO Auto-generated method stub
		this.context = (WebApplicationContext) applicationContext;
	}
}
