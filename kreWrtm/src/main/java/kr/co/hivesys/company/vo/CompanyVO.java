package kr.co.hivesys.company.vo;

import kr.co.hivesys.comm.BaseVO;

public class CompanyVO extends BaseVO {

	/** 회사 코드 (영문 대문자 4자리, PK) */
	private String companyCode;

	/** 회사명 */
	private String companyName;

	/** 사용자 구분 (코레일 / 제조사) */
	private String userType;

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

	@Override
	public String toString() {
		return "CompanyVO [companyCode=" + companyCode + ", companyName=" + companyName + ", userType=" + userType
				+ "]";
	}
	
}
