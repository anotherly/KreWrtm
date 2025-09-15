<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>단말장치(LTE-R) 관리 WEB 시스템</title>
	<meta charset="UTF-8">
    <jsp:include page="../cmn/top.jsp" flush="false" />
<script>
	var teamCode='';
	var chkTerId='';
	$(document).ready(function(){
		
		var alData=ajaxMethod("/router/routerList.ajax");
		trainOne(alData.data);
		
		//시간 갱신
		$("#nowDt").text(alData.nowDt);
		
		console.log("chart 진입");
		
		//페이징 처리
		$('#paging span').on('click',function(){
			var btnId=$(this).attr('id');
			if (btnId=='pageStart') {//앞으로 가기
				//starNum이 0보다 작을경우 반응하지 않음
				if(startNum>0){
					startNum=startNum-1;
					endNum=endNum-1;
					hideTr(startNum*6,endNum*6);
				}
			} else {//뒤로 가기
				//최대 페이지 수-1 보다 
				if(startNum<maxPage){
					startNum=startNum+1;
					endNum=endNum+1;
					hideTr(startNum*6,endNum*6);
				}
			}
		});
		//우측상단 탭 클릭시
		//팀별 조회
		$(".arex_tab").on('click',function(){
			//색상 활성 비활성
			var parDiv=$(this).parent().children();
			$(parDiv).each(function(i,list){
				$(list).removeClass('selected');
			});
			var tagId = $(this).attr('id');
			$(this).addClass('selected');
			
			if(tagId!='tab_all'){
				teamCode=tagId;
			}else{
				teamCode='';
			}
			alData=ajaxMethod("/terminal/list.ajax",{"teamCode":teamCode}).data;
			if(alData.length!=0){
				trainOne(alData);
			}
		});
		
		//좌측 메인차트 갱신
		mainChartTimer=setInterval(function(){
			$("#all_chart").empty();
		},30*1000);
		
		//우측 단말기 갱신
		tableTimer=setInterval(function(){
			console.log("우측 단말기 갱신");
			var alData=ajaxMethod("/terminal/list.ajax");
			trainOne(alData.data);
			
			//시간 갱신
			$("#nowDt").text(alData.nowDt);
			
			//상세보기에서 갱신되도 배경선택은 유지하도록
			var tblist= $(".lte-table td");
	    	$(tblist).each(function(i,list){
	    		if(list==chkTerId){
	    			$(list).addClass('selected');
	    		}
			});
			
		},30*1000);
	});
	
	//동적 테이블(삭제 및 갱신)시 td 클릭 이벤트
	//차트 상세
    $(document).on('click','#trainTb td',function(){
    	var tblist= $(".lte-table td");
    	$(tblist).each(function(i,list){
			$(list).removeClass('selected');
		});
    	$(this).addClass("selected");
    	chartTimerReset();
    	
    	$("#all_chart").empty();
    	
    	chkTerId=$(this).attr('id');
    	$("#all_chart").load("/chart/subDetail.do",{"lteRIp":chkTerId});
    });
	
</script>
</head>
<!-- style="background: url(../images/bg/bg0.png);background-size: cover;" -->
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
		<div id="containerAll" class="containerAll">
			<!-- 내용 부분 -->
			<!-- <div id="container_chart" class="container_b"></div> -->
			<div id="all_chart" class="container_b"></div>
			<!-- 우측 단말기 테이블 전체-->
			<div id="container_b" class="container_b" style="padding: 20px 0 0 37px;">
				<!-- 팀별 선택 현황 -->
				<div style="width:100%;display:flex;margin-bottom:10px;">
					<div id="teamSlt" class="tab_container" style="display:flex;">
						<div id="tab_all" class="arex_tab selected"><span>전체</span></div>
						<div id="sht" class="arex_tab"><span>신호</span></div>
						<div id="sst" class="arex_tab"><span>시설</span></div>
						<div id="jgt" class="arex_tab"><span>전기</span></div>
					</div>
					<div id="paging" style="width: 100px;">
						<span id="pageStart" class="pg-btn">◀</span>
						<span id="pageEnd"  class="pg-btn">▶</span>
					</div>
				</div>
				
				<!-- 단말기 테이블 -->
				<div id="trainDiv"style="width: 100%;height: 100%;" >
					<div class="lte-div">
						<div id="trainNum">
							<table id="trainTb" class="lte-table">
								<tbody id="lteTbd"></tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="tilte" style="width: 100%;display: flex;align-items: center;">
					<span style="font-size: 18px;font-weight: bold;color: #fff;margin-right:10px;">최신 데이터 수신시각 : </span>
					<span id="nowDt" style="font-size: 18px;font-weight: bold;color: #fff;"> 1234</span>
				</div>
			</div>
		</div>
	</div>	
</body>

</html>