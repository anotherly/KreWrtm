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
	
	
	@Override
	public String toString() {
		return "SearchVo [searchVal=" + searchVal + ", deviceId=" + deviceId + ", deviceName=" + deviceName
				+ ", modelName=" + modelName + ", carNum=" + carNum + ", volteNum=" + volteNum + ", keywords="
				+ keywords + ", version=" + version + ", location=" + location + "]";
	}
	
	

	
}
