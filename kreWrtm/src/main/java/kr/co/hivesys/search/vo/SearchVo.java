package kr.co.hivesys.search.vo;

import kr.co.hivesys.router.vo.RouterVO;


public class SearchVo extends RouterVO{
	private String searchVal;
	private String version;
	private String location;//DB에는 컬렴명 TC에 저장
	
	private String usimSlot;
	private String mobileIp;
	private String localIp;
	private String imei;
	private String imsi;
	private String rsrp;
	private String rsrq;
	private String mcpttNum;
	private String autoSwitchingRadio;
	private String cellId;
	private String currentRadioType;
	private String gpsLat;
	private String gpsLon;
	private String rcvDt;
	// 25.11.18 신규추가
	private String vncIp;
	private String vncPort;
	private String vncPw;
	
	public String getVncIp() {
		return vncIp;
	}
	public void setVncIp(String vncIp) {
		this.vncIp = vncIp;
	}
	public String getVncPort() {
		return vncPort;
	}
	public void setVncPort(String vncPort) {
		this.vncPort = vncPort;
	}
	public String getVncPw() {
		return vncPw;
	}
	public void setVncPw(String vncPw) {
		this.vncPw = vncPw;
	}
	public String getSearchVal() {
		return searchVal;
	}
	public void setSearchVal(String searchVal) {
		this.searchVal = searchVal;
	}
	public String getVersion() {
		return version;
	}
	public void setVersion(String version) {
		this.version = version;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getUsimSlot() {
		return usimSlot;
	}
	public void setUsimSlot(String usimSlot) {
		this.usimSlot = usimSlot;
	}
	public String getMobileIp() {
		return mobileIp;
	}
	public void setMobileIp(String mobileIp) {
		this.mobileIp = mobileIp;
	}
	public String getLocalIp() {
		return localIp;
	}
	public void setLocalIp(String localIp) {
		this.localIp = localIp;
	}
	public String getImei() {
		return imei;
	}
	public void setImei(String imei) {
		this.imei = imei;
	}
	public String getImsi() {
		return imsi;
	}
	public void setImsi(String imsi) {
		this.imsi = imsi;
	}
	public String getRsrp() {
		return rsrp;
	}
	public void setRsrp(String rsrp) {
		this.rsrp = rsrp;
	}
	public String getRsrq() {
		return rsrq;
	}
	public void setRsrq(String rsrq) {
		this.rsrq = rsrq;
	}
	public String getMcpttNum() {
		return mcpttNum;
	}
	public void setMcpttNum(String mcpttNum) {
		this.mcpttNum = mcpttNum;
	}
	public String getAutoSwitchingRadio() {
		return autoSwitchingRadio;
	}
	public void setAutoSwitchingRadio(String autoSwitchingRadio) {
		this.autoSwitchingRadio = autoSwitchingRadio;
	}
	public String getCellId() {
		return cellId;
	}
	public void setCellId(String cellId) {
		this.cellId = cellId;
	}
	public String getCurrentRadioType() {
		return currentRadioType;
	}
	public void setCurrentRadioType(String currentRadioType) {
		this.currentRadioType = currentRadioType;
	}
	public String getGpsLat() {
		return gpsLat;
	}
	public void setGpsLat(String gpsLat) {
		this.gpsLat = gpsLat;
	}
	public String getGpsLon() {
		return gpsLon;
	}
	public void setGpsLon(String gpsLon) {
		this.gpsLon = gpsLon;
	}
	public String getRcvDt() {
		return rcvDt;
	}
	public void setRcvDt(String rcvDt) {
		this.rcvDt = rcvDt;
	}
	@Override
	public String toString() {
		return "SearchVo [searchVal=" + searchVal + ", version=" + version + ", location=" + location + ", usimSlot="
				+ usimSlot + ", mobileIp=" + mobileIp + ", localIp=" + localIp + ", imei=" + imei + ", imsi=" + imsi
				+ ", rsrp=" + rsrp + ", rsrq=" + rsrq + ", mcpttNum=" + mcpttNum + ", autoSwitchingRadio="
				+ autoSwitchingRadio + ", cellId=" + cellId + ", currentRadioType=" + currentRadioType + ", gpsLat="
				+ gpsLat + ", gpsLon=" + gpsLon + ", rcvDt=" + rcvDt + ", vncIp=" + vncIp + ", vncPort=" + vncPort
				+ ", vncPw=" + vncPw + "]";
	}

	
}
