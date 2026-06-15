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
	.org_tbl th, .org_tbl td { padding: 6px 8px; border-bottom: 1px solid #e5e5e5; }
	.org_tbl th { background: #f7f8fa; text-align: center; font-weight: 600; }
	.org_tbl input { width: 100%; }
	.org_btn_area { margin-bottom: 8px; text-align: right; }
</style>
 	 
	<script>
		$(document).ready(function() {
			console.log("회사코드 수정 화면");
			
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
					reindexOrgRows();
					let queryString = $("#insertForm").serialize();
					ajaxMethod('/company/companyUpdate.ajax',queryString,'/company/companyList.do','저장되었습니다');
				}
				
			}); 
			
			$("#btnAddOrg").on('click', function(){
				addOrgRow('', '');
				updateOrgRemoveButtons();
			});
			
			$(document).on('click', '.btnRemoveOrg', function(){
				if($(this).prop('disabled') || $("#orgTbody tr").length <= 1){
					return false;
				}
				$(this).closest('tr').remove();
				reindexOrgRows();
				updateOrgRemoveButtons();
			});
			
			$(document).on('input', '.org-id-input', function(){
				this.value = this.value.replace(/[^A-Za-z0-9_]/g, '').toUpperCase();
			});
			
			//y면 체크 아니면 비체크인데 비체크값을 n으로 변경
			$('input[type="checkbox"]').each(function(i,list){
				console.log("하단체크박스 : "+i+"	/	"+$(this).attr("id"));
				if($(this).is(':checked')){
					$(this).val('Y');
				}else{
					$(this).val('N');
				}
			});
			
			//input 하위 모든 체크박스 클릭 시
			$('input[type="checkbox"]').on('click',function(){
				console.log("하단체크박스클릭");
				if($(this).is(':checked')){
					$(this).val('Y');
				}else{
					$(this).val('N');
				}
			});
			
			
			$("#btnCancel").on('click',function(){
				/* llocation.href='/company/companyList.do'; */
				
				history.back(); // 기존 상세 페이지로 이동하도록 변경
			});

			updateOrgRemoveButtons();
		});
		
		function addOrgRow(orgId, orgName){
			let idx = $("#orgTbody tr").length;
			let html = '';
			html += '<tr>';
			html += '  <td><input type="text" name="orgList['+idx+'].orgId" class="form-control org-id-input" maxlength="20" value="'+orgId+'" placeholder="예: CTRL"></td>';
			html += '  <td><input type="text" name="orgList['+idx+'].orgName" class="form-control" maxlength="100" value="'+orgName+'" placeholder="예: 관제실"></td>';
			html += '  <td style="text-align:center;"><input type="button" class="btn btnRemoveOrg" value="삭제" /></td>';
			html += '</tr>';
			$("#orgTbody").append(html);
		}
		
		function reindexOrgRows(){
			$("#orgTbody tr").each(function(index){
				$(this).find('input[name$=".orgId"]').attr('name', 'orgList['+index+'].orgId');
				$(this).find('input[name$=".orgName"]').attr('name', 'orgList['+index+'].orgName');
			});
		}

		function updateOrgRemoveButtons(){
			$(".btnRemoveOrg").prop("disabled", $("#orgTbody tr").length <= 1);
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
						<img class="list-title-img" src="/images/icons/ico_company_title.png"/><div class="ttl_ctn">소속기관 수정</div>
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<input type="hidden" id="departCode" name ="departCode" class="form-control">
								<div class="ctn_tbl_th fm_rep">소속기관명</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="companyName" 
										name ="companyName"  
										class="form-control input_base_require"
										maxLength="20"
										placeholder="예: 안전본부, 차량본부, 케이원"
										value="${data.companyName}"
									>
								</div>
								<div class="ctn_tbl_th fm_rep">소속기관 코드</div>
								<div class="ctn_tbl_td">
								
								<input type="hidden" 
										id="companyCode" 
										name ="companyCode" 
										placeholder="4자리 영문 대문자" 
										class="form-control"
										oninput="valComCode(event)"
										maxLength="4"
										value="${data.companyCode}"
									>
									${data.companyCode}
								</div>
							</div>
						
							<div class="ctn_tbl_row fm_rep">
								<div class="ctn_tbl_th">사용자 구분</div>
								<div class="ctn_tbl_td">
									<select name ="userType" class="form-control input_base_require">
										<option value='코레일' <c:if test="${data.userType eq '코레일'}">selected</c:if>>
											코레일
										</option>
										<option value='제조사' <c:if test="${data.userType eq '제조사'}">selected</c:if>>
											제조사
										</option>
									</select>
								</div>
							</div>
							
							<div class="ctn_tbl_row fm_rep">
								<div class="ctn_tbl_th">본부/처/실</div>
								<div class="ctn_tbl_td" style="width: calc(100% - 160px);">
									<div class="org_btn_area">
										<input type="button" class="btn" id="btnAddOrg" value="추가" />
									</div>
									<table class="org_tbl">
										<colgroup>
											<col style="width:35%;">
											<col style="width:50%;">
											<col style="width:15%;">
										</colgroup>
										<thead>
											<tr>
												<th>본부/처/실 코드</th>
												<th>본부/처/실명</th>
												<th>삭제</th>
											</tr>
										</thead>
										<tbody id="orgTbody">
											<c:choose>
												<c:when test="${empty orgList}">
													<tr>
														<td><input type="text" name="orgList[0].orgId" class="form-control org-id-input" maxlength="4" placeholder="예: CTRL"></td>
														<td><input type="text" name="orgList[0].orgName" class="form-control" maxlength="20" placeholder="예: 관제실"></td>
														<td style="text-align:center;"><input type="button" class="btn btnRemoveOrg" value="삭제" /></td>
													</tr>
												</c:when>
												<c:otherwise>
													<c:forEach var="org" items="${orgList}" varStatus="st">
														<tr>
															<td><input type="text" name="orgList[${st.index}].orgId" class="form-control org-id-input" maxlength="20" value="${org.orgId}" placeholder="예: CTRL"></td>
															<td><input type="text" name="orgList[${st.index}].orgName" class="form-control" maxlength="100" value="${org.orgName}" placeholder="예: 관제실"></td>
															<td style="text-align:center;"><input type="button" class="btn btnRemoveOrg" value="삭제" /></td>
														</tr>
													</c:forEach>
												</c:otherwise>
											</c:choose>
										</tbody>
									</table>
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
