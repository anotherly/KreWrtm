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
	var nowPage = 0; // 현재 단말기 테이블 페이지 카운트
	var nextPage = 1;
	var startNum=0;
	var endNum=1;
	
	$(document).ready(function(){	
		console.log("모니터링");
		// 첫 진입 시 단말기 테이블 띄우기
		var alData = ajaxMethod("/search/list.ajax");		
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
		
    	// 행 클릭 시    	
    	$(document).on('click','#router_table td',function(){
    		
        	var tblist= $(".router_table td");
        	$(tblist).each(function(i,list){
    			$(list).removeClass('selected');
    		});      	
        	
        	$(this).addClass("selected");
        	
        	$(".left-container").empty();
        	
        	chkTerId=$(this).attr('id');
        	$(".left-container").load("/search/subDetail.do",{"deviceId":chkTerId});
        });
    	
    	$('#companyCode').change(function() {
    		var selectedValue = $(this).val();
    		var dataList = ajaxMethod("/search/list.ajax",{"companyCode":selectedValue});
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
	            '<option value="' + company.companyCode + '">' + company.companyName + '</option>'
	        );
	    });

	    $('#deviceName').append(setFirst);
	    dnData.forEach(function(device) {
	        $('#deviceName').append(
	            '<option value="' + device.deviceName + '">' + device.deviceName + '</option>'
	        );
	    });
	    
	    
	    // 원격제어 버튼
	    $('.custom-btn').on('click', function() {
	    	var clickCar = $(this).attr('id');
	    	console.log("버튼 클릭 : " + clickCar);
	    	
	    	var chkRemote = confirm("해당 호차(" + clickCar + ") 원격 제어를 실행하시겠습니까?");
	    	
	    	if(chkRemote) {
	    		
	    		// 숨긴 iframe 생성해서 커스텀 프로토콜 호출 (페이지 이동 없음)
	    	    /* var iframe = document.createElement('iframe');
	    	    iframe.style.display = 'none';
	    	    iframe.id = 'protoCallFrame';
	    	    iframe.src = "test://";
	    	    document.body.appendChild(iframe);

	    	    // 안전하게 제거 (시간은 환경에 따라 조정)
	    	    setTimeout(function() {
	    	        var f = document.getElementById('protoCallFrame');
	    	        if (f) f.parentNode.removeChild(f);
	    	    }, 1500); */
	    	    window.location.href = "/remote/remoteControll.ajax?volteNum=" + volteNum;
	    	} else {
	    		return false;
	    	}	    	
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
		var tagUrl="/search/routerlist.ajax";
		
		event.preventDefault();  // ajax 제출 이후 form 전송 방지
		
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
		<div id="contents" class="contents-wrap">
			<div class="left-container">  <!-- 좌측 정보 테이블 -->
				<div class="click_title_div">
					<div class="sub_title_div" style="font-weight : bold;">실시간 수신 데이터 보기</div>
					<div class="carNum_container">
						<div class="arrow" style="margin-right: 20px;">▷</div>
						<div class="select_carNum" id="select_carNum" style="font-weight : bold;">
							${data.carNum} / 
							<c:choose>
						        <c:when test="${data.location == 1}">TC1</c:when>
						        <c:when test="${data.location == 2}">TC2</c:when>
						        <c:otherwise>정보 없음</c:otherwise>
						    </c:choose>
						</div>
					</div>
				</div> <!-- 상단 타이틀 div -->
				<div class="click_table_div">
					<div class="table_area">
						<div class="table_row" style="border-bottom: 1px solid #1181d7;">
							<div class="table_title_th">항목</div>
							<div class="table_title_th">데이터(정보)</div>
							<div class="table_title_th">항목</div>
							<div class="table_title_th">데이터(정보)</div>
						</div>
						<div class="table_row">
						    <div class="table_th tbl_cc">차량 번호</div>
						    <div class="table_td tbl_cc">
						        ${empty data.carNum ? '정보 없음' : data.carNum}
						    </div>
						
						    <div class="table_th tbl_cc">RSRQ</div>
						    <div class="table_td tbl_cc">
						        ${empty data.rsrq ? '정보 없음' : data.rsrq} 
						        <c:if test="${not empty data.rsrq}"> dBm</c:if>
						    </div>
						</div>
						<div class="table_row">
						    <div class="table_th">탑재 위치</div>
						    <div class="table_td">
						        <c:choose>
						            <c:when test="${data.location == 1}">TC1</c:when>
						            <c:when test="${data.location == 2}">TC2</c:when>
						            <c:otherwise>정보 없음</c:otherwise>
						        </c:choose>
						    </div>
						
						    <div class="table_th">VoLTE 번호</div>
						    <div class="table_td">
						        ${empty data.volteNum ? '정보 없음' : data.volteNum}
						    </div>
						</div>						
						<div class="table_row">
						    <div class="table_th tbl_cc">장치명</div>
						    <div class="table_td tbl_cc">
						        ${empty data.deviceName ? '정보 없음' : data.deviceName}
						    </div>
						
						    <div class="table_th tbl_cc">PTT 번호</div>
						    <div class="table_td tbl_cc">
						        ${empty data.mcpttNum ? '정보 없음' : data.mcpttNum}
						    </div>
						</div>
						<div class="table_row">
						    <div class="table_th">모델명</div>
						    <div class="table_td">
						        ${empty data.modelName ? '정보 없음' : data.modelName}
						    </div>						    
						    <div class="table_th">현재 무선방식</div>
						    <div class="table_td">
						        ${empty data.currentRadioType ? '정보 없음' : data.currentRadioType}
						    </div>
						</div>
						
						<div class="table_row">
						    <div class="table_th tbl_cc">SW 버전</div>
						    <div class="table_td tbl_cc">
						        ${empty data.version ? '정보 없음' : data.version}
						    </div>
						    
						    <div class="table_th tbl_cc">무선망 자동절체</div>
						    <div class="table_td tbl_cc">
						        <c:choose>
						            <c:when test="${data.autoSwitchingRadio == 1}">예</c:when>
						            <c:when test="${data.autoSwitchingRadio == 0}">아니오</c:when>
						            <c:otherwise>정보 없음</c:otherwise>
						        </c:choose>
						    </div>
						</div>						
						<div class="table_row">
						    <div class="table_th">사용 유심</div>
						    <div class="table_td">
						        <c:choose>
								    <c:when test="${empty data.usimSlot}">
								        정보 없음
								    </c:when>
								    <c:otherwise>
								        ${data.usimSlot} 번 유심
								    </c:otherwise>
								</c:choose>
						    </div>						    
						    <div class="table_th">셀 아이디</div>
						    <div class="table_td">
						        ${empty data.cellId ? '정보 없음' : data.cellId}
						    </div>
						</div>				
						<div class="table_row">
						    <div class="table_th tbl_cc">VNC IP</div>
						    <div class="table_td tbl_cc">
						        ${empty data.vncIp ? '정보 없음' : data.vncIp}
						    </div>
						    
						    <div class="table_th tbl_cc">(GPS)위도</div>
						    <div class="table_td tbl_cc">
						        ${empty data.gpsLat ? '정보 없음' : data.gpsLat}
						    </div>
						</div>						
						<div class="table_row">
						    <div class="table_th">로컬 IP</div>
						    <div class="table_td">
						        ${empty data.localIp ? '정보 없음' : data.localIp}
						    </div>
						    
						    <div class="table_th">(GPS)경도</div>
						    <div class="table_td">
						        ${empty data.gpsLon ? '정보 없음' : data.gpsLon}
						    </div>
						</div>						
						<div class="table_row">
						    <div class="table_th tbl_cc">IMEI</div>
						    <div class="table_td tbl_cc">
						        ${empty data.imei ? '정보 없음' : data.imei}
						    </div>
						    
						    <div class="table_th tbl_cc">키워드</div>
						    <div class="table_td tbl_cc">
						        ${empty data.keywords ? '정보 없음' : data.keywords}
						    </div>
						</div>
						<div class="table_row">
						    <div class="table_th">IMSI</div>
						    <div class="table_td">
						        ${empty data.imsi ? '정보 없음' : data.imsi}
						    </div>
						
						    <div class="table_th">추가정보</div>
						    <div class="table_td extraInfo" title="${data.extraInfo}">
						        ${empty data.extraInfo ? '정보 없음' : data.extraInfo}
						    </div>
						</div>					
						<div class="table_row">
						    <div class="table_th tbl_cc">RSRP</div>
						    <div class="table_td tbl_cc">
						        ${empty data.rsrp ? '정보 없음' : data.rsrp} 
						        <c:if test="${not empty data.rsrq}"> dBm</c:if>
						    </div>
						
						    <div class="table_th tbl_cc">수신시간</div>
						    <div class="table_td tbl_cc">
						        ${empty data.rcvDt ? '정보 없음' : data.rcvDt}
						    </div>
						</div>
					</div>
				
				</div> <!-- 정보 테이블 div -->		
				<div class="click_remote_div">
					<button class="custom-btn btn-1" id="${data.carNum}">원격제어 <br> 차량번호 : ${data.carNum}</button>
				</div> <!-- 원격제어 버튼 div -->
			</div>
			<div class="right-container"> <!-- 우측 단말기 테이블 -->
				<div class="search_table_div">
					<form id=searchFrm name="searchFrm" method="post" enctype="multipart/form-data" style="display: flex; width: 100%; height: 100%; align-items: flex-end; justify-content: space-around;">
						<div style="display: flex; flex-direction: column;">
							<div id="routerCounter" style="font-size: 18px; margin-bottom: 5px;"></div>
							<div style="display : flex;">
								<div class="searchType1_container">
									<div class="searchType1_title">소속</div>
									<div class="searchType1">
										<select id="companyCode" name="companyCode" style="min-width: 150px; min-height: 30px; padding-left: 5px; border-radius: 5px;">										
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
						
						    <button class="btn_sch" onclick="search()" style="border:none;">
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