<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>단말장치(LTE-R) 관리 WEB 시스템</title>
	<meta charset="UTF-8">
    <jsp:include page="../cmn/top.jsp" flush="false" />
<script>
/* 	var teamCode='';
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
    }); */
    
    
    
    $(document).ready(function(){
    	
    	dtTbSetting();
    	var tb2=$("#tableList").DataTable({
			ajax : {
                "url":"/main/Datalist.ajax",
                "type":"POST",
                "dataType": "json",
            },  
             columns: [
            	{data:"companyName"},
                {data:"firmUse"},
                {data:"etc"}
            ],
            lengthChange: false, 
            "pageLength": 5,
            pagingType : "full_numbers",
            columnDefs: [ 
            	{ orderable: false, targets: [0] }
            	,{className: "dt-center",targets: "_all"} 
            ],
            select: {
                style:    'multi',
                selector: 'td:first-child'
            },
            responsive: true
           ,language : lang_kor ,
           dom: 'lrtip'
		});
    	
    	
    	
    	
        // 차트 생성
        var chart = c3.generate({
            bindto: '.ring_chart_div',
            data: {
                columns: [
                    ['에스트레픽', 0.5],  
                    ['케이원', 3.9],  
                    ['회명정보통신', 95.4] 
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
							<input type='button' class="btn btn_primary" id='btnInsert' value='다운로드'>
						</div>
					</div>
					<div class="page-description">
						<div class="rows">
							<table id="tableList" class="table table-bordered" style="width: 100%;">
								<thead>
									<tr>
										<th>회사명</th>
										<th>사용량(MB)</th>
										<th>비고</th>
									</tr>
								</thead>
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