package kr.co.hivesys.user.vo;

import kr.co.hivesys.company.vo.OrgVO;

public class UserVO extends OrgVO{
	public String userId;
	public String userPw;
	public String userPw2;
	public String userName;
	
	public String userRank;
	
	public String userPhone;
	public String userPhone2;

	public String userEmail;
	
	public String usedYn;
	
	//아래는 DB에 없는것들
	// 최종로그인
	private String stDt;
	// 최종로그아웃
	private String fnDt;
	//현재 접속여부
	private String cnYn;
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public String getUserPw2() {
		return userPw2;
	}
	public void setUserPw2(String userPw2) {
		this.userPw2 = userPw2;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserRank() {
		return userRank;
	}
	public void setUserRank(String userRank) {
		this.userRank = userRank;
	}
	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public String getUserPhone2() {
		return userPhone2;
	}
	public void setUserPhone2(String userPhone2) {
		this.userPhone2 = userPhone2;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUsedYn() {
		return usedYn;
	}
	public void setUsedYn(String usedYn) {
		this.usedYn = usedYn;
	}
	public String getStDt() {
		return stDt;
	}
	public void setStDt(String stDt) {
		this.stDt = stDt;
	}
	public String getFnDt() {
		return fnDt;
	}
	public void setFnDt(String fnDt) {
		this.fnDt = fnDt;
	}
	public String getCnYn() {
		return cnYn;
	}
	public void setCnYn(String cnYn) {
		this.cnYn = cnYn;
	}
	@Override
	public String toString() {
		return "UserVO [userId=" + userId + ", userPw=" + userPw + ", userPw2=" + userPw2 + ", userName=" + userName
				+ ", userRank=" + userRank + ", userPhone=" + userPhone + ", userPhone2=" + userPhone2 + ", userEmail="
				+ userEmail + ", usedYn=" + usedYn + ", stDt=" + stDt + ", fnDt=" + fnDt + ", cnYn=" + cnYn + "]";
	}
	
}