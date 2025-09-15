<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>단말장치(LTE-R) 관리 WEB 시스템</title>
	<meta charset="UTF-8">
    <jsp:include page="../cmn/top.jsp" flush="false" />
<style>

table.dataTable tbody tr{
	background-color:black;
	color:#fff;
}
#tableList tbody tr{
	border-bottom:1px solid darkgray;
}
.dataTables_wrapper .dataTables_length
, .dataTables_wrapper .dataTables_filter
, .dataTables_wrapper .dataTables_info
, .dataTables_wrapper .dataTables_processing
, .dataTables_wrapper .dataTables_paginate{
	color:#fff;
}
.dataTables_length select{
	background-color:black;
}

#sDate{
	background: black;
    color: #fff;
}

</style>
<script>
	$(document).ready(function(){
		var now = new Date();
		var yesterday = new Date(now.setDate(now.getDate() - 1));	
		console.log("chart 진입");
		//$("#container_chart").hide();
		var userAuth='${login.userAuth}';
		if(userAuth==0){
			$("#chtImg").load("/stat/mainAdminChart.do");
		}else{
			$("#chtImg").load("/stat/mainUserChart.do");
		}
		//데이트타임피커
		 $('#datetimepicker1').datetimepicker({
			 format:"YYYY-MM-DD" ,
			 defaultDate:moment().subtract(1, 'days'),
			 maxDate : moment()
		}).on('dp.change', function (e) {
			$("#chtImg").load("/stat/mainAdminChart.do");
			tbSearch("tableList","/stat/list.ajax",{"keyDate":$("#sDate").val(),"keyType":typeId});
		});
		
		console.log("단말기 화면 진입1");
		//테이블 기본설정 세팅
		dtTbSetting();
		iidx = 3;
		console.log("단말기 화면 진입2");
		var colCnt=0;
		var idxTb =0;
		
		var tb2=$("#tableList").DataTable({
			ajax : {
                "url":"/stat/list.ajax",
                "type":"POST",
                "dataType": "json",
            },  
            columns: [
                {
            		data:   "lteRUsed",
                },
                {
            		data:   "lteRIp",
                	"render": function (data, type, row, meta) {
                        //console.log(data);
                        return data;
                    }
                },
                {data:"rssi"},
                {data:"rsrp"},
                {data:"rsrq"},
                {data:"memCritVal"},
                {data:"lteRComUpVal"},
                {data:"lteRComDnVal"},
                {data:"failureRegYdt"},
                /* {data:"failbackYdt"}, */
            ],
            "lengthMenu": [ [5, 10, 20], [5, 10, 20] ],
            "pageLength": 5,
            pagingType : "full_numbers",
            columnDefs: [ 
            	{ orderable: false, targets: [0] }//특정 열(인덱스번호)에 대한 정렬 비활성화
            	,{className: "dt-center",targets: "_all"} 
            ],
            select: {
                style:    'multi',
                selector: 'td:first-child'
            },
            //order: [[ 9, 'desc' ]]
            responsive: true
           ,language : lang_kor // //or lang_eng
		});
		$("#tableList_filter").attr("hidden", "hidden");
		
		//체크박스영역 제외 마우스 올릴시 포인터로
		$("#tableList").on("mouseleave", "tbody td:not(':first-child')", function(){
			$(this).css('cursor','pointer');
		});
		
		//페이지 이동이나 열 개수 변경시 전체체크박스 관련 이벤트
		$('#tableList').on('draw.dt', function(){
			//console.log("데이터테이블 값 변경");
			//인덱스 번호 재설정
			$('#tableList input:checkbox[name="chk"]').each(function(i,list) {
				$(this).attr("id","chk"+i);
			});
		});

		$("#btnDownload").click(function() {
			console.log("다운로드 버튼 클릭");
			//엑셀 다운로드 후 언로드 방지
			cssNonChart();
			c3Title="DAY";
			c3TagId="_("+$("#sDate").val()+")";
			$("#title_val0").val($("#chart_title0").text());
			$("#title_val1").val($("#chart_title1").text());
			$("#title_val2").val($("#chart_title2").text());
			
			exportChartToPng('chtImg');
			//rkFlag = true;
			console.log("다운로드 버튼 클릭 완료");
		});
	});
	
	
</script>
</head>
		<!-- contents Start ------------------>
		<div id="containerAll" class="containerAll" style="flex-direction: column;">
			<!-- 내용 부분 -->
			<!-- <div id="container_chart" class="container_b"></div> -->
			
			<div id="chtImg" class="container_b" style="width: 100%;"></div>
			<!-- 우측 단말기 테이블 전체-->
			<div id="container_b" class="container_b"style="padding-left:37px;width: 100%;">
				<div style="width:100%;display:flex;margin-bottom:10px;">
				</div>
				<!-- 팀별 선택 현황 -->
				
				<!-- 단말기 테이블 -->
				<div style="display: flex;width: 100%;height: 50px;flex-direction: row;align-items: center;justify-content: space-between;margin-bottom: 10px;">
					<h3 class="chart-title">단말기별 일일 평균 수치값</h3>
					<!-- 엑셀 다운로드 -->
					<div style="display: flex;justify-content: space-between;width: 350px;align-items: center;">
						<div class='input-group date' id='datetimepicker1'>
							<input type='text' class="form-cont" name="sDate" id="sDate" required/>
							<span class="input-group-addon">
								<span class="glyphicon glyphicon-calendar"></span>
							</span>
						</div>
							
						<div id="btnIns" style="display: flex;justify-content: space-around;">
							<input type="button" class="btn btn_primary" id="btnDownload" value="다운로드">
						</div>
					</div>
				</div>
				<div id="trainDiv"style="width: 100%;height: 100%;" >
					<table id="tableList" class="table table-bordered" style="width: 100%;">
						<thead>
							<tr>
								<th>사용 용도</th>
								<th>WAN_IP</th>
								<th>RSSI</th>
								<th>RSRP</th>
								<th>RSRQ</th>
								<th>MEMORY</th>
								<th>UPLOAD</th>
								<th>DOWNLOAD</th>
								<th>장애발생시각</th>
								<!-- <th>장애복구시각</th> -->
							</tr>
						</thead>
					</table>
				</div>
			</div>
			
		</div>

</html>