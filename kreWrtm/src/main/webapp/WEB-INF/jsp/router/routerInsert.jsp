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
			changeSelect();
			
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
				var volteVal =$('input[name ="volteNum"]').val().replace(/[^0-9]/g, '');
				var volteVal2 = volteVal;
				  if(!isValidVolteNumber(volteVal)){
					  alert("VoLTE 번호는 013으로 시작하는 11자리 숫자만 입력 가능합니다.");
				  }else{
					  var selectOne = ajaxMethod("<%=request.getContextPath()%>/router/selectOne.ajax",{"volteNum":volteVal}).result;
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
				} else if(!isValidVolteNumber($('input[name="volteNum"]').val())) {
					alert("VoLTE 번호는 013으로 시작하는 11자리 숫자만 입력 가능합니다.");
					$('input[name="volteNum"]').focus();
					return false;
				} else if(!validateCarNumber($('input[name="carNum"]').val())) {
					alert("차량번호는 숫자 6자리만 입력 가능합니다.");
					$('input[name="carNum"]').focus();
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
							
							ajaxMethod('<%=request.getContextPath()%>/router/routerInsert.ajax',queryString,'<%=request.getContextPath()%>/router/routerList.do','저장되었습니다');
						} else {
							alert("제조사 연락처가 올바르지 않습니다. 다시 확인하세요.");
						}
						
					}else{
						alert("volte 중복 체크를 확인하세요");
					}
				}
				
			}); 
			
			$("#btnCancel").on('click',function(){
				location.href='<%=request.getContextPath()%>/router/routerList.do';
			});
			
			
			
		});
		
		// 로그인 사용자의 조회 범위에 맞는 소속기관 목록 구성
		function changeSelect() {
			var comData = ajaxMethod("<%=request.getContextPath()%>/router/selectCompany.ajax",{}).data;
			
			// option 요소 동적 생성
			$('#companyId').empty();
			
			var loginComcode = '${login.companyCode}';
			var loginUserType = '${login.userType}';
			
			if(loginUserType != '코레일') {
				comData.forEach(function(company) {
				    if (company.companyCode == loginComcode) {  
				        $('#companyId').append(
				            '<option value="' + company.companyId + '" data-code="' + company.companyCode + '">' + company.companyName + '</option>'
				        );
				    }
				});
			} else {
				comData.forEach(function(company) {
			        $('#companyId').append(
			            '<option value="' + company.companyId + '" data-code="' + company.companyCode + '">' + company.companyName + '</option>'
			        );
			    });
			}
			$('#companyId').trigger('change');
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
					<img class="list-title-img" src="<%=request.getContextPath()%>/images/icons/ico_device_title.png"/>
						<div class="ttl_ctn">장치 등록</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
						<p class="required-field-guide">* 표시는 필수 입력 항목입니다.</p>
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
										placeholder="최대 10자"
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
										placeholder="예: 013-1234-5678" 
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
								<div class="ctn_tbl_th">키워드</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="keywords" 
										name ="keywords" 
										placeholder="예: 서해선|SDM845" 
										class="form-control"
										maxLength="20"
									>
								</div>
								<div class="ctn_tbl_th fm_rep">차량번호</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="carNum" 
										name ="carNum" 
										placeholder="예: 123456" 
										class="form-control input_base_require"
										maxLength="6"
									data-digits-only="Y"
									data-digits-max="6"
									oninput="formatDigitsOnlyInput(this,6)"
									>
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
			                            <select class="table_sel" style="width: 164px; height:100%;" id="companyId" name="companyId" onchange="document.getElementById('companyCode').value=this.options[this.selectedIndex].getAttribute('data-code')">
 
									</select>
									<input type="hidden" id="companyCode" name="companyCode" value="${login.companyCode}">
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">제조사 연락처 #1</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="phoneCell" 
										name ="makerPhone1"
										placeholder="예: 010-1234-5678" 
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
										placeholder="예: 02-1234-5678" 
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
										placeholder="예: 비고 사항 입력" 
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
