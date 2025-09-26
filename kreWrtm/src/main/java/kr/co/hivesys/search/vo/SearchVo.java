package kr.co.hivesys.search.vo;

import kr.co.hivesys.router.vo.RouterVO;


public class SearchVo extends RouterVO{
	private String searchVal;
	private String deviceId;
	private String deviceName;
	private String modelName;
	private String carNum;
	private String volteNum;
	private String keywords;
	private String version;
	private String location;
	
	private String extraInfo;
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
	
	
	public String getSearchVal() {
		return searchVal;
	}
	public void setSearchVal(String searchVal) {
		this.searchVal = searchVal;
	}
	public String getDeviceId() {
		return deviceId;
	}
	public void setDeviceId(String deviceId) {
		this.deviceId = deviceId;
	}
	public String getDeviceName() {
		return deviceName;
	}
	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}
	public String getModelName() {
		return modelName;
	}
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}
	public String getCarNum() {
		return carNum;
	}
	public void setCarNum(String carNum) {
		this.carNum = carNum;
	}
	public String getVolteNum() {
		return volteNum;
	}
	public void setVolteNum(String volteNum) {
		this.volteNum = volteNum;
	}
	public String getKeywords() {
		return keywords;
	}
	public void setKeywords(String keywords) {
		this.keywords = keywords;
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
	public String getExtraInfo() {
		return extraInfo;
	}
	public void setExtraInfo(String extraInfo) {
		this.extraInfo = extraInfo;
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
		return "SearchVo [searchVal=" + searchVal + ", deviceId=" + deviceId + ", deviceName=" + deviceName
				+ ", modelName=" + modelName + ", carNum=" + carNum + ", volteNum=" + volteNum + ", keywords="
				+ keywords + ", version=" + version + ", location=" + location + ", extraInfo=" + extraInfo
				+ ", usimSlot=" + usimSlot + ", mobileIp=" + mobileIp + ", localIp=" + localIp + ", imei=" + imei
				+ ", imsi=" + imsi + ", rsrp=" + rsrp + ", rsrq=" + rsrq + ", mcpptNum=" + mcpttNum
				+ ", autoSwitchingRadio=" + autoSwitchingRadio + ", cellId=" + cellId + ", currentRadioType="
				+ currentRadioType + ", gpsLat=" + gpsLat + ", gpsLon=" + gpsLon + ", rcvDt=" + rcvDt + ", tagId="
				+ tagId + ", searchType=" + searchType + ", searchValue=" + searchValue + ", sDate=" + sDate
				+ ", eDate=" + eDate + ", getSearchVal()=" + getSearchVal() + ", getDeviceId()=" + getDeviceId()
				+ ", getDeviceName()=" + getDeviceName() + ", getModelName()=" + getModelName() + ", getCarNum()="
				+ getCarNum() + ", getVolteNum()=" + getVolteNum() + ", getKeywords()=" + getKeywords()
				+ ", getVersion()=" + getVersion() + ", getLocation()=" + getLocation() + ", getExtraInfo()="
				+ getExtraInfo() + ", getUsimSlot()=" + getUsimSlot() + ", getMobileIp()=" + getMobileIp()
				+ ", getLocalIp()=" + getLocalIp() + ", getImei()=" + getImei() + ", getImsi()=" + getImsi()
				+ ", getRsrp()=" + getRsrp() + ", getRsrq()=" + getRsrq() + ", getMcpptNum()=" + getMcpttNum()
				+ ", getAutoSwitchingRadio()=" + getAutoSwitchingRadio() + ", getCellId()=" + getCellId()
				+ ", getCurrentRadioType()=" + getCurrentRadioType() + ", getGpsLat()=" + getGpsLat() + ", getGpsLon()="
				+ getGpsLon() + ", getRcvDt()=" + getRcvDt() + ", getUpdateDate()=" + getUpdateDate()
				+ ", getMakerPhone1()=" + getMakerPhone1() + ", getMakerPhone2()=" + getMakerPhone2() + ", getOrgId()="
				+ getOrgId() + ", getOrgName()=" + getOrgName() + ", toString()=" + super.toString()
				+ ", getCompanyCode()=" + getCompanyCode() + ", getCompanyName()=" + getCompanyName()
				+ ", getUserType()=" + getUserType() + ", getRegDate()=" + getRegDate() + ", getCreatedAt()="
				+ getCreatedAt() + ", getUpdatedAt()=" + getUpdatedAt() + ", getTagId()=" + getTagId()
				+ ", getSearchType()=" + getSearchType() + ", getSearchValue()=" + getSearchValue() + ", getsDate()="
				+ getsDate() + ", geteDate()=" + geteDate() + ", getClass()=" + getClass() + ", hashCode()="
				+ hashCode() + "]";
	}
	
	
	

	
}
