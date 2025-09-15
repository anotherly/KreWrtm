package kr.co.hivesys.company.vo;

public class OrgVO extends CompanyVO {

	/** 소속 PK */
	private String orgId;

	/** 소속명 */
	private String orgName;

	// ===== Getter / Setter =====
	public String getOrgId() {
		return orgId;
	}

	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	@Override
	public String toString() {
		return "OrgVO [orgId=" + orgId + ", orgName=" + orgName + "]";
	}
	
}
