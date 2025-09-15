package kr.co.hivesys.router.vo;

import java.time.LocalDate;

import kr.co.hivesys.company.vo.OrgVO;

public class RouterVO extends OrgVO {

	/** 장비 PK */
	private String deviceId;

	/** 장치명 */
	private String deviceName;

	/** 모델명 */
	private String modelName;

	/** VoLTE 번호 */
	private String volteNum;

	/** 키워드 */
	private String keywords;

	/** 편성번호 */
	private String carNum;

	/** 업데이트 일(업무용) */
	private LocalDate updateDate;

	/** 제조사 연락처 #1 */
	private String makerPhone1;

	/** 제조사 연락처 #2 */
	private String makerPhone2;

	/** 추가정보 */
	private String extraInfo;

	// ===== Getter / Setter =====
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

	public String getCarNum() {
		return carNum;
	}

	public void setCarNum(String carNum) {
		this.carNum = carNum;
	}

	public LocalDate getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(LocalDate updateDate) {
		this.updateDate = updateDate;
	}

	public String getMakerPhone1() {
		return makerPhone1;
	}

	public void setMakerPhone1(String makerPhone1) {
		this.makerPhone1 = makerPhone1;
	}

	public String getMakerPhone2() {
		return makerPhone2;
	}

	public void setMakerPhone2(String makerPhone2) {
		this.makerPhone2 = makerPhone2;
	}

	public String getExtraInfo() {
		return extraInfo;
	}

	public void setExtraInfo(String extraInfo) {
		this.extraInfo = extraInfo;
	}

}
