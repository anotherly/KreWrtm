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

	$(document).ready(function(){
		console.log("상세");
		var tagId='${data.userId}';
		$("#btnSave").on('click', function(){
			location.href='/user/userUpdate.do?tagId='+tagId;
		});
		$("#btnCancel").on('click', function(){
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
						<div class="ttl_ctn">사용자 상세정보</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_row">
									<div class="ctn_tbl_th fm_rep">ID</div>
									<div class="ctn_tbl_td">
										${data.userId}
									</div>
									<div class="ctn_tbl_td"></div>
									<div class="ctn_tbl_td"></div>
								</div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">사용자명</div>
								<div class="ctn_tbl_td">
									${data.userName}
								</div>
								<div class="ctn_tbl_td"></div>
								<div class="ctn_tbl_td"></div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th  fm_rep">제조사</div>
								<div class="ctn_tbl_td">
									${data.companyName}
								</div>
								<div class="ctn_tbl_th fm_rep">소속</div>
								<div class="ctn_tbl_td">
									${data.orgName}
								</div>
							</div>
						
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">연락처 #1</div>
								<div class="ctn_tbl_td">
									${data.userPhone}
								</div>
								<div class="ctn_tbl_th">연락처 #2</div>
								<div class="ctn_tbl_td">
									${data.userPhone2}
								</div>
							</div>	
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th ">등록일</div>
								<div class="ctn_tbl_td">
									${data.regDate}
								</div>
								<div class="ctn_tbl_th">정보수정일</div>
								<div class="ctn_tbl_td">
									${data.updatedAt}
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
			<!-- work End -->
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>