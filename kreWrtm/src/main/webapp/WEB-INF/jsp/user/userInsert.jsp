<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<meta charset="UTF-8">
<jsp:include page="../cmn/top.jsp" flush="false" />
	<script>
		var dupChkFlag = false;
		$(document).ready(function() {
			console.log("사용자 등록 화면");
			// 최초 진입: 사용자 유형 → 소속기관 → 본부/처/실 순서로 구성
			loadCompanyList($("#userType").val(), '${login.companyCode}', null);

			// 사용자 유형 변경 → 소속기관 목록 변경
			$("#userType").on("change", function(){
				loadCompanyList($(this).val(), null, null);
			});

			// 소속기관 변경 → 본부/처/실 목록 변경
			$("#companyCode").on("change", function(){
				loadOrgList($(this).val(), null);
			});

			// 중복확인 상태 초기화
			$('input[name="userId"]').on("change",function(){
				dupChkFlag = false;
				$("#dupComment").css('color', '').text("(6~12자리 영문소문자 숫자 조합)");
			});

			// 중복확인
			$("#dupChk").on('click',function(){
				var userIdVal = $('input[name="userId"]').val();
				if(userIdVal.length < 6){
					alert("유효한 ID 값을 입력하세요");
				}else{
					var selectOne = ajaxMethod("/user/selectOne.ajax", {"userId":userIdVal}).data.length;
					if(selectOne > 0){
						dupChkFlag = false;
						$("#dupComment").css('color','red').text("사용중인 ID입니다");
					}else{
						dupChkFlag = true;
						$("#dupComment").css('color','blue').text("사용 가능한 ID입니다");
					}
				}
			});

			// 저장
			$("#btnSave").on('click',function(){
				console.log("정보 저장");
				if(!dupChkFlag){
					alert("ID 중복 체크를 확인하세요");
				}else{
					if(boardWriteCheck($("#insertForm"))){
						var phoneChk = phoneCellChk("userPhone","userPhone2");
						if(phoneChk) {
							var queryString = $("#insertForm").serialize();
							ajaxMethod('/user/userInsert.ajax', queryString, '/user/userList.do', '저장되었습니다');
						} else {
							alert("연락처가 올바르지 않습니다. 다시 확인하세요.");
						}
					}
				}
			});

			$("#btnCancel").on('click',function(){
				location.href='/user/userList.do';
			});
		});

		function loadCompanyList(userType, selectedCompanyCode, selectedOrgId) {
			var result = ajaxMethod("/router/selectCompany.ajax", {"userType": userType});
			var comData = result.data || [];
			var loginComcode = '${login.companyCode}';
			var loginUserType = '${login.userType}';
			var $companyCode = $("#companyCode");

			$companyCode.empty();

			$(comData).each(function(i, company){
				if (loginUserType != '코레일' && company.companyCode != loginComcode) {
					return true;
				}

				var $option = $("<option></option>").val(company.companyCode).text(company.companyName);
				if (selectedCompanyCode != null && selectedCompanyCode != '' && company.companyCode == selectedCompanyCode) {
					$option.prop("selected", true);
				}
				$companyCode.append($option);
			});

			if ($companyCode.find("option").length <= 0) {
				$companyCode.append("<option value=''>선택 가능한 소속 없음</option>").prop("disabled", true);
				$("#orgSel").empty().append("<option value=''>선택 가능한 본부/처/실 없음</option>").prop("disabled", true);
				return;
			}

			$companyCode.prop("disabled", false);
			loadOrgList($companyCode.val(), selectedOrgId);
		}

		function loadOrgList(companyCode, selectedOrgId) {
			var $orgSel = $("#orgSel");
			$orgSel.empty();

			if (companyCode == null || companyCode == '') {
				$orgSel.append("<option value=''>소속을 먼저 선택하세요</option>").prop("disabled", true);
				return;
			}

			var result = ajaxMethod("/org/comCodeOrg.ajax", {"companyCode": companyCode});
			var selectList = result.data || [];

			if (selectList.length <= 0) {
				$orgSel.append("<option value=''>선택 가능한 본부/처/실 없음</option>").prop("disabled", true);
				return;
			}

			$orgSel.prop("disabled", false);
			$(selectList).each(function(i, list){
				var $option = $("<option></option>").val(list.orgId).text(list.orgName);
				if (selectedOrgId != null && selectedOrgId != '' && list.orgId == selectedOrgId) {
					$option.prop("selected", true);
				}
				$orgSel.append($option);
			});
		}
	</script>

</head>
<body class="open">
    <!-- lnb Start ------------------>
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar navbar-expand-sm navbar-default">
            <ul class="menu-inner"></ul>
        </nav>
    </aside>
    <!-- lnb End ------------------>

	<!-- container Start ------------------>
	<div id="container" class="container-wrap"  style="margin-top: 0px;">
		<!-- header Start ------------------>
		<div id="header" class="header-wrap">
		</div>
		<!-- header End ------------------>
		<!-- contents Start ------------------>
		<div id="contents" class="contents-wrap">
			<!-- work Start -->
			<div id="work" class="work-wrap">
				<!-- contents_box Start -->
				<div id="contents_box" class="contents_box user_form_page">
					<!-- 컨텐츠 테이블 헤더 Start -->
					<div class="ctn_tbl_header">
					<img class="list-title-img" src="/images/icons/ico_user_title.png"/><div class="ttl_ctn">사용자 등록</div>
				</div>
					<!-- 컨텐츠 테이블 헤더 End -->

					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row user-form-id-row">
								<div class="ctn_tbl_th fm_rep">ID</div>
								<div class="ctn_tbl_td">
									<input type="text"
										id="userId"
										name="userId"
										placeholder="6~12자리 영문소문자 숫자 조합"
										class="form-control input_base_require user_form_input"
										oninput="checkId(this)"
										maxLength="12">
								</div>
								<div class="ctn_tbl_td">
									<div class="id_check_box">
										<input type="button" id="dupChk" alt="중복확인" value="중복확인" />
										<span id="dupComment">(6~12자리 영문소문자 숫자 조합)</span>
									</div>
								</div>
								<div class="ctn_tbl_td"></div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">사용자명</div>
								<div class="ctn_tbl_td">
									<input type="text"
										id="userName"
										name="userName"
										placeholder="예: 홍길동"
										class="form-control input_base_require user_form_input"
										maxLength="10">
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">비밀번호</div>
								<div class="ctn_tbl_td">
									<div class="password_input_box">
										<input type="password"
											id="userPw"
											name="userPw"
											placeholder="6~20자리  영문,숫자,특수문자 조합"
											class="form-control input_base_require"
											maxLength="20"
											oninput="checkPw(this)">
										<button type="button" class="btn_pw_toggle" data-target="userPw" title="비밀번호 보기" aria-label="비밀번호 보기">
											<svg viewBox="0 0 24 24" aria-hidden="true">
												<path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
												<circle cx="12" cy="12" r="3" fill="none" stroke-width="2"/>
											</svg>
										</button>
									</div>
								</div>
								<div class="ctn_tbl_td password_note">허용 특수문자 : ~, !, @, #, $, %, ^, &, *, (, ), _, +, |, [, ]</div>
								<div class="ctn_tbl_td"></div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">비밀번호 확인</div>
								<div class="ctn_tbl_td">
									<div class="password_input_box">
										<input type="password"
											id="userPw2"
											name="userPw2"
											placeholder="6~20자리  영문,숫자,특수문자 조합"
											class="form-control input_base_require"
											maxLength="20"
											oninput="checkPw(this)">
										<button type="button" class="btn_pw_toggle" data-target="userPw2" title="비밀번호 보기" aria-label="비밀번호 보기">
											<svg viewBox="0 0 24 24" aria-hidden="true">
												<path d="M2 12s3.5-6 10-6 10 6 10 6-3.5 6-10 6S2 12 2 12z" fill="none" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
												<circle cx="12" cy="12" r="3" fill="none" stroke-width="2"/>
											</svg>
										</button>
									</div>
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">사용자 유형</div>
								<div class="ctn_tbl_td">
									<select class="table_sel" id="userType" name="userType">
										<c:choose>
											<c:when test="${login.userType ne '코레일'}">
												<option value="${login.userType}" selected>${login.userType}</option>
											</c:when>
											<c:otherwise>
												<option value="코레일" selected>코레일</option>
												<option value="제조사">제조사</option>
											</c:otherwise>
										</c:choose>
									</select>
								</div>
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
									<select class="table_sel" id="companyCode" name="companyCode">
										<option value="">선택</option>
									</select>
								</div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">본부/처/실</div>
								<div class="ctn_tbl_td">
									<select class="table_sel" id="orgSel" name="orgId">
										<option value="">선택</option>
									</select>
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>

							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">연락처 #1</div>
								<div class="ctn_tbl_td">
									<input type="text"
										id="userPhone"
										name="userPhone"
										placeholder="예: 010-1234-5678"
										class="form-control input_base_require user_form_input"
										maxLength="13"
										oninput="formatPhoneAuto(this)">
								</div>
								<div class="ctn_tbl_th">연락처 #2</div>
								<div class="ctn_tbl_td">
									<input type="text"
										id="userPhone2"
										name="userPhone2"
										placeholder="예: 02-1234-5678"
										class="form-control user_form_input"
										maxLength="13"
										oninput="formatPhoneAuto(this)">
								</div>
							</div>
						</div>

						<div class="btn_box">
							<div class="right">
								<input type="button" class="btn btn_primary" id="btnSave" alt="저장" value="저장" />
								<input type="button" class="btn" id="btnCancel" alt="취소" value="취소" />
							</div>
						</div>
					</form>
				</div>
				<!-- contents_box End -->
			</div>
			<!-- work End -->
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>
