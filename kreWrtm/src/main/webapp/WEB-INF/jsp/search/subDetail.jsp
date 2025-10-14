<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<script>
	$(document).ready(function () {
		// 원격제어 버튼
	    $('.custom-btn').on('click', function() {
	    	var clickCar = $(this).attr('id');
	    	console.log("버튼 클릭 : " + clickCar);
	    	
	    	var chkRemote = confirm("해당 호차(" + clickCar + ") 원격 제어를 실행하시겠습니까?");
	    	
	    	if(chkRemote) {
	    		// 숨긴 iframe 생성해서 커스텀 프로토콜 호출 (페이지 이동 없음)
	    	    var iframe = document.createElement('iframe');
	    	    iframe.style.display = 'none';
	    	    iframe.id = 'protoCallFrame';
	    	    iframe.src = "test://";
	    	    document.body.appendChild(iframe);

	    	    // 안전하게 제거 (시간은 환경에 따라 조정)
	    	    setTimeout(function() {
	    	        var f = document.getElementById('protoCallFrame');
	    	        if (f) f.parentNode.removeChild(f);
	    	    }, 1500);
	    	    
	    	    
	    	    // 현재는 사용하지 않음
	    		/* ajaxMethod("/remote/remoteControll.ajax",{"carNum" : clickCar}); */
	    	} else {
	    		return false;
	    	}	    	
	    });
	});

</script>
	<div class="click_title_div">
	    <div class="sub_title_div" style="font-weight: bold;">실시간 수신 데이터 보기</div>
	
	    <div class="carNum_container">
	        <div class="arrow" style="margin-right: 20px;">▷</div>
	
	        <div class="select_carNum" id="select_carNum" style="font-weight: bold;">
	            ${data.carNum} / 
	            <c:choose>
					<c:when test="${data.location == 1}">TC1</c:when>
					<c:when test="${data.location == 2}">TC2</c:when>
					<c:otherwise>정보 없음</c:otherwise>
				</c:choose>
	        </div>
	    </div>
	</div> 
	
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
						    <div class="table_th tbl_cc">모바일 IP</div>
						    <div class="table_td tbl_cc">
						        ${empty data.mobileIp ? '정보 없음' : data.mobileIp}
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
	    <button class="custom-btn btn-1" id="${data.carNum}">
	        원격제어 <br> 차량번호 : ${data.carNum}
	    </button>
	</div> <!-- 원격제어 버튼 div -->
</html>