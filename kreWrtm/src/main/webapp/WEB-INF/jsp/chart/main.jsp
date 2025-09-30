<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
 
    	
        // 차트 생성
        var chart = c3.generate({
            bindto: '.ring_chart_div',
            data: {
                columns: [
                    ['하이브시스템', hiveMB],  
                    ['케이원', koneMB],  
                    ['구로관제', kregMB] ,
                    ['중앙관제', kremMB]
                ],
                type: 'donut'  
            },
            legend: {
                position: 'left'  
            }
        });
        
        
        
        var chart = c3.generate({
            bindto: '.bar_chart_div',  
            data: {
                columns: [
                    ['에스트레픽', 30, 200, 200, 400, 150, 250],  
                    ['케이원', 130, 100, 100, 200, 150, 50],  
                    ['회명정보통신', 230, 200, 200, 300, 250, 250] 
                ],
                type: 'bar',  
                groups: [
                    ['에스트레픽', '케이원' ,'회명정보통신']  
                ]
            },
            grid: {
                y: {
                    lines: [{value: 0}]  
                }
            },
            axis: {
                x: {
                    tick: {
                        rotate: 0,  
                        multiline: false
                    }
                },
                y: {

                }
            },
            bar: {
                width: {
                    ratio: 0.5  
                }
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
					<div class="ttl_ctn">회사별 펌웨어 사용 비율</div>
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
									<tr style="height :40px;">
										<td style="text-align: center; background-color : white;">하이브 시스템</td>
										<td style="text-align: center; background-color : white;">${HIVE}</td>
										<td style="text-align: center; background-color : white;">${hiveRegDt}</td>
									</tr>
									<tr style="height :40px;">
										<td style="text-align: center; background-color : white;">케이원</td>
										<td style="text-align: center; background-color : white;">${KONE}</td>
										<td style="text-align: center; background-color : white;">${koneRegDt}</td>
									</tr>
									<tr style="height :40px;">
										<td style="text-align: center; background-color : white;">구로관제</td>
										<td style="text-align: center; background-color : white;">${KREG}</td>
										<td style="text-align: center; background-color : white;">${kregRegDt}</td>
									</tr>
									<tr style="height :40px;">
										<td style="text-align: center; background-color : white;">중앙관제</td>
										<td style="text-align: center; background-color : white;">${KREM}</td>
										<td style="text-align: center; background-color : white;">${kremRegDt}</td>
									</tr>
									<tr style="height :40px;">
										<c:set var="totalMB" value="${HIVE + KONE + KREG + KREM}" />
										<td style="text-align: center; background-color : white;">합계</td>
										<td style="text-align: center; background-color : white;">${totalMB}</td>
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
					<div class="ttl_ctn">금일 시간대별 사용량</div>
				</div>
				<div class="bar_chart_div"></div>
			</div>
		</div>
	</div>	
</body>

</html>