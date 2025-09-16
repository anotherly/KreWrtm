package kr.co.hivesys.comm.file.vo;

public class FileVo {
	private String fileId;
	private String fileDir;
	private String fileName;
	private String regDt;
	private String fileVersion;
	private String filePath;
	private String fileType;
	private String fileTitle;
	private String writerId;
	private String boardContent;
	
	public String getWriterId() {
		return writerId;
	}
	public void setWriterId(String writerId) {
		this.writerId = writerId;
	}
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
	public String getFileDir() {
		return fileDir;
	}
	public void setFileDir(String fileDir) {
		this.fileDir = fileDir;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
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
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getFileType() {
		return fileType;
	}
	public void setFileType(String fileType) {
		this.fileType = fileType;
	}
	public String getFileTitle() {
		return fileTitle;
	}
	public void setFileTitle(String fileTitle) {
		this.fileTitle = fileTitle;
	}
	
	@Override
	public String toString() {
		return "FileVo [fileId=" + fileId + ", fileDir=" + fileDir + ", fileName=" + fileName + ", regDt=" + regDt
				+ ", fileVersion=" + fileVersion + ", filePath=" + filePath + ", fileType=" + fileType + ", fileTitle="
				+ fileTitle + ", getFileId()=" + getFileId() + ", getFileDir()=" + getFileDir() + ", getFileName()="
				+ getFileName() + ", getRegDt()=" + getRegDt() + ", getFileVersion()=" + getFileVersion()
				+ ", getFilePath()=" + getFilePath() + ", getFileType()=" + getFileType() + ", getFileTitle()="
				+ getFileTitle() + ", getClass()=" + getClass() + ", hashCode()=" + hashCode() + ", toString()="
				+ super.toString() + "]";
	}
	
	
}
