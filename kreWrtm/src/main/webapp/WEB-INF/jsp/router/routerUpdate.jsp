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
			console.log("단말기 수정 화면");
			var comcode = '${login.companyCode}';
			var bfVolte = '${data.volteNum}';
			var modNm = '${data.modelName}';
			var devNm = '${data.deviceName}';
			
			changeSelect();
			
			var companyIdVal = '${data.companyId}';
			selectDropBox(companyIdVal);
			
			//모델명 치환
			modNm=modNm.replaceAll('-'+devNm,'');
			$("#modelName").val(modNm);
			
			//장치명 치환
/* 			devNm=devNm.replaceAll(comcode+'_','');
			$("#deviceName").val(devNm);
			$("#modelNameDisplay").text(devNm); */
			
			// 장치명 치환이 올바르지 않아 수정 시 회사코드가 중복되어 저장됨
			var devNmFront = devNm.substring(0, devNm.lastIndexOf("_") + 1);
			var devNm = devNm.substring(devNm.lastIndexOf("_") + 1);
			console.log("앞:" + devNmFront);
			console.log(devNm);
			$("#deviceName").val(devNm);
			$("#modelNameDisplay").text(devNm);
			$("#deviceNameCompany").text(devNmFront);
			
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
				var bfVolteNormalized = bfVolte.replace(/[^0-9]/g, '');
				  if(volteVal.length !== 11){
					  alert("유효한 volte 값을 입력하세요");
				  }else if(volteVal === bfVolteNormalized){
					  dupChkFlag = true;
					  $("#dupComment").empty().css('color','blue').append("현재 장치에서 사용 중인 volte 번호입니다");
					  $('#phoneCell').val(volteVal);
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

						  $('#phoneCell').val(volteVal);
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
							
							ajaxMethod('<%=request.getContextPath()%>/router/routerUpdate.ajax',queryString,'<%=request.getContextPath()%>/router/routerList.do','저장되었습니다');
						} else {
							alert("제조사 연락처가 올바르지 않습니다. 다시 확인하세요.");
						}
						
					}else{
						alert("volte 중복 체크를 확인하세요");
					}
				}
				
			}); 
			
			$("#btnCancel").on('click',function(){
				/* location.href='<%=request.getContextPath()%>/router/routerList.do'; */
				
				history.back(); // 기존 상세 페이지로 이동하도록 변경
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
		
		
		
		function selectDropBox(companyId) {
			$("#companyId").val(companyId).trigger('change');
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
						
						<div class="ttl_ctn">장치 수정</div><!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
					<input type="hidden" id="deviceId" name ="deviceId" value="${data.deviceId}" >
						<p class="required-field-guide">* 표시는 필수 입력 항목입니다.</p>
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">장치명</div>
								<div class="ctn_tbl_td">
									<p id="deviceNameCompany"></p>
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
										value="${data.volteNum}"
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
										value="${data.keywords}"
									>
								</div>
								<div class="ctn_tbl_th fm_rep">차량번호</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="carNum" 
										name ="carNum" 
										placeholder="예: 123456ab" 
										class="form-control input_base_require"
										maxLength="10"
										value="${data.carNum}"
									>
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
			                            <select class="table_sel" style="width: 164px; height:100%;" id="companyId" name="companyId" onchange="document.getElementById('companyCode').value=this.options[this.selectedIndex].getAttribute('data-code')">

									</select>
									<input type="hidden" id="companyCode" name="companyCode" value="${data.companyCode}">
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
										value="${data.makerPhone1}"
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
										value="${data.makerPhone2}"
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
										value="${data.extraInfo}"
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
