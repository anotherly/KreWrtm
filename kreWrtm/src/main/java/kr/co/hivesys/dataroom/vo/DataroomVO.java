package kr.co.hivesys.dataroom.vo;

public class DataroomVO {
	private String fileId;
	private String fileTitle;
	private String fileName;
	private String fileDir;
	private String regDt;
	private String fileVersion;
	private String filePath;
	private String fileType;
	
	//검색 시작 시간
	private String sDate;
	//검색 종료 시간
	private String eDate;
	
	private String writerName;
	private String writerId;
	
	private String boardContent;
	
	public String getBoardContent() {
		return boardContent;
	}
	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}
	public String getFileId() {
		return fileId;
	}
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	public String getFileTitle() {
		return fileTitle;
	}
	public void setFileTitle(String fileTitle) {
		this.fileTitle = fileTitle;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileDir() {
		return fileDir;
	}
	public void setFileDir(String fileDir) {
		this.fileDir = fileDir;
	}
	public String getRegDt() {
		return regDt;
	}
	public void setRegDt(String regDt) {
		this.regDt = regDt;
	}
	public String getFileVersion() {
		return fileVersion;
	}
	public void setFileVersion(String fileVersion) {
		this.fileVersion = fileVersion;
	}
	public String getFilePath() {
		return filePath;
	}
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getsDate() {
		return sDate;
	}
	public void setsDate(String sDate) {
		this.sDate = sDate;
	}
	public String geteDate() {
		return eDate;
	}
	public void seteDate(String eDate) {
		this.eDate = eDate;
	} 
	public String getWriterName() {
		return writerName;
	}
	public void setWriterName(String writerName) {
		this.writerName = writerName;
	}
	
	
	@Override
	public String toString() {
		return "DataroomVO [fileId=" + fileId + ", fileTitle=" + fileTitle + ", fileName=" + fileName + ", fileDir="
				+ fileDir + ", regDt=" + regDt + ", fileVersion=" + fileVersion + ", filePath=" + filePath
				+ ", fileType=" + fileType + ", sDate=" + sDate + ", eDate=" + eDate + "]";
	}
	
	
}
