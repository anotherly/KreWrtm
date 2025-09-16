<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../../cmn/top.jsp" flush="false" />
</head>
<script>

	$(document).ready(function(){
		console.log("수정");

		
		// 등록 시 유효성 검사 체크하기
		$("#btnSave").on('click',function(){
				console.log("정보 저장");
				var validChk = true;
				
				var fileTitle = $('#fileTitle').val();
				var fileName = $('#fileName')[0].files;
				var boardContent = $('#boardContent').val();
				
				// 유효성 검사
				if(fileTitle.length === 0){
					alert("자료의 제목을 입력해주세요.");
					validChk = false;
					return false;
				} else if(boardContent.length === 0) {
					alert("게시판 내용을 입력해주세요.");
					validChk = false;
					return false;
				} else if (fileName.length > 1) {
				    alert("첨부파일은 1개만 선택할 수 있습니다.");
				    validChk = false;
				    return false;
				} else if(fileName.length === 1) {
					var allowedExtensions = ['xls', 'xlsx', 'ppt', 'pptx', 'png', 'jpg', 'jpeg', 'gif', 'hwp', 'doc', 'docx', 'pdf'];
				    
				    for (var i = 0; i < fileName.length; i++) {
				        var file = fileName[i];
				        var fileExt = file.name.split('.').pop().toLowerCase();  // 확장자 추출

				        if (!allowedExtensions.includes(fileExt)) {
				            alert("허용되지 않은 파일 형식입니다");
				            validChk = false;
				            return false;
				        }
				    }
				    
				    validChk = true;
				} 
				
				// 유효성 체크
				if(validChk) {
					let frm = $("#updateForm").serialize();
				    var options = {
			            url:'/dataroom/board/update.ajax',
			            type:"post",
			            dataType: "json",
			            data : frm,
			            success: function(res){
			            	alert("저장되었습니다.");
			            	location.href='/dataroom/board/list.do';
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
						<div class="ttl_ctn">게시판 수정</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="updateForm" name="updateForm" method="post" enctype="multipart/form-data">
						<input type="hidden" id="fileId" name="fileId" value="${data.fileId}">
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th ">제목</div>
								<div class="ctn_tbl_td">
									<input type="text" id="fileTitle" name ="fileTitle" value="${data.fileTitle}"  placeholder="" class="form-control input_base_require">
								</div>
								<div class="ctn_tbl_th ">작성자</div>
								<div class="ctn_tbl_td">
									${data.writerName}
								</div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th ">등록일</div>
								<div class="ctn_tbl_td">
									${data.regDt}
								</div>
								<div class="ctn_tbl_th ">첨부파일 <br>(변경시에만 선택)</div>
								<div class="ctn_tbl_td">
									<input type="file" id="fileName" name="multiFile" placeholder="변경 시에만 선택하세요." class="form-control input_base_require" multiple>
								</div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th ">게시판 내용</div>
								<div class="ctn_tbl_td">
									<textarea id="boardContent" name="boardContent" style="resize : none; height : 100px;" class="form-control input_base_require" maxlength="2000" wrap="hard">${data.boardContent}</textarea>
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