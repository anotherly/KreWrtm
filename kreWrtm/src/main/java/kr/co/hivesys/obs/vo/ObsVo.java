package kr.co.hivesys.obs.vo;

public class ObsVo {
	private String obsId;
	private String carNum;
	private String rptDate;
	private String obsName;
	private String prcDate;
	private String prcComment;
	private String reason;
	private String etc;
	private String sDate; // 신고일시 검색 시작일
	private String eDate; // 신고일시 검색 종료일
	private String ssDate;  // 처리일시 검색 시작일
	private String eeDate;  // 처리일시 검색 종료일
	
	
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
	public String getSsDate() {
		return ssDate;
	}
	public void setSsDate(String ssDate) {
		this.ssDate = ssDate;
	}
	public String getEeDate() {
		return eeDate;
	}
	public void setEeDate(String eeDate) {
		this.eeDate = eeDate;
	}
	public String getObsId() {
		return obsId;
	}
	public void setObsId(String obsId) {
		this.obsId = obsId;
	}
	public String getCarNum() {
		return carNum;
	}
	public void setCarNum(String carNum) {
		this.carNum = carNum;
	}
	public String getRptDate() {
		return rptDate;
	}
	public void setRptDate(String rptDate) {
		this.rptDate = rptDate;
	}
	public String getObsName() {
		return obsName;
	}
	public void setObsName(String obsName) {
		this.obsName = obsName;
	}
	public String getPrcDate() {
		return prcDate;
	}
	public void setPrcDate(String prcDate) {
		this.prcDate = prcDate;
	}
	public String getPrcComment() {
		return prcComment;
	}
	public void setPrcComment(String prcComment) {
		this.prcComment = prcComment;
	}
	public String getReason() {
		return reason;
	}
	public void setReason(String reason) {
		this.reason = reason;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	
	
	
	@Override
	public String toString() {
		return "ObsVo [obsId=" + obsId + ", carNum=" + carNum + ", rptDate=" + rptDate + ", obsName=" + obsName
				+ ", prcDate=" + prcDate + ", prcComment=" + prcComment + ", reason=" + reason + ", etc=" + etc
				+ ", getObsId()=" + getObsId() + ", getCarNum()=" + getCarNum() + ", getRptDate()=" + getRptDate()
				+ ", getObsName()=" + getObsName() + ", getPrcDate()=" + getPrcDate() + ", getPrcComment()="
				+ getPrcComment() + ", getReason()=" + getReason() + ", getEtc()=" + getEtc() + ", getClass()="
				+ getClass() + ", hashCode()=" + hashCode() + ", toString()=" + super.toString() + "]";
	}
	
	
}
