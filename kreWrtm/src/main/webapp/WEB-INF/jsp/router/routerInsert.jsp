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
			var userTypeVal = $('#userType').val();
			changeSelect(userTypeVal);
			
			console.log("장비 등록 화면");
			var comcode = '${login.companyCode}';
			 /** 1. 장치명 입력 시 모델명 옆에 표시 */
			  $("#deviceName").on("input", function(){
			    $("#modelNameDisplay").text($(this).val());
			  });

			//volte 중복확인
			$('input[name ="volteNum"]').on("change",function(){
				dupChkFlag = false;
			});
			$("#dupChk").on('click',function(){
				var volteVal =$('input[name ="volteNum"]').val();
				var volteVal2 = volteVal;
				  if(volteVal.length<11){
					  alert("유효한 volte 값을 입력하세요");
				  }else{
					  var selectOne = ajaxMethod("/router/selectOne.ajax",{"volteNum":volteVal}).result;
					  if(selectOne != 0){
						  dupChkFlag = false;
						  $("#dupComment").empty();
						  $("#dupComment").css('color','red');
						  $("#dupComment").append("사용중인 volte 번호입니다");
						  
						  $('#phoneCell').val("");
						  
					  }else{
						  dupChkFlag = true;
						  $("#dupComment").empty();
						  $("#dupComment").css('color','blue');
						  $("#dupComment").append("사용 가능한 volte 번호입니다");

						  $('#phoneCell').val(volteVal2);
					  }
				  }
				  
			});
			
			$("#btnSave").on('click',function(){
				console.log("정보 저장");
				let validChk = true;
	
				$(".input_base_require").each(function(i,list){
					console.log("필수값체크");
					if($(this).val()==null||$(this).val()==''){
						alert("필수 항목을 기재해 주세요");
						$(this).focus();
						validChk=false;
						return false;
					}
				});
				
				if(!validChk) {
					return false;
				} else {
					if(dupChkFlag){
	 					
						var phoneChk = phoneCellChk("makerPhone1","makerPhone2");
						
						if(phoneChk) {
							// 업데이트 전 VoLTE 번호 포맷팅
							var phoneCell = $('#phoneCell').val();
							var fmtPhoneCell = phoneCell.replaceAll('-', '');
							$('#phoneCell').val(fmtPhoneCell);
							
							let queryString = $("#insertForm").serialize();
							
							ajaxMethod('/router/routerInsert.ajax',queryString,'/router/routerList.do','저장되었습니다');
						} else {
							alert("제조사 연락처가 올바르지 않습니다. 다시 확인하세요.");
						}
						
					}else{
						alert("volte 중복 체크를 확인하세요");
					}
				}
				
			}); 
			
			$("#btnCancel").on('click',function(){
				location.href='/router/routerList.do';
			});
			
			
			
			//select 변경할 때 마다 실행하는 함수
			$('#userType').on('change', function () {
			      var userValue = $(this).val();
			      changeSelect(userValue);
			});
			
			
		});
		
		// ajax 요청하는 함수
		function changeSelect(userType) {
			event.preventDefault(); 
			var comData = ajaxMethod("/router/selectCompany.ajax",{"userType":userType}).data;
			
			// option 요소 동적 생성
			$('#companyCode').empty(); 
			
			var loginComcode = '${login.companyCode}';
			var userType = '${login.userType}';
			
			if(userType != '코레일') {
				comData.forEach(function(company) {
				    if (company.companyCode == loginComcode) {  
				        $('#companyCode').append(
				            '<option value="' + company.companyCode + '">' + company.companyName + '</option>'
				        );
				    }
				});
			} else {
				comData.forEach(function(company) {
			        $('#companyCode').append(
			            '<option value="' + company.companyCode + '">' + company.companyName + '</option>'
			        );
			    });
			}
		
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
								<div class="ctn_tbl_th  fm_rep">사용자 유형</div>
								<div class="ctn_tbl_td">
									<select class="table_sel"  style="width: 164px; height:100%;" id="userType" name ="userType">
										<c:forEach var="orgVo" items="${orgList}">
									        <option value="${orgVo.userType}">${orgVo.userType}</option>
									    </c:forEach>
									</select>
								</div>
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
		                            <select class="table_sel"  style="width: 164px; height:100%;" id="companyCode" name="companyCode">
 
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
										class="form-control"
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