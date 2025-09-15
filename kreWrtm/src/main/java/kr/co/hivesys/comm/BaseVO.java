package kr.co.hivesys.comm;

public class BaseVO {
	
	/*기본 필요속성*/
	/** 등록일 (업무적 등록일, 기본: 당일) */
	private String regDate;

	/** 생성일시 (DB Insert 시 자동 기록) */
	private String createdAt;

	/** 수정일시 (DB Update 시 자동 기록) */
	private String updatedAt;
	
	/*데이터 선택*/
	//pk - id
	public String tagId;
	
	/*검색*/
	//검색유형 (셀렉트박스)
	public String searchType;
	//검색어 (텍스트 창)
	public String searchValue;
	//시작일
	public String sDate;
	//종료일
	public String eDate;
	
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}
	public String getTagId() {
		return tagId;
	}
	public void setTagId(String tagId) {
		this.tagId = tagId;
	}
	public String getSearchType() {
		return searchType;
	}
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}
	public String getSearchValue() {
		return searchValue;
	}
	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}
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
	
	@Override
	public String toString() {
		return "BaseVO [tagId=" + tagId + ", searchType=" + searchType + ", searchValue=" + searchValue + ", sDate="
				+ sDate + ", eDate=" + eDate + "]";
	}
	
}
