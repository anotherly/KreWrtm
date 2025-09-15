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
		$(document).ready(function() {
			console.log("회사코드 수정 화면");
			
			$("#btnSave").on('click',function(){
				console.log("정보 저장");
				
				$(".input_base_require").each(function(i,list){
					console.log("필수값체크");
					if($(this).val()==null||$(this).val()==''){
						alert("필수 항목을 기재해 주세요");
						$(this).focus();
						validChk=false;
						return false;
					}
				});
				
				let queryString = $("#insertForm").serialize();
				ajaxMethod('/company/companyUpdate.ajax',queryString,'/company/companyList.do','저장되었습니다');
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
				location.href='/company/companyList.do';
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
						<div class="ttl_ctn">사용자 수정</div>
						<!-- 설명글 -->
					</div>
					<!-- 컨텐츠 테이블 헤더 End -->
					<!-- 컨텐츠 테이블 영역 Start -->
					<form id="insertForm" name="insertForm" method="post" enctype="multipart/form-data">
						<!-- 컨텐츠 테이블 영역 Start -->
						<div class="ctn_tbl_area">
							<div class="ctn_tbl_row">
								<input type="hidden" id="departCode" name ="departCode" class="form-control">
								<div class="ctn_tbl_th fm_rep">회사명</div>
								<div class="ctn_tbl_td">
									<input type="text" 
										id="companyName" 
										name ="companyName" 
										placeholder="4자리 영문 대문자"  
										class="form-control input_base_require"
										maxLength="20"
										value="${data.companyName}"
									>
								</div>
								<div class="ctn_tbl_th fm_rep">회사코드</div>
								<div class="ctn_tbl_td">
								
								<input type="hidden" 
										id="companyCode" 
										name ="companyCode" 
										placeholder="" 
										class="form-control input_base_require"
										oninput="valComCode(event)"
										maxLength="4"
										value="${data.companyCode}"
									>
									${data.companyCode}
								</div>
							</div>
						
							<div class="ctn_tbl_row  fm_rep">
								<div class="ctn_tbl_th ">사용자 구분</div>
								<div class="ctn_tbl_td">
									<select name ="userType">
										<option value='코레일'<c:if test="${data.userType eq '코레일'}">selected</c:if>>
											코레일
										</option>
										<option value='제조사'<c:if test="${data.userType eq '제조사'}">selected</c:if>>
											제조사
										</option>
									</select>
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