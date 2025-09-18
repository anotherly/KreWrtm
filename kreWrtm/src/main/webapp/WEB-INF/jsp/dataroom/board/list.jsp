<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>단말장치(LTE-R) 관리 WEB 시스템</title>
<jsp:include page="../../cmn/top.jsp" flush="false" />
</head>

<script>
	var iidx; 
	var selectlang;
	var updUrl="/dataroom/board/update.do";
	var delUrl="/dataroom/board/delete.ajax";
	var delbak="/dataroom/board/list.do";	
	
	$(document).ready(function(){	
		/* ▼ 데이터 테이블 관련 */
		//테이블 기본설정 세팅
		dtTbSetting();
		iidx = 3;

		var colCnt=0;
		var idxTb =0;
		
		$("#datetimepicker1").find("input").prop('disabled', true);
		$("#datetimepicker2").find("input").prop('disabled', true);
		
		var tb2=$("#tableList").DataTable({
			ajax : {
                "url":"/dataroom/board/list.ajax",
                "type":"POST",
                "dataType": "json",
            },  
             columns: [
            	 {
             		data:   "fileId",
 	            	"render": function (data, type, row, meta) {
                         return '<input type="checkbox" id="chk" name="chk" value="'+data+'">';
 	                },
                 },
                {data:"fileTitle"},
                {data:"writerName"},
                {data:"regDt"}
            ],
            "lengthMenu": [ [5, 10, 20], [5, 10, 20] ],
            "pageLength": 10,
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
		
		//체크박스 클릭 시 이벤트
		$("#tableList").on("click", 'input:checkbox', function() {
			chkBoxFunc(this);
		});
		
		//마우스 올릴시 
		$("#tableList").on("mouseenter", "tbody tr", function() {
			$(this).addClass('active');
		});
		
		//마우스 내릴시
		$("#tableList").on("mouseleave", "tbody tr", function() {
			$(this).removeClass('active');
		});
		
		//체크박스영역 제외 마우스 올릴시 포인터로
		$("#tableList").on("mouseleave", "tbody td:not(':first-child')", function(){
			$(this).css('cursor','pointer');
		});
		
		//페이지 이동이나 열 개수 변경시 전체체크박스 관련 이벤트
		$('#tableList').on('draw.dt', function(){
			//인덱스 번호 재설정
			$('#tableList input:checkbox[name="chk"]').each(function(i,list) {
				$(this).attr("id","chk"+i)
			});
			
			//행개수에 따라 수정삭제버튼 생성여부
			//행 개수 0개일때
			if($('input:checkbox[name="chk"]').length !=0 && typeof $('input:checkbox[name="chk"]').length !== "undefined"){
				/* if(typeof $("#btnUpdate").val()==="undefined"){
					$("#btnIns").append("<input type='button' id='btnUpdate' class='btn btn_primary' value='수정' onclick='tbUpdate(this,updUrl)'>");
				} */
				if(typeof $("#btnDelete").val()==="undefined"){
					$("#btnIns").append("<input type='button' id='btnDelete' class='btn btn_primary' value='삭제' onclick='tbDelete(this,delUrl,delbak)'>");
				}
			}else{
				if(typeof $("#btnUpdate").val()==="undefined"){
					$("#btnUpdate").remove();
				}
				if(typeof $("#btnDelete").val()==="undefined"){
					$("#btnDelete").remove();
				}
			}
			
			if($('input:checkbox[name="chk"]:checked').length==$("tbody tr").length){
	    		$("#chkAll").prop("checked", true);
	    	}else{
	    		$("#chkAll").prop("checked", false);
	    	}
		});
		
		
		/* ▼ 날짜 관련 설정 */	
		// DatetimePicker (등록일자)
		var toDate = new Date();
		 $('#datetimepicker1').datetimepicker({
			 format:"YYYY-MM-DD" ,
			 defaultDate:moment().subtract(1, 'months'),
			 maxDate : moment()
		});
		
		$('#datetimepicker2').datetimepicker({
			 format:"YYYY-MM-DD",
			 defaultDate:moment()
			 ,maxDate : moment()
		});
	
		// 날짜 선택 여부
		$("#dateChk").on("click",function(){
			if($(this).is(':checked')){
				$("#datetimepicker1").find("input").prop('disabled', false);
				$("#datetimepicker2").find("input").prop('disabled', false);
			}else{
				$("#datetimepicker1").find("input").prop('disabled', true);
				$("#datetimepicker2").find("input").prop('disabled', true);
			}
		});
		
		//등록 화면 조회
		$("#btnInsert").click(function() {
			location.href="/dataroom/board/insert.do";
		});
		
		//상세 화면 조회
		$("#tableList").on("click", "tbody td:not(:first-child)", function () {
		    var tagId = $(this).parent().children().first().children().first().val();
		    $(this).attr('id');

		    window.location = "/dataroom/board/detail.do?fileId=" + tagId;
		});

		
	});
	
	/* 검색 함수 */
	 function search(){
		 let frm = $("#searchFrm").serialize();
		 var tagUrl="/dataroom/board/list.ajax";
		 
		 var sDate = $('#sDate').val();
		 var eDate = $('#eDate').val();
		 
		 if ($('#dateChk').is(':checked')) {
			 var searchChk = compareSE(sDate,eDate);
			 if(!searchChk) {
				 return false;
			 }
				 
		 }

		 tbSearch("tableList",tagUrl,frm);
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
			<div id="work" class="work-wrap list_page">
				<div class="ctn_tbl_header">
					<div class="ttl_ctn">게시판</div>
				</div>
                <!-- search_box Start -->
                <div class="search_box">
                	<form id=searchFrm name="searchFrm" class="search_form" method="post" enctype="multipart/form-data">
                        <div class="form-group" >
                            <label for="sch_text_01" class="form-control-label">제목</label>
                            <input type="text" id="fileTitle" name="fileTitle" placeholder="검색어를 입력하세요." class="form-control">
                        </div>  
                        <div class="form-group" >
                      
                        </div>   
                        <div class="form-group" >

                        </div>
                        <div class="form-group" >
                            <label for="sch_text_01" class="form-control-label">작성자</label>
                            <input type="text" id="writerName" name="writerName" placeholder="검색어를 입력하세요." class="form-control">
                        </div>      
                                       
                        <div class="form-group" >
							<input type="checkbox" id="dateChk" name="dateChk" value="">
                            <label for="dateChk" class="form-control-label">                           	
                            	등록일
                            </label>
                            	<div class='input-group date' id='datetimepicker1'>
									<input type='text' class="form-cont" name="sDate" id="sDate" required/>
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
								 ~ 
								<div class='input-group date' id='datetimepicker2'>
									<input type="text" class="form-cont" id="eDate" name="eDate"  required/>
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
                        </div>
                    </form>
                    <div class="search_btn" style="position: absolute;right: 98px;top: 42px;">
                        <button class="btn btn_sch btn_primary" onclick="search()"><i class="ico_sch"></i>조회</button>
                    </div>
                </div>
                <!-- search_box End -->

	            <!-- grid_box Start -->
				<div class="datatable-list-01">
					<div class="page-description">
						<div class="rows">
							<table id="tableList" class="table table-bordered" style="width: 100%;">
								<thead>
									<tr>
										<th><input type="checkbox" id="chkAll" class="chk"></th>
										<th>제목</th>
										<th>작성자</th>
										<th>작성일</th>
									</tr>
								</thead>
							</table>
						</div>
					</div>
					
					<div id ="btnDiv" class="btn_box" style="display: flex;flex-direction: row-reverse;float:right;">
						<div id="btnIns" style="display: flex;justify-content: space-around;width: 230px;">
							<input type='button' class="btn btn_primary" id='btnInsert' value='등록'>
						</div>
					</div>
				</div>
	               <!-- grid_box End -->
			</div>	
			<!-- work End -->
		</div>
		<!-- contents End ------------------>
	</div>
	<!-- container End ------------------>
</body>
</html>