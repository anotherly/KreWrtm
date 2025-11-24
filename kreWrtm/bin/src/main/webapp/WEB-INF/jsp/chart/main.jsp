<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>단말장치(LTE-R) 관리 WEB 시스템</title>
	<meta charset="UTF-8">
    <jsp:include page="../cmn/top.jsp" flush="false" />
<script>

    $(document).ready(function(){

    	// 가져온 데이터 분할
    	var hiveMB = '${HIVE}';
    	var koneMB = '${KONE}';
    	var kregMB = '${KREG}';
    	var kremMB = '${KREM}';
    	
    	
    	// 회사별 단말기 현황 
    	var routerCntList = ajaxMethod("/chart/routerList.ajax").routerList;    	
     	var columnsData = [];  // 차트 동적 생성을 위한 배열 변수 초기화

     	// 차트 동적 생성을 위한 배열에 데이터 삽입
        routerCntList.forEach(function(item) {
            columnsData.push([item.companyName, item.routerCount]);
        }); 
        
        // 차트 생성
        var chart = c3.generate({
            bindto: '.ring_chart_div',
            data: {
                columns: columnsData, // Line : 22~27
                type: 'donut'  
            },
            legend: {
                position: 'left'  
            }
        });
        
       
     
        // 차트 생성
        
        var result = ${resultJson};
        
        var chart = c3.generate({
            bindto: '.bar_chart_div',
            data: {
                x: 'x',   // x축 지정
                columns: [
                    ['x'].concat(result.x),                 // 회사명
                    ['사용량'].concat(result["사용량"]),     // 사용량
                    ['수신 데이터량'].concat(result["수신 데이터량"]), // 수신량
                    ['RSRQ'].concat(result["RSRQ"].map(function(v){ return Math.abs(v); })) // 절대값처리
                ],
                type: 'bar',
                groups: [
                    // ['사용량','수신 데이터량','RSRQ']
                ]
            },
            axis: {
                x: {
                    type: 'category' // 문자열 축
                }
            },
            bar: {
                width: {
                    ratio: 0.6
                }
            },
            legend: {
                position: 'bottom'
            }
        });

    	
    });
    
	
</script>
<style>

.top_container {
    width: 90%;
    height: 50%;
    display: flex;
    align-items: center;
    justify-content: space-around;
}

.bottom_container {
	width: 90%;
    height: 50%;
    display : flex;
    flex-direction : column;
}


.ring_chart_container , .datatable-list-01 {
    width: 48%;
    height: 100%;
}




</style>
</head>
<body class="open" >
    <!-- lnb Start ------------------>
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar">
			<ul class="menu-inner"></ul>
        </nav>
    </aside>
    <!-- lnb End ------------------>

    <!-- container Start ------------------>
    <div id="container" class="container-wrap" style="margin-top: 60px;background: none;" >
		<!-- header Start ------------------>
		<div id="header" class="header-wrap"></div>
		<!-- header End ------------------>

		<!-- contents Start ------------------>
		<div id="containerAll" class="containerAll" style="flex-direction : column; width: calc(100vw - 60px); align-items: center;">
			<!-- 내용 부분 -->
			<div class="top_container">
				<div class="ring_chart_container">
				<div class="ctn_tbl_header" style="margin-top : 20px;">
					<div class="ttl_ctn">회사별 단말기 현황</div>
				</div>
				<div class="ring_chart_div">
				</div>
				</div>
				<div class="datatable-list-01">
					<div id ="btnDiv" class="btn_box" style="display: flex;flex-direction: row-reverse;float:right;">
						<div id="btnIns" style="display: flex;justify-content: flex-end;width: 230px;">
							<!-- <input type='button' class="btn btn_primary" id='btnInsert' value='다운로드'> -->
						</div>
					</div>
					<div class="page-description">
						<div class="rows">
							<table id="tableList" style="min-width : 800px; margin-top : 70px;">
						    <thead>
						        <tr style="height :40px;">
						            <th style="min-width : 290px;">회사명</th>
						            <th style="min-width : 252px;">사용량(MB)</th>
						            <th style="min-width : 257px;">등록일</th>
						        </tr>
						    </thead>
						    <tbody>
						        <!-- 회사별 데이터 반복 출력 -->
						        <c:forEach var="company" items="${firmUseList}">
						            <tr style="height :40px;">
						                <td style="text-align: center; background-color : white;">
						                    ${company.companyName}
						                </td>
						                <td style="text-align: center; background-color : white;">
						                    ${company.dirMb}
						                </td>
						                <td style="text-align: center; background-color : white;">
						                    - ${company.dirRegDt}
						                </td>
						            </tr>
						        </c:forEach>
						
						        <!-- 합계 행 -->
						        <tr style="height :40px;">
						            <td style="text-align: center; background-color : white;">합계</td>
						            <td style="text-align: center; background-color : white;">${firmUseCnt}</td>
						            <td style="background-color : white;"></td>
						        </tr>
						    </tbody>
						</table>
						</div>
					</div>
				
				</div>
			</div>
			<div class="bottom_container">
				<div class="ctn_tbl_header" >
					<div class="ttl_ctn">제조사별 수신량 / 성능</div>
				</div>
				<div class="bar_chart_div"></div>
			</div>
		</div>
	</div>	
</body>

</html>