<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<script>
$(document).ready(function() {
	console.log("메뉴 화면");
	var contextPath = "<%=request.getContextPath()%>";

	$(".menu-item a").on('click',function(){
		console.log("소메뉴 확장을 위한 메뉴 클릭");
		//메뉴확장이 된 경우
		if(!$("body").hasClass("open")){
			//서브메뉴가 활성화 된 경우 -> 비활성화
			if($(this).parent().attr("class").indexOf("open")!=-1){
				$(this).parent().removeClass("open");
			//서브메뉴 비활성일경우 -> 서브메뉴 표출 및 기존 활성화 제거
			}else{
				$(this).parent().parent().children().each(function(i,list){
					$(list).parent().removeClass("open");
				});
				$(this).parent().addClass("open");
			}
			
			//주소 이동
			if($(this).parent().find("ul").length==0){
				if($(this).attr("id")!==''){
					location.href=contextPath + $(this).attr("id");
				}
			}
			
		}else{
			if($(this).attr("id")!==''){
				location.href=contextPath + $(this).attr("id");
			}
		}
	});
});
</script>

<c:if test="${sessionScope.authUrlMap['/chart/main']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/chart/main.do" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n01"></i>
		<div>운용/사용률 현황</div>
	</a>
</li>
</c:if>
<c:if test="${sessionScope.authUrlMap['/user/userList']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/user/userList.do" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n07"></i>
		<div>사용자 관리</div>
	</a>
</li>
</c:if>
<c:if test="${sessionScope.authUrlMap['/company/companyList']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/company/companyList.do" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n09"></i>
		<div>소속기관 관리</div>
	</a>
</li>	
</c:if>
<c:if test="${sessionScope.authUrlMap['/router/routerList']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/router/routerList.do" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n02"></i>
		<div>장치 관리</div>
	</a>
</li>
</c:if>
<c:if test="${sessionScope.authUrlMap['/search/list']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/search/list.do" class="menu-link" style="color: rgb(255, 255, 255); cursor:pointer;">
		<i style="
    background: url(../images/icons/btn_sch.png) no-repeat 0 0;
    opacity: 0.5;
    transition: all 0.3s;
    flex-grow: 0;
    flex-shrink: 0;
    font-size: 15px;
    width: 24px;
    height: 23px;"></i>
		<div>검색 & 모니터링</div>
	</a>
	<ul class="menu-sub">
		<li class="menu-item" style="cursor:pointer;"><a id="/depart/list.do" class="menu-link"><div>단말기 검색</div></a></li>
		<li class="menu-item" style="cursor:pointer;"><a id="#" class="menu-link"><div>실시간 상태 조회</div></a></li>
	</ul>
</li>	
</c:if>
<c:if test="${sessionScope.authUrlMap['/obs/list']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a href="<%=request.getContextPath()%>/obs/list.do?" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n03"></i>
		<div>장애 관리</div>
	</a>
</li>
</c:if>
<c:if test="${sessionScope.authUrlMap['/dataroom/list']}">
<li class="menu-item" id="ROOT_TEST_SW">
	<a id="/dataroom/list.do" class="menu-link" style="color: rgb(255, 255, 255); cursor:pointer;">
		<i class="menu-icon n06"></i>
		<div>자료실</div>
	</a>
	<ul class="menu-sub">
		<li class="menu-item" style="cursor:pointer;"><a id="/dataroom/list.do" class="menu-link"><div>자료실</div></a></li>
		<li class="menu-item" style="cursor:pointer;"><a id="/dataroom/board/list.do" class="menu-link"><div>게시판</div></a></li>
	</ul>
</li>
</c:if>
<c:if test="${sessionScope.authUrlMap['/setting/main']}">
<li class="menu-item" id="ROOT_SETTING">
	<a href="<%=request.getContextPath()%>/setting/main.do" class="menu-link" style="color: rgb(255, 255, 255);">
		<i class="menu-icon n08"></i>
		<div>설정</div>
	</a>
</li>
</c:if>
