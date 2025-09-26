<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../cmn/top.jsp" flush="false" />
</head>
<style>
	td {
		cursor : pointer;
	}
</style>
<script>
	var searchSendValue = '${searchVal}';

	$(document).ready(function() {
		
		console.log(searchSendValue);
		// 기본 검색어 셋팅
		$('#searchVal').val(searchSendValue);
	
		dtTbSetting();
	
		var tb2 = $("#tableList").DataTable({
			ajax: {
				"url": "/search/list.ajax?searchVal=" + searchSendValue,
				"type": "POST",
				"dataType": "json",
			},
			columns: [
				{ data: "version" },
				{
				    data: "deviceName",
				    render: function(data, type, row, meta) {
				        return '<span>' + data + '</span><input type="hidden" value="' + row.deviceId + '" id="deviceId" name="deviceId">';
				    }
				},  // 여기에 장치 아이디 input hidden 처리 해놓을 것
				{ data: "modelName" },
				{ data: "carNum" },
				{ data: "location" },
				{ data: "volteNum" },
				{ data: "keywords" }
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
	
		// 엔터키 입력 시 검색
		$('#searchVal').on('keydown', function(event) {
			if (event.key === 'Enter') {
				event.preventDefault();
				search();
			}
		});
		
		
		//상세 화면 조회
		$("#tableList").on("click","tr",function () {			
			var tagUrl = "/search/monitering.do";
		    var tagId = $(this).find("td:eq(1) input[type='hidden']").val(); // 장치명에 hidden 처리 된 deviceId 가져오기
		    
		    window.location = tagUrl + "?deviceId=" + tagId;  // 모니터링(상세)으로 이동
		});
		
		
	}); 

	function search() {
		console.log("검색");
		let frm = $("#searchFrm").serialize();
		var tagUrl = "/search/list.ajax";
	
		var searchVal = $('#searchVal').val();
	
		if (searchVal.length > 0 && searchVal.length < 2) {
			alert("검색어가 너무 짧습니다. 2글자 이상 입력해주세요.");
			return false;
		} else {
			tbSearch("tableList", tagUrl, frm);
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
			<div id="work" class="work-wrap list_page" style="justify-content : center; align-items : center;">
				<div class="ctn_tbl_header" style=" margin-top : -120px; justify-content: center; border-bottom: 2px solid #555555; padding-bottom: 15px; width: 180px;">
					<div class="ttl_ctn" style="font-size : 32px;">장치 관리</div>
				</div>
                <!-- search_box Start -->
                <div class="search_box" style=" margin-top: calc(10px + 0vh); background : none; box-shadow : none; margin-bottom:0;">
                	<form id=searchFrm name="searchFrm" class="search_form" method="post" enctype="multipart/form-data" style="justify-content : center;">
                            <input type="text" class="searchText" id="searchVal" name="searchVal" placeholder="차량번호, 제조사 등 검색어를 입력하세요.">
                    </form>
                     <div class="search_btn" style="position: absolute;right: 320px;">
                        <button class="btn btn_sch btn_primary" onclick="search()" style="width:auto; background : none; box-shadow : none;"><div class="ico_sch_search"></div></button>
                    </div>
                </div>
                <!-- search_box End --> 
                
                <div class="datatable-list-01">
					<div class="page-description">
						<div class="rows">
							<table id="tableList" class="table table-bordered" style="width: 100%;">
								<thead>
									<tr>
										<th>SW 버전</th>
										<th>장치명</th>
										<th>모델명</th>
										<th>차량 번호</th>
										<th>탑재 위치</th>
										<th>VoLTE 번호</th>
										<th>키워드</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
				</div>           
			</div>	

		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>