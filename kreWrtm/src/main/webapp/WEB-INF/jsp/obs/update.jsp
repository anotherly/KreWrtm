<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../cmn/top.jsp" flush="false" />
</head>
<script>

	$(document).ready(function(){
		console.log("수정");

		var toDate = new Date();
		$('#datetimepicker1').datetimepicker({
			 format:"YYYY-MM-DD",
			 defaultDate:moment()
			 ,maxDate : moment()
		});
		
		$('#datetimepicker2').datetimepicker({
			 format:"YYYY-MM-DD",
			 defaultDate:moment()
			 ,maxDate : moment()
		});
		
		
		// 등록 시 유효성 검사 체크하기
		$("#btnSave").on('click',function(){
				console.log("정보 저장");
				var validChk = true;

				var carNum = $('#carNum').val();
				
				var rptDate = $('#rptDate').val();
				var prcDate = $('#prcDate').val();
				var rptDateObj = new Date(rptDate);
				var prcDateObj = new Date(prcDate);
				
				var obsName = $('#obsName').val();
				var prcComment = $('#prcComment').val();
				var reason = $('#reason').val();
				
				if(carNum == "") {
					alert("호차를 입력해 주세요.");
					validChk = false;
					return false;
				} else if(prcDateObj < rptDateObj) {
					alert("처리 일시가 신고 일시보다 먼저일 수 없습니다. 다시 확인해 주세요.");
					validChk = false;
					return false;
				} else if(obsName == "") {
					alert("신고 증상을 입력해 주세요.");
					validChk = false;
					return false;
				} else if(prcComment == "") {
					alert("처리 내역을 입력해 주세요.");
					validChk = false;
					return false;
				} else if(reason == "") {
					alert("증상 원인을 입력해 주세요.");
					validChk = false;
					return false;
				} else {
					var chk = confirm("이대로 등록하시겠습니까?");
					
					if(chk) {
						validChk = true;
					} else {
						validChk = false;
						return false;
					}
					
				}
				
				// 유효성 체크
				if(validChk) {
					let frm = $("#updateForm").serialize();
				    var options = {
			            url:'/obs/update.ajax',
			            type:"post",
			            dataType: "json",
			            data : frm,
			            success: function(res){
			            	alert("저장되었습니다.");
			            	location.href='/obs/list.do';
			            } ,
			            error: function(res,error){
			                alert("에러가 발생했습니다."+error);
			            }
				    };
				    
				    $('#updateForm').ajaxSubmit(options);
				} else {
					alert("등록 중 문제가 생겼습니다. 다시 시도해주세요.");
					return false;
				}
		});
		
		// 취소 버튼 클릭 시 이전 페이지로 이동
		$("#btnCancel").on('click', function(){
			history.back();
		});
	});
	


</script>
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
						<div class="ttl_ctn">장애이력 수정</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="updateForm" name="updateForm" method="post" enctype="multipart/form-data">
						<input type="hidden" id="obsId" name="obsId" value="${data.obsId}">
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">호차</div>
								<div class="ctn_tbl_td">
									<input type="text" id="carNum" name ="carNum" value="${data.carNum}" maxlength="6" class="form-control input_base_require">
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">신고 일시</div>
								<div class="ctn_tbl_td">
									<div class='input-group date' id='datetimepicker1'>
										<input type='text' class="form-cont" name="rptDate" id="rptDate" value="${data.rptDate}" required/>
										<span class="input-group-addon">
											<span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
								</div>
								<div class="ctn_tbl_th fm_rep">처리 일시</div>
								<div class="ctn_tbl_td">
									<div class='input-group date' id='datetimepicker2'>
										<input type='text' class="form-cont" name="prcDate" id="prcDate" value="${data.prcDate}" required/>
										<span class="input-group-addon">
											<span class="glyphicon glyphicon-calendar"></span>
										</span>
									</div>
								</div>
							</div>
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">신고 증상</div>
								<div class="ctn_tbl_td">
									<input type="text" id="obsName" name ="obsName" value="${data.obsName}" maxlength="200" class="form-control input_base_require">
								</div>
							</div>
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">처리 내역</div>
								<div class="ctn_tbl_td">
									<input type="text" id="prcComment" name ="prcComment" value="${data.prcComment}" maxlength="200" class="form-control input_base_require">
								</div>
							</div>
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">증상 원인</div>
								<div class="ctn_tbl_td">
									<input type="text" id="reason" name ="reason" value="${data.reason}" maxlength="200" class="form-control input_base_require">
								</div>
							</div>
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th">기타</div>
								<div class="ctn_tbl_td">
									<textarea id="etc" name="etc" style="resize : none; height : 100px;" class="form-control input_base_require" maxlength="1000" wrap="hard">${data.etc}</textarea>
								</div>
							</div>
						</div>
						<!-- btn_box Start -->
						<div class="btn_box">
							<div class="right">
								<input type="button" class="btn btn_primary" id="btnSave" alt="수정" value="수정" />
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