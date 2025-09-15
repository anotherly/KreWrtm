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
		var dupChkFlag = true;
		$(document).ready(function() {
			console.log("사용자 수정 화면");
			var comcode = '${login.companyCode}';
				/* 회사코드에 따른 조회 */
			  $("#userType").on("change", function(){
				  var selectList = ajaxMethod("/org/comCodeOrg.ajax",{"companyCode":$(this).val()}).data;
				  $("#orgSel").empty();
				  $(selectList).each(function(i,list){
					  $("#orgSel").append("<option value='"+list.orgId+"'>"+list.orgName+"</option>");
					 
				  });
			  });
			
			$("#btnSave").on('click',function(){
				console.log("정보 저장");
				
				$(".input_base_require").each(function(i,list){
					console.log("필수값체크");
					if($(this).val()==null||$(this).val()==''){
						alert("필수 항목을 기재해 주세요");
						$(this).focus();
						validChk=false;
						return false;
					}
				});
				if(dupChkFlag && boardWriteCheck($("#insertForm"))){
					let queryString = $("#insertForm").serialize();
					ajaxMethod('/user/userUpdate.ajax',queryString,'/user/userList.do','저장되었습니다');
				}else{
					alert("volte 중복 체크를 확인하세요");
				}
			}); 
			
			$("#btnCancel").on('click',function(){
				location.href='/user/userList.do';
			});
		});
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
				<div id="contents_box" class="contents_box">
					<!-- 컨텐츠 테이블 헤더 Start -->
					<div class="ctn_tbl_header">
						<div class="ttl_ctn">장치 수정</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
					<input type="hidden" id="userId" name ="userId" value="${data.userId}" >
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_row">
									<div class="ctn_tbl_th fm_rep">ID</div>
									<div class="ctn_tbl_td">
										${data.userId}
									</div>
								</div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">사용자명</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="userName" 
										name ="userName" 
										placeholder=" "
										class="form-control input_base_require"
										maxLength="10"
										value="${data.userName}"
									>
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th">
									<p style="display: flex;flex-direction: column;">
										비밀번호
										<span style="font-size: 12px;">(변경시에만 입력)</span>
									</p>
								</div>
								<div class="ctn_tbl_td">
									<input type="password" 
									id="userPw" 
									name ="userPw" 
									placeholder="6~20자리  영문,숫자,특수문자 조합" 
									class="form-control"
									maxLength="20"
									>
								</div>
								<div class="ctn_tbl_td" style="padding: 0;font-size: 12px;" >허용 특수문자 : ~, !, @, #, $, %, ^, &, *, (, ), _, +, |, [, ] </div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th">
									<p style="display: flex;flex-direction: column;">
										비밀번호 확인
										<span style="font-size: 12px;">(변경시에만 입력)</span>
									</p>
								</div>
								<div class="ctn_tbl_td">
									<input type="password" 
									id="userPw2" 
									name ="userPw2" 
									placeholder="6~20자리  영문,숫자,특수문자 조합" 
									class="form-control"
									maxLength="20"
									>
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th  fm_rep">제조사</div>
								<div class="ctn_tbl_td">
									<select id="userType" name ="companyCode">
										<c:forEach var="comVo" items="${comList}">
									        <option value="${comVo.companyCode}" <c:if test="${comVo.companyCode eq data.companyCode}">selected</c:if>>
									        	${comVo.companyName}
									        </option>
									    </c:forEach>
									</select>
								</div>
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
		                            <select class="table_sel"  style="width: 164px; height:100%;" id="orgSel" name="orgId">
									    <c:forEach var="orgVo" items="${orgList}">
									        <option value="${orgVo.orgId}" <c:if test="${orgVo.orgId eq data.orgId}">selected</c:if>>${orgVo.orgName}</option>
									    </c:forEach>
									</select>
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">연락처 #1</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="userPhone"
										placeholder="" 
										class="form-control input_base_require"
										maxLength="13"
										oninput="formatPhoneAuto(this)"
										value="${data.userPhone}"
									>
								</div>
								<div class="ctn_tbl_th">연락처 #2</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="userPhone2" 
										placeholder="" 
										class="form-control input_base_require"
										maxLength="13"
										oninput="formatPhoneAuto(this)"
										value="${data.userPhone2}"
									>
								</div>
							</div>	
						</div>
						<!-- btn_box Start -->
						<div class="btn_box">
							<div class="right">
								<input type="button" class="btn btn_primary" id="btnSave" alt="저장" value="저장" />
								<input type="button" class="btn" id="btnCancel" alt="취소" value="취소" />
							</div>
						</div>
						<!-- btn_box End -->
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