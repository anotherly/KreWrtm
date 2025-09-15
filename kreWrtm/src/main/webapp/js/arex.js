var startNum=0;
var endNum=1;
var tbM;//tr 내부에 들어가는 td들
var tbCnt=0;//전체 들어가는 데이터 수 (42개 이하인데 변경예정)
var trCnt=1;//행 카운트

/////////////////////////////

var mok=0;//전체 데이터를 td 수로(7) 나눴을때 몫 (이건 최대 페이지 개수를 구할때 쓰임)
var namage=0;//나머지(마지막 행에서 빈칸 채울때 씀)
var maxPage=0;// 최대페이지 수 : 몫/6(한화면 행수)
var plusPage=0;// 몫/6의 나머지 -> 남은 행수를 계산해서 채울때 씀

/////////////////////////////

//차트화면 우측 단말기테이블
function trainOne(alData){
	console.log("차트화면 우측 단말기테이블");
	$("#lteTbd").empty();
	//전역변수 초기화
	tbM="";
	trCnt=1;
	tbCnt=0;
	
	startNum=0;
	endNum=1;
	
	mok=Math.floor(alData.length/7,0);
	namage=alData.length%7;
	maxPage=Math.floor(mok/6,0);
	
	var oldName="";//팀이 변경되기 전 이전 팀
	var enterLine=1;//현재 td number
	var blankCnt=0;//페이지 안깨지기 위한 공백 카운트
	
	for (var i = 0; i < alData.length; i++) {
		var backName="";
		if(i==0){
			oldName=alData[i].teamName;
		}
		/*공백처리안함*/
		//배경 선택
		backName=selectBackgra(alData[i].teamName,alData[i].obsCount);
		//td 내부 만듬
		tbM+= tdCreate(alData[i].lteRIp,backName,alData[i].lteRUsed); 
		tbCnt++;
		//7열 초과시 줄바꿈
		if(parseInt((enterLine)%7)==0){
			var tbCont = "<tr id='tr"+trCnt+"'>"+tbM+"</tr>";
			$("#lteTbd").append(tbCont);	
			tbM="";
			trCnt++;
		}else{
			//데이터의 마지막
			if(i==alData.length-1){
				//행을 생성
				trCreate();
			}
		}	
		enterLine++;
		
	}
	//테이블 생성 완료후 해야할 것들
	plusPage=6-($("#lteTbd tr").length%6);
	
	hideTr(startNum*6,endNum*6);

}

//tr을 생성하고 행번호를 생성
function trCreate(){
	var trValue = "<tr id='tr"+trCnt+"'>"+tbM+"</tr>";
	$("#lteTbd").append(trValue);	
	tbM="";
	trCnt++;
}

//중간에 들어가는 td값을 채움
//tdid,tdCont,spanVal
function tdCreate(tdid,backName,spanVal){
	var funcTbCont="";
	//갱신전에 선택된 단말기였다면 선택배경 유지되도록
	if(chkTerId==tdid){
		funcTbCont=
			"<td id='"+tdid+"' class='selected'>"
			+"<div class='td-div'>"
				+"<div class='img-container'>"
					+"<div style=" 
						+"'background:url(../images/arex/"+backName+".png) no-repeat;" 
						+"background-size: contain;'>" 
					+"</div>"
				+"</div>"
				+"<span>"+spanVal+"</span>"
			+"</div>"
		+"</td>";
	}else{
		funcTbCont=
			"<td id='"+tdid+"'>"
			+"<div class='td-div'>"
				+"<div class='img-container'>"
					+"<div style=" 
						+"'background:url(../images/arex/"+backName+".png) no-repeat;" 
						+"background-size: contain;'>" 
					+"</div>"
				+"</div>"
				+"<span>"+spanVal+"</span>"
			+"</div>"
		+"</td>";
	}
	return funcTbCont;
}

//배경 선택
function selectBackgra(teamName,obsCount){
	var backgra='';
	//배경 선택가능
	if(teamName.indexOf('전기') != -1){
		backgra="electric";
	}else if(teamName.indexOf('시설') != -1){
		backgra="facility";
	}else if(teamName.indexOf('신호') != -1){
		backgra="signal";
	}else{
		backgra="lte_non";
	}
	
	//상태표기
	if(obsCount=='reset'){
		backgra=backgra+"_r";
	}else if(obsCount=='update'){
		backgra=backgra+"_u";
	}else if (obsCount=='f') {//데이터 없음
		backgra=backgra+"_f";
	}else if (obsCount=='obs') {//장애
		backgra=backgra+"_obs";
	}else if (obsCount=='weak'){
		backgra=backgra+"_weak"
	}else{
		backgra=backgra;
	}
	return backgra;
}

//페이징 처리를 위한 행 감춤
function hideTr(startPage,endPage){
	$("#lteTbd tr").each(function(i,list){
		//console.log("i : "+i+"	/	"+"list : "+list);
		if(i >= startPage && i < endPage){
			$(list).show();
		}else{
			$(list).hide();
		}
	});
}




/*//차트화면 우측 단말기테이블
function trainOne(alData){
	console.log("차트화면 우측 단말기테이블");
	preStatNum=startNum;
	
	//전역변수 초기화
	tbM="";
	trCnt=1;
	tbCnt=0;
	
	var oldName="";//팀이 변경되기 전 이전 팀
	var enterLine=1;//줄 바꿀지말지
	var blankCnt=0;//페이지 안깨지기 위한 공백 카운트
	
	for (var i = 0; i < alData.length; i++) {
		var backName="";
		if(i==0){
			oldName=alData[i].teamName;
		}
		공 to the 백
		//이전 데이터의 팀과 현재 팀이 다르다면 공백처리를 해야함
		if(oldName != alData[i].teamName){
			//다찰경우 제수(나누는 수 7)에서 나머지를 뺀만큼 공백임
			var cnt = 7-parseInt((enterLine-1)%7);
			for (var j = 0; j < cnt; j++) {
				//td안에 들어갈 값을 만듬
				tbM+= tdCreate('',backName,''); 
				tbCnt++;
				blankCnt++;
			}
			//행을 생성
			trCreate();
			//처리가 끝나면 갱신 기관으로 변경
			oldName=alData[i].teamName;
			enterLine=1;
		//이전 데이터의 팀과 현재 팀이 같다면 공백처리 안하고 그냥 만듬
		}else{
			//배경 선택
			backName=selectBackgra(alData[i].teamName,alData[i].obsCount);
			//td 내부 만듬
			tbM+= tdCreate(alData[i].lteRIp,backName,alData[i].lteRUsed); 
			tbCnt++;
			//7열 초과시 줄바꿈
			if(parseInt((enterLine)%7)==0){
				var tbCont = "<tr id='tr"+trCnt+"'>"+tbM+"</tr>";
				$("#lteTbd").append(tbCont);	
				tbM="";
				trCnt++;
			}else{
				//데이터의 마지막
				if(i==alData.length-1){
					//다찰경우 제수(나누는 수 7)에서 나머지를 뺀만큼 공백임
					var cnt = 7-parseInt((enterLine)%7);
					for (var j = 0; j < cnt; j++) {
						//td안에 들어갈 값을 만듬
						tbM+= tdCreate('','lte_non','');
					}
					//행을 생성
					trCreate();
				}
			}	
			enterLine++;
		}
		//42개가 가득 찼을 경우
		if(tbCnt==42){
			console.log("핸들링 전 preStatNum"+preStatNum+" ,startNum"+startNum+" ,endNum"+endNum);
			endNum=Number(alData[i].deviceCnt);
			i=alData.length-1;
			break;
		}else{
			//다음 페이지 처리를 위한변수
			if(alData.length-1==i){
				console.log("핸들링 전 preStatNum"+preStatNum+" ,startNum"+startNum+" ,endNum"+endNum);
				endNum=Number(alData[i].deviceCnt);
				startNum=Number(alData[i].deviceCnt);
			}
		}
	}
	console.log("테이블 로직 js에서 작업을 마치고 preStatNum"+preStatNum+" ,startNum"+startNum+" ,endNum"+endNum);
	//hideTr(0,6);
}*/
