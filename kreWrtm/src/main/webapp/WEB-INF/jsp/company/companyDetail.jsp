<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<meta charset="UTF-8">
<jsp:include page="../cmn/top.jsp" flush="false" />

<style>
	.org_tbl { width: 100%; border-collapse: collapse; }
	.org_tbl th, .org_tbl td { padding: 8px 10px; border-bottom: 1px solid #e5e5e5; }
	.org_tbl th { background: #f7f8fa; text-align: center; font-weight: 600; }
	.org_tbl td { text-align: left; }
	.empty_org { padding: 10px 0; color: #777; }
</style>

<script>

	$(document).ready(function(){
		console.log("상세");
		var tagId='${data.companyId}';
		$("#btnSave").on('click', function(){
			location.href='<%=request.getContextPath()%>/company/companyUpdate.do?tagId='+tagId;
		});
		$("#btnCancel").on('click', function(){
			location.href='<%=request.getContextPath()%>/company/companyList.do';
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
						<img class="list-title-img" src="<%=request.getContextPath()%>/images/icons/ico_company_title.png"/><div class="ttl_ctn">소속기관 상세</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<input type="hidden" id="departCode" name ="departCode" class="form-control">
								<div class="ctn_tbl_th fm_rep">소속기관명</div>
								<div class="ctn_tbl_td">
									${data.companyName}
								</div>
								<div class="ctn_tbl_th fm_rep">소속기관 코드</div>
								<div class="ctn_tbl_td">
									${data.companyCode} 
								</div>
							</div>
						
							<div class="ctn_tbl_row fm_rep">
								<div class="ctn_tbl_th">사용자 구분</div>
								<div class="ctn_tbl_td">
									${data.userType}
								</div>
							</div>
							
							<div class="ctn_tbl_row fm_rep">
								<div class="ctn_tbl_th">본부/처/실</div>
								<div class="ctn_tbl_td" style="width: calc(100% - 160px);">
									<c:choose>
										<c:when test="${empty orgList}">
											<div class="empty_org">등록된 본부/처/실 정보가 없습니다.</div>
										</c:when>
										<c:otherwise>
											<table class="org_tbl">
												<colgroup>
													<col style="width:40%;">
													<col style="width:60%;">
												</colgroup>
												<thead>
													<tr>
														<th>본부/처/실 코드</th>
														<th>본부/처/실명</th>
													</tr>
												</thead>
												<tbody>
													<c:forEach var="org" items="${orgList}">
														<tr>
															<td>${org.orgId}</td>
															<td>${org.orgName}</td>
														</tr>
													</c:forEach>
												</tbody>
											</table>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</div>
						<!-- btn_box Start -->
						<div class="btn_box">
							<div class="right">
								<c:choose>
									<c:when test="${sessionScope.authUrlMap['/company/companyUpdate']}">
										<input type="button" class="btn btn_primary" id="btnSave" alt="수정" value="수정" />
										<input type="button" class="btn" id="btnCancel" alt="취소" value="취소" />
									</c:when>
									<c:otherwise><input type="button" class="btn btn_primary" id="btnCancel" alt="목록으로" value="목록으로" /></c:otherwise>
								</c:choose>
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
