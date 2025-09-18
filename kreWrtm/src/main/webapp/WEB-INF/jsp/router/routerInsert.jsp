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
			console.log("장비 등록 화면");
			var comcode = '${login.companyCode}';
			 /** 1. 장치명 입력 시 모델명 옆에 표시 */
			  $("#deviceName").on("input", function(){
			    $("#modelNameDisplay").text($(this).val());
			  });
				/* 회사코드에 따른 조회 */
			  $("#userType").on("change", function(){
				  var selectList = ajaxMethod("/org/comCodeOrg.ajax",{"companyCode":$(this).val()}).data;
				  $("#orgSel").empty();
				  $(selectList).each(function(i,list){
					  $("#orgSel").append("<option value='"+list.orgId+"'>"+list.orgName+"</option>");
					 
				  });
			  });
			//volte 중복확인
			$('input[name ="volteNum"]').on("change",function(){
				dupChkFlag = false;
			});
			$("#dupChk").on('click',function(){
				var volteVal =$('input[name ="volteNum"]').val();
				  if(volteVal.length<11){
					  alert("유효한 volte 값을 입력하세요");
				  }else{
					  var selectOne = ajaxMethod("/router/selectOne.ajax",{"volteNum":volteVal}).data.length;
					  if(selectOne>0){
						  dupChkFlag = false;
						  $("#dupComment").empty();
						  $("#dupComment").css('color','red');
						  $("#dupComment").append("사용중인 volte 번호입니다");
					  }else{
						  dupChkFlag = true;
						  $("#dupComment").empty();
						  $("#dupComment").css('color','blue');
						  $("#dupComment").append("사용 가능한 volte 번호입니다");
					  }
				  }
				  
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
				if(dupChkFlag){
					let queryString = $("#insertForm").serialize();
					ajaxMethod('/router/routerInsert.ajax',queryString,'/router/routerList.do','저장되었습니다');
				}else{
					alert("volte 중복 체크를 확인하세요");
				}
			}); 
			
			$("#btnCancel").on('click',function(){
				location.href='/router/routerList.do';
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
						<div class="ttl_ctn">장치 등록</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">장치명</div>
								<div class="ctn_tbl_td">
									${login.companyCode}_
									<input type="text" 
										id="deviceName" 
										name ="deviceName" 
										placeholder="장치약어 4자리" 
										class="form-control input_base_require"
										maxLength="4"
									>
								</div>
								<div class="ctn_tbl_td">제조사 코드 4자리 + '_' + 장치약어 4자리</div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">모델명</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="modelName" 
										name ="modelName" 
										placeholder="사용처 "
										class="form-control input_base_require"
										maxLength="10"
									> - ${login.companyCode} _
									<span id="modelNameDisplay" style="margin-left:8px;"></span>
								</div>
								<div class="ctn_tbl_td">사용처 + '-' + 장치명 조합</div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">VoLTE 번호</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="volteNum" 
										placeholder="ex)013-1234-5678" 
										class="form-control input_base_require"
										oninput="formatPhoneAuto(this,'volte')"
										maxLength="13"
									>
								</div>
								<div class="ctn_tbl_td">
									<input type="button" id="dupChk" alt="중복확인" value="중복확인" />
									<p id="dupComment"></p>
								</div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">키워드</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="keywords" 
										name ="keywords" 
										placeholder="" 
										class="form-control input_base_require"
										maxLength="20"
									>
								</div>
								<div class="ctn_tbl_th fm_rep">차량번호</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="carNum" 
										name ="carNum" 
										placeholder="" 
										class="form-control input_base_require"
										maxLength="10"
									>
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th  fm_rep">제조사</div>
								<div class="ctn_tbl_td">
									<select id="userType" name ="companyCode">
										<c:forEach var="comVo" items="${comList}">
									        <option value="${comVo.companyCode}" <c:if test="${comVo.companyCode eq login.companyCode}">selected</c:if>>
									        	${comVo.companyName}
									        </option>
									    </c:forEach>
									</select>
								</div>
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
		                            <select class="table_sel"  style="width: 164px; height:100%;" id="orgSel" name="orgId">
									    <c:forEach var="orgVo" items="${orgList}">
									        <option value="${orgVo.orgId}">${orgVo.orgName}</option>
									    </c:forEach>
									</select>
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">제조사 연락처 #1</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="makerPhone1"
										placeholder="" 
										class="form-control input_base_require"
										maxLength="13"
										oninput="formatPhoneAuto(this)"
									>
								</div>
								<div class="ctn_tbl_th">제조사 연락처 #2</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="makerPhone2" 
										placeholder="" 
										class="form-control input_base_require"
										maxLength="13"
										oninput="formatPhoneAuto(this)"
									>
								</div>
							</div>	
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th">추가정보</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										name="extraInfo"
										placeholder="" 
										class="form-control"
										maxLength="50"
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