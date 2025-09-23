package kr.co.hivesys.chart.vo;

public class ChartVo {
	
	// 아래 컬럼들은 화면 제작용으로 임시 생성된 컬럼임(삭제 또는 수정 예정)
	private String companyName;
	private int firmUse;
	private String etc;
	
	
	public String getCompanyName() {
		return companyName;
	}
	public void setCompanyName(String companyName) {
		this.companyName = companyName;
	}
	public int getFirmUse() {
		return firmUse;
	}
	public void setFirmUse(int firmUse) {
		this.firmUse = firmUse;
	}
	public String getEtc() {
		return etc;
	}
	public void setEtc(String etc) {
		this.etc = etc;
	}
	
	
	@Override
	public String toString() {
		return "ChartVo [companyName=" + companyName + ", firmUse=" + firmUse + ", etc=" + etc + "]";
	}
	
	
	
	
}
