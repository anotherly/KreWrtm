package kr.co.hivesys.auth.vo;

public class AuthVO {
	private String idx;
	private String subIdx;
	private Integer authId;
	private String authDefine;
	private Integer usedYn;
	private String url;
	private String authUrlName1;
	private String authUrlName2;
	private String authUrlName3;
	private String useYn;

	public String getIdx() { return idx; }
	public void setIdx(String idx) { this.idx = idx; }
	public String getSubIdx() { return subIdx; }
	public void setSubIdx(String subIdx) { this.subIdx = subIdx; }

	public Integer getAuthId() { return authId; }
	public void setAuthId(Integer authId) { this.authId = authId; }
	public String getAuthDefine() { return authDefine; }
	public void setAuthDefine(String authDefine) { this.authDefine = authDefine; }
	public Integer getUsedYn() { return usedYn; }
	public void setUsedYn(Integer usedYn) { this.usedYn = usedYn; }
	public String getUrl() { return url; }
	public void setUrl(String url) { this.url = url; }
	public String getAuthUrlName1() { return authUrlName1; }
	public void setAuthUrlName1(String authUrlName1) { this.authUrlName1 = authUrlName1; }
	public String getAuthUrlName2() { return authUrlName2; }
	public void setAuthUrlName2(String authUrlName2) { this.authUrlName2 = authUrlName2; }
	public String getAuthUrlName3() { return authUrlName3; }
	public void setAuthUrlName3(String authUrlName3) { this.authUrlName3 = authUrlName3; }
	public String getUseYn() { return useYn; }
	public void setUseYn(String useYn) { this.useYn = useYn; }
}
