<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../cmn/top.jsp" flush="false" />
</head>
<script>

	$(document).ready(function(){
		var tagId='${data.obsId}';
		
		// 수정 화면으로 이동
		$("#btnSave").on('click', function(){
			window.location = '/obs/update.do?obsId=' + tagId;
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
						<div class="ttl_ctn">장애이력 상세정보</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<div class="ctn_tbl_area">
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">호차</div>
							<div class="ctn_tbl_td">${data.carNum}</div>
							<div class="ctn_tbl_th ">진행 상태</div>
							<div class="ctn_tbl_td">
							<c:choose>
						        <c:when test="${data.status == '0'}">
						            <div class="status_0">조치 진행중</div>
						        </c:when>
						        <c:when test="${data.status == '1'}">
						            <div class="status_1">조치 대기중</div>
						        </c:when>
						        <c:when test="${data.status == '2'}">
						            <div class="status_2">조치 완료</div>
						        </c:when>
						        <c:otherwise>
						            <div class="status_3">알 수 없음</div>
						        </c:otherwise>
						    </c:choose>							
							</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">신고 일시</div>
							<div class="ctn_tbl_td">${data.rptDate}</div>
							<div class="ctn_tbl_th ">처리 일시</div>
							<div class="ctn_tbl_td">
							    <c:choose>
							        <c:when test="${empty data.prcDate}">
							           	 해당 없음
							        </c:when>
							        <c:otherwise>
							            ${data.prcDate}
							        </c:otherwise>
							    </c:choose>
							</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">신고 증상</div>
							<div class="ctn_tbl_td">${data.obsName}</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">처리 내역</div>
							<div class="ctn_tbl_td">${data.prcComment}</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">증상 원인</div>
							<div class="ctn_tbl_td">${data.reason}</div>
						</div>
						<div class="ctn_tbl_row">
							<div class="ctn_tbl_th ">기타</div>
							<div class="ctn_tbl_td" style="white-space: pre-line; width: 100%; height: 90%; box-sizing: border-box; margin-bottom: 20px;">${data.etc}</div>
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