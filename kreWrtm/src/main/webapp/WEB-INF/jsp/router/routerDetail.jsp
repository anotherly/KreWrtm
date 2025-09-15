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
		var tagId='${data.deviceId}';
		$("#btnSave").on('click', function(){
			location.href='/router/routerUpdate.do?tagId='+tagId;
		});
		$("#btnCancel").on('click', function(){
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
						<div class="ttl_ctn">장치 상세정보</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">장치명</div>
								<div class="ctn_tbl_td">
										${data.deviceName} 
								</div>
								<div class="ctn_tbl_td">제조사 코드 4자리 + '_' + 장치약어 4자리</div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">모델명</div>
								<div class="ctn_tbl_td">
										${data.modelName}
								</div>
								<div class="ctn_tbl_td">사용처 + '-' + 장치명 조합</div>
								<div class="ctn_tbl_td"></div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">VoLTE 번호</div>
								<div class="ctn_tbl_td">
										${data.volteNum}
								</div>
							</div>
							
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th fm_rep">키워드</div>
								<div class="ctn_tbl_td">
										${data.keywords}								
								</div>
								<div class="ctn_tbl_th fm_rep">차량번호</div>
								<div class="ctn_tbl_td">
										${data.carNum}								
								</div>
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
								<div class="ctn_tbl_th fm_rep">제조사 연락처 #1</div>
								<div class="ctn_tbl_td">
										${data.makerPhone1}
								</div>
								<div class="ctn_tbl_th">제조사 연락처 #2</div>
								<div class="ctn_tbl_td">
										${data.makerPhone2}
								</div>
							</div>	
							<div class="ctn_tbl_row">
								<div class="ctn_tbl_th">추가정보</div>
								<div class="ctn_tbl_td">
									${data.extraInfo}
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