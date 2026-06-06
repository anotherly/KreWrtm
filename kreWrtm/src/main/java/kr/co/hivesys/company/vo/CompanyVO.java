package kr.co.hivesys.company.vo;

import java.util.ArrayList;
import java.util.List;

import kr.co.hivesys.comm.BaseVO;

public class CompanyVO extends BaseVO {

	/** 회사 코드 (영문 대문자 4자리, PK) */
	private String companyCode;

	/** 회사명 */
	private String companyName;

	/** 사용자 구분 (코레일 / 제조사) */
	private String userType;
	
	/** 회사별 본부/처/실 목록 */
	private List<OrgVO> orgList = new ArrayList<OrgVO>();
	
	// 차트 그리기용 추가 컬럼(DB에는 X)
	private String dirMb;
	private String dirRegDt;
	private String todayCnt;
	private String rsrqAvg;
	

	// ===== Getter / Setter =====
	public String getCompanyCode() {
		return companyCode;
	}

	public void setCompanyCode(String companyCode) {
		this.companyCode = companyCode;
	}

	public String getCompanyName() {
		return companyName;
	}

	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}

	public String getUserType() {
		return userType;
	}

	public void setUserType(String userType) {
		this.userType = userType;
	}
	
	public List<OrgVO> getOrgList() {
		return orgList;
	}

	public void setOrgList(List<OrgVO> orgList) {
		this.orgList = orgList;
	}
	
	public String getDirMb() {
		return dirMb;
	}

	public void setDirMb(String dirMb) {
		this.dirMb = dirMb;
	}

	public String getDirRegDt() {
		return dirRegDt;
	}

	public void setDirRegDt(String dirRegDt) {
		this.dirRegDt = dirRegDt;
	}

	public String getTodayCnt() {
		return todayCnt;
	}

	public void setTodayCnt(String todayCnt) {
		this.todayCnt = todayCnt;
	}

	public String getRsrqAvg() {
		return rsrqAvg;
	}

	public void setRsrqAvg(String rsrqAvg) {
		this.rsrqAvg = rsrqAvg;
	}

	@Override
	public String toString() {
		return "CompanyVO [companyCode=" + companyCode + ", companyName=" + companyName + ", userType=" + userType
				+ "]";
	}
	
}
