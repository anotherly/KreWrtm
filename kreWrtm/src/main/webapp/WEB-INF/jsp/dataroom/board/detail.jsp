<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../../cmn/top.jsp" flush="false" />
</head>
<script>

	$(document).ready(function(){
		console.log("상세");
		var tagId='${data.fileId}';
		
		// 수정 화면으로 이동
		$("#btnSave").on('click', function(){
			window.location = '/dataroom/board/update.do?fileId=' + tagId;
		});
		
		// 취소 버튼 클릭 시 이전 페이지로 이동
		$("#btnCancel").on('click', function(){
			history.back();
		});
		
		
		// 첨부파일 종류에 맞는 아이콘 삽입하기 
		var fileName = '${data.fileName}';
		var fileType = fileName.substring(fileName.lastIndexOf(".") + 1);
		
		fileTypeIcon(fileType);
	});
	
	
	// 첨부 파일 옆 확장자 아이콘 넣기
	function fileTypeIcon(fileType) {
		if(fileType == 'xls' || fileType == 'xlsx') {
			$("#fileIcon").addClass("excelIcon");
		} else if(fileType == 'doc' || fileType == 'docx') {
			$("#fileIcon").addClass("wordIcon");
		} else if(fileType == 'pdf') {
			$("#fileIcon").addClass("pdfIcon");
		} else if(fileType == 'jpg' || fileType == 'png' || fileType == 'gif' || fileType == 'jpeg') {
			$("#fileIcon").addClass("imgIcon");
		} else if(fileType == 'ppt' || fileType == 'pptx') {
			$("#fileIcon").addClass("pptIcon");
		} else {
			$("#fileIcon").addClass("hwpIcon");
		}
	}

</script>
<body class="open">
    <!-- lnb Start ------------------>
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침">
        <span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar" id="menuNav">
           <ul class="menu-inner"></ul>
        </nav>
    </aside>
    <!-- lnb End ------------------>
    <!-- container Start ------------------>
    <div id="container" class="container-wrap" style="margin-top: 0px;">
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
						<div class="ttl_ctn">게시판 상세정보</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<div class="ctn_tbl_area">
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">제목</div>
							<div class="ctn_tbl_td">${data.fileTitle}</div>
							<div class="ctn_tbl_th ">작성자</div>
							<div class="ctn_tbl_td">${data.writerName}</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">작성일</div>
							<div class="ctn_tbl_td">${data.regDt}</div>
							<div class="ctn_tbl_th ">첨부파일</div>
							<div class="ctn_tbl_td" id="fileTd">
								<c:choose>
							        <c:when test="${empty data.fileName}">
							            첨부파일이 없습니다.
							        </c:when>
							        <c:otherwise>
							            <div id="fileIcon" style="margin-left: 0px; margin-right: 0px;"></div>
							            <a style="color: #59636b; text-decoration: none;"
							               href="/dataroom/board/fileDownload.ajax?fileId=${data.fileId}">
							                ${data.fileName}
							            </a>
							        </c:otherwise>
							    </c:choose>
							</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">게시판 내용</div>
							<div class="ctn_tbl_td" style="white-space: pre-line; width: 100%; height: 90%; box-sizing: border-box; margin-bottom: 20px;">
									${data.boardContent}
			                </div>
						</div>
					</div>
					<!-- btn_box Start -->
					<div class="btn_box">
						<div class="right">
							<input type="button" class="btn btn_primary" id="btnSave" alt="저장" value="수정" />
							<input type="button" class="btn" id="btnCancel" alt="취소" value="취소" />
						</div>
					</div>
					<!-- btn_box End -->
				</div>					
				<!-- contents_box End -->
			</div>
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>