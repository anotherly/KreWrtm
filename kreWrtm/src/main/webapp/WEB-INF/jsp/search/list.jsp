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
	$(document).ready(function() {

	  $('#searchValue').on('keydown', function(event) {
	    if (event.key === 'Enter') {
	      event.preventDefault();  
	      search();
	    }
	  });
	});
	
	
	
	/* 검색 함수 */
	function search() {
	    let frm = $("#searchFrm").serialize();
	    var tagUrl = "/search/search.do";

	    
	    var form = document.forms["searchFrm"];
	    
	    var searchVal = $('#searchValue').val();
	                                                                                                                                                                                                                                                                       
	  	if(searchVal.length < 2) {
	  		alert("검색어가 너무 짧습니다. 2글자 이상 입력해주세요.");
	  		return false;
	  	} else {
	  		form.action = "/search/search.do";
	  		form.submit();		    
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
			<div id="work" class="work-wrap list_page" style="justify-content : center; align-items : center;">
				<div class="ctn_tbl_header">
				<img class="list-title-img" src="/images/icons/ico_search_title.png"/>
					<div class="ttl_ctn" style="font-size : 32px;">장치 검색</div>
				</div>
                <!-- search_box Start -->
                <div class="search_box" style="margin-bottom : calc( 10px + 22vh); margin-top: calc(10px + 0vh); background : none; box-shadow : none;">
                	<form id=searchFrm name="searchFrm" class="search_form" method="post" enctype="multipart/form-data" style="justify-content : center;">
                            <input type="text" class="searchText" id="searchValue" name="searchValue" placeholder="차량번호, 제조사 등 검색어를 입력하세요.">
                    </form>
                     <div class="search_btn" style="position: absolute;right: 320px;">
                        <button class="btn btn_sch btn_primary" onclick="search()" style="width:auto; background : none; box-shadow : none;"><div class="ico_sch_search"></div></button>
                    </div>
                </div>
                <!-- search_box End -->            
			</div>	
			<!-- work End -->
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>