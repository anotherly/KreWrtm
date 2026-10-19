<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../cmn/top.jsp" flush="false" />
<script src="<%=request.getContextPath()%>/js/search/monitoringSendFlag.js"></script>
</head>
<style>
	@media (max-width: 1919px) {
	    html, body {
	        overflow-x: auto !important;
	        overflow-y: auto !important;
	    }
	    
	    .left-container {
	    	width : 1100px;
	    }
	    
	    .right-container {
	    	width : 785px;
	    }
	    
	    .contents-wrap {
	    	width : 1920px;
	    	height : 919px;
	    }
	    
	    .td-div span {
	    	font-size : 12px;
	    }
	}

</style>
<script>
	var nowTagId = '${data.deviceId}';	
		var chkTerId='${data.deviceId}';
		var volteNum = '${data.volteNum}';
		var canRemoteControl = ${sessionScope.authUrlMap['/remote/remoteControll'] == true};
		var nowPage = 0; // 현재 단말기 테이블 페이지 카운트
	var nextPage = 1;
	var startNum=0;
	var endNum=1;
	
	$(document).ready(function(){	
		console.log("모니터링");
		// 첫 진입 시 단말기 테이블 띄우기
		var alData = ajaxMethod("<%=request.getContextPath()%>/search/list.ajax");		
		var len = alData.data.length;

		// 단말기 총 개수 텍스트 변경
		$('#routerCounter').text("검색 결과 : 총 " + len + " 개");
		
		trainOne(alData.data);
		
		var tblist= $(".routerTable td");
    	$(tblist).each(function(i,list){
    		if(list==chkTerId){
    			$(list).addClass('selected');
    		}
		});
    	
    	let selectedIndex = $("#routerTable td.selected").closest("tr").index();

    	if (selectedIndex === -1) {
    	    hideTr(0, 6);
    	    startNum = 0;
    	    endNum = 1;
    	    nowPage = 0;
    	    nextPage = 1;
    	} else {
    	    let selectedPage = Math.floor(selectedIndex / 6);
    	    hideTr(selectedPage * 6, (selectedPage + 1) * 6);

    	    startNum = selectedPage;
    	    endNum = selectedPage + 1;
    	    nowPage = selectedPage;
    	    nextPage = selectedPage + 1;
    	}

		
		// 검색 조건(소속 / 장치명) 옵션 설정
		searchTypeOne(alData.comData , alData.dnData);

		$('#searchFrm').on('submit', function(event) {
			event.preventDefault();
			search();
		});
		
    	// 행 클릭 시    	
    	$(document).on('click','#router_table td',function(){
    		
        	var tblist= $(".router_table td");
        	$(tblist).each(function(i,list){
    			$(list).removeClass('selected');
    		});      	
        	
        	$(this).addClass("selected");
        	
        	$(".left-container").empty();
        	
        	chkTerId=$(this).attr('id');
        	$(".left-container").load("<%=request.getContextPath()%>/search/subDetail.do",{"deviceId":chkTerId}, function (response, status) {
                if (status !== 'success') {
                    $(".left-container").html('<p class="send-error">장비 상세정보 조회에 실패했습니다.</p>');
                }
            });
        });
    	
    	$('#companyCode').change(function() {
    		var selectedValue = $(this).val();
    		var dataList = ajaxMethod("<%=request.getContextPath()%>/search/list.ajax",{"companyId":selectedValue});
    		changeOption(dataList.dnData);
        });
    	
    	
    	//페이징 처리
 		$('.page_btn_div button').on('click',function(){

			var btnId=$(this).attr('id');
		
			if (btnId=='pageStart') {//앞으로 가기
				//starNum이 0보다 작을경우 반응하지 않음
				if(startNum>0){
					startNum=startNum-1;
					endNum=endNum-1;
					
					nowPage = startNum;
					nextPage = endNum;
					hideTr(nowPage*6,nextPage*6);

				}
			} else {//뒤로 가기
				//최대 페이지 수-1 보다 
				if(startNum<maxPage){
					startNum=startNum+1;
					endNum=endNum+1;
					
					nowPage = startNum;
					nextPage = endNum;
					hideTr(nowPage*6,nextPage*6);
				}
			}
			
		}); 
	});
	
	
	function searchTypeOne(comData, dnData) {
	    var setFirst = '<option value="all">전체</option>';
	    
	    if (comData.length > 1) {
	        $('#companyCode').append(setFirst); 
	    }
	    
	    comData.forEach(function(company) {
	        $('#companyCode').append(
	            '<option value="' + company.companyId + '">' + company.companyName + '</option>'
	        );
	    });

	    $('#deviceName').append(setFirst);
	    dnData.forEach(function(device) {
	        $('#deviceName').append(
	            '<option value="' + device.deviceName + '">' + device.deviceName + '</option>'
	        );
	    });
	    
	    

	}
	
	function changeOption (dnData) {
		$('#deviceName').empty();
		
		var setFirst = '<option value="all">전체</option>';
		$('#deviceName').append(setFirst);
	    dnData.forEach(function(device) {
	        $('#deviceName').append(
	            '<option value="' + device.deviceName + '">' + device.deviceName + '</option>'
	        );
	    });
	}
	
	
	// 검색 기능
	function search() {
		let frm = $("#searchFrm").serialize();
		var tagUrl="<%=request.getContextPath()%>/search/routerlist.ajax";
		
		var dataList;
		
		$.ajax({
			url : tagUrl,
			type : "post",
			dataType : "json",
			data : frm,
			async : false,
			success : function(data) {
				dataList = data; 
			},
			error : function(e) {
				alert("검색 시 오류가 발생했습니다 : "+e);
			}
	 	});
		
		
		nowPage = 0; 
		nextPage = 1;

		var len = dataList.data.length;

		// 단말기 총 개수 텍스트 변경
		$('#routerCounter').text("검색 결과 : 총 " + len + " 개");
		
		// 단말기 테이블 갱신
		trainOne(dataList.data);
		hideTr(nowPage*6,nextPage*6); 
	}

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
		<div id="contents" class="contents-wrap monitoring-contents">
            <div class="left-container">
                <%@ include file="monitoringDetailContent.jspf" %>
            </div>
			<div class="right-container"> <!-- 우측 단말기 테이블 -->
				<div class="search_table_div">
					<form id="searchFrm" name="searchFrm" method="post" enctype="multipart/form-data" style="display: flex; width: 100%; height: 100%; align-items: flex-end; justify-content: space-around;">
						<div style="display: flex; flex-direction: column;">
							<div id="routerCounter" style="font-size: 18px; margin-bottom: 5px;"></div>
							<div style="display : flex;">
								<div class="searchType1_container">
									<div class="searchType1_title">소속</div>
									<div class="searchType1">
										<select id="companyCode" name="companyId" style="min-width: 150px; min-height: 30px; padding-left: 5px; border-radius: 5px;">										
										</select>
									</div>
								</div>
								<div class="searchType2_container">
									<div class="searchType2_title">장치명</div>
									<div class="searchType2">
										<select id="deviceName" name="deviceName" style="min-width: 150px; min-height: 30px; padding-left: 5px; border-radius: 5px;">
											
										</select>
									</div>
								</div>
							</div>
						</div>
						

						<!-- <div class="searchBox">
							<input type="text" class="searchText" id="searchVal" name="searchVal" title="차량번호, 제조사 등을 입력하세요." placeholder="검색어를 입력하세요." style="width:300px; padding-left:25px;">
							<div class="search_btn" style="position: absolute; right: 20px; top: 110px;">
		                        <button class="btn btn_sch btn_primary" onclick="search()" style="width:auto; background : none; box-shadow : none; "><div class="ico_sch_search"></div></button>
		                    </div>
						</div> -->
						<div class="searchBox" style="display: flex;flex-direction: row;align-items: center;">
						    <input type="text" class="searchText" id="searchVal" name="searchVal" 
						        title="차량번호, 제조사 등을 입력하세요." 
						        placeholder="검색어를 입력하세요." 
						        style="width:300px; padding-left:25px;">
						
						    <button type="button" class="btn_sch" onclick="search()" style="border:none;padding-right: 18px;">
						        <div class="ico_sch_search"></div>
						    </button>
						</div>
					</form>			
				</div>
				<div class="router_table_div">
					<div class="router_table_area">
						<table id="router_table" class="router_table">
							<tbody id="routerTable">
							</tbody>
						</table>
					</div>
					
				</div>
				<div class="page_btn_div">
					<button class="page_btn_l" id="pageStart">◀</button>
    				<button class="page_btn_r" id="pageEnd">▶</button>
				</div>
			</div>
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>
