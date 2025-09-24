//ID 검사 (영문 소문자+숫자, 6~20자리)
function checkId(that) {
  let val = $(that).val();
  // 허용 문자 이외 제거
  val = val.replace(/[^a-z0-9]/g, "");
  // 길이 제한 (20자)
  if (val.length > 20) {
    val = val.substring(0, 20);
  }
  $(that).val(val);
}

//비밀번호 검사 (영문+숫자+특수문자 최소 1개씩 포함, 6~20자리)
function checkPw(that) {
	  let val = $(that).val();
	  // 허용 문자 이외 제거
	  val = val.replace(/[^A-Za-z0-9~!@#$%^&*()_+|\[\]]/g, "");
	  // 길이 제한 (20자)
	  if (val.length > 20) {
	    val = val.substring(0, 20);
	  }
	  $(that).val(val);
}

//ID 검사 함수 (영문 소문자 반드시 포함, 숫자는 선택, 6~20자리)
// ^ 시작 ~ $ 끝
// (?=.*[a-z]) → 소문자 반드시 1개 이상
// [a-z0-9]{6,20} → 허용 문자로만 6~20자리
function validateId(id) {
    const regex = /^(?=.*[a-z])[a-z0-9]{6,20}$/;
    return regex.test(id);
}

// 비밀번호 검사 함수 
// 조건: 6~20자리, 영문+숫자+특수문자 최소 1개씩 포함
// 허용 특수문자: ~!@#$%^&*()_+|[]
function validatePassword(password) {
    const regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[~!@#$%^&*()_+|\[\]])[A-Za-z\d~!@#$%^&*()_+|\[\]]{6,20}$/;
    return regex.test(password);
}

/************************************************************************
함수명 : boardWriteCheck
설 명 : 입력정보 null 체크
인 자 : form
사용법 : 로그인 회원가입, 등록 등의 입력정보 체크시 사용
작성일 : 2020-07-30
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.07.30   정다빈       최초작성
************************************************************************/
function boardWriteCheck(form) {
    console.log("사용자정보 저장 시 유효성검사");
    
    // form 안의 input 요소만 가져오기
    var inputs = $(form).find("input");

    for (var i = 0; i < inputs.length; i++) {
        var el = inputs[i];

        //  필수값 체크 (class="input_base_require")
        if ($(el).hasClass("input_base_require")) {
            if ($(el).val() == null || $(el).val().trim() === "") {
                alert("필수 항목을 기재해 주세요");
                $(el).focus();
                return false;
            }
        }

        //  ID 검사
        if (el.name === 'userId') {
            if (!validateId(el.value)) {
                alert("ID 형식이 올바르지 않습니다.");
                el.focus();
                return false;
            }
        }

        // 비밀번호 검사
        if (el.name === 'userPw' && el.value.length > 0) {
            if (!validatePassword(el.value)) {
                alert("비밀번호 형식이 올바르지 않습니다.");
                el.focus();
                return false;
            }
        }
    }
    //  비밀번호 확인 검사
    if ($("#userPw").val() !== $("#userPw2").val()) {
        alert("비밀번호가 서로 일치하지 않습니다.");
        $("#userPw2").focus();
        return false;
    }
    return true;
}

/************************************************************************
함수명 : valComCode
설 명 : 회사코드 영문대문자 4자리만 허용
인 자 : 이벤트
사용법 : 
작성일 : 2025-08-25
작성자 : 솔루션디자인팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2025.08.25   정다빈       최초작성
************************************************************************/
function valComCode(e){
    const input = e.target;
    let val = input.value.toUpperCase();
    val=val.replace(/[^A-Z]/g,'');
    if(val.length>4){
    	val=val.substring(0,4);
    }
    input.value=val;
}


/************************************************************************
함수명 : removeChar
설 명 : 불필요 문자열 제거
인 자 : 
사용법 : 
작성일 : 2020-08-25
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.08.25   정다빈       최초작성
************************************************************************/
function removeChar(event) {
    event = event || window.event;
    var keyID = (event.which) ? event.which : event.keyCode;
    if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ){
    	return;
    }else{
    	event.target.value = event.target.value.replace(/[^0-9]/g, "");
    }
}

/************************************************************************
함수명 : onlyNumber
설 명 : 숫자만 입력가능하게 제한, 범위 제한
인 자 : 
사용법 : 
작성일 : 2020-09-11
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.08.25   정다빈       최초작성
 ************************************************************************/
function onlyNumber(event,that,min,max) {
	//console.log(event+" "+that+" "+min+" "+max);
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ){
		//console.log("키코드 해당 : "+event.target.value+" "+$(that).val());
		return;
	}else{
		//console.log("키코드 해당없음1 : "+event.target.value+" "+$(that).val());
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
		//console.log("키코드 해당없음 2: "+event.target.value+" "+$(that).val());
	}
	if(parseInt($(that).val())<min || parseInt($(that).val())>max){
		//console.log("값 초과1 : "+event.target.value+" "+$(that).val());
		event.target.value = "";
		//console.log("값 초과2 : "+event.target.value+" "+$(that).val());
	}else{
		console.log("값 초과 안함 : "+event.target.value+" "+$(that).val());
		return;
	}
}

/************************************************************************
함수명 : telChk
설 명 : 전화번호 체크
인 자 : 
사용법 : 
작성일 : 2020-08-25
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.08.25   정다빈       최초작성
************************************************************************/
/**
 * 전화번호 자동 하이픈 처리 함수
 * @param {HTMLInputElement} input - 이벤트가 발생한 input
 * @param {string} type - 'mobile' 또는 'tel'
 *    - 'volte' → 010-1234-5678 (3-4-4)
 *    - 'default'    → 02-1234-5678 또는 031-1234-5678 (2or3-4-4)
 */
function formatPhoneAuto(input,type) {
	  let val = input.value.replace(/[^0-9]/g, ""); // 숫자만
	  // 최대 11자리 제한
	  if (val.length > 11) val = val.substring(0, 11);
	  // 휴대폰 번호 (010, 011, 016, 017, 018, 019)
	  if (/^01[016789]/.test(val)) {
	    if (val.length > 7) {
	      val = val.replace(/(\d{3})(\d{3,4})(\d{1,4})/, "$1-$2-$3");
	    } else if (val.length > 3) {
	      val = val.replace(/(\d{3})(\d{1,4})/, "$1-$2");
	    }
	  }
	  // 서울 02
	  // 향후 딴데서 가져다 쓸려면 volte의 경우는 빼야함
	  else if (/^02/.test(val) && type!="volte" ) {
	    if (val.length === 9) { // 02-123-4567
	      val = val.replace(/(\d{2})(\d{3})(\d{4})/, "$1-$2-$3");
	    } else if (val.length === 10) { // 02-1234-5678
	      val = val.replace(/(\d{2})(\d{4})(\d{4})/, "$1-$2-$3");
	    } else if (val.length > 2) {
	      val = val.replace(/(\d{2})(\d{1,4})/, "$1-$2");
	    }
	  }
	  // 나머지 지역번호 (3자리)
	  else if (/^\d{3}/.test(val)) {
	    if (val.length === 10) { // 031-123-4567
	      val = val.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
	    } else if (val.length === 11) { // 031-1234-5678
	      val = val.replace(/(\d{3})(\d{4})(\d{4})/, "$1-$2-$3");
	    } else if (val.length > 3) {
	      val = val.replace(/(\d{3})(\d{1,4})/, "$1-$2");
	    }
	  }else{
		  console.log("비식별 코드");
	  }
	  input.value = val;
}
/************************************************************************
함수명 : spaceChk
설 명 : 공백 및 특수문자를 입력방지해주는 함수(영문,숫자 입력 가능)
인 자 : 
사용법 : 
작성일 : 2020-08-25
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.08.25   정다빈       최초작성
************************************************************************/
function spaceChk(obj){//공백입력방지
	var str_space = /\s/; //공백체크변수선언
	
	//특수문자 정규식
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	
	if (str_space.exec(obj.value)){ //공백체크
        obj.focus();
        obj.value = obj.value.replace(' ',''); // 공백제거
        return false;	
	}
	//패스워드,시험코드 제외 특수문자 입력 불가
	if(!(obj.name=="userPw" || obj.name == "userPw2")){
		if(regExp.test(obj.value)){
			obj.focus();
	        obj.value = obj.value.replace(obj.value,''); // 공백제거
	        return false;
		}
	}
	//이름,직급,부서, 회사명의 경우 제외하고 한글입력 불가능
	if(!(obj.name == "userName" || obj.name == "userRank"|| obj.name == "userDept")){
		//좌우 방향키, 백스페이스, 딜리트, 탭키에 대한 예외
		if(event.keyCode == 8  || event.keyCode == 9 
		|| event.keyCode == 37 || event.keyCode == 39){
			return false;
		}
		obj.value=obj.value.replace(/[ㄱ-ㅎㅏ-ㅡ가-핳]/g,'');
	}
	
}

/*
 * 비밀번호 관련 정규식 
 * */
function pwChkInput(obj){
	//특수문자 정규식
	var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi;
	if (str_space.exec(obj.value)){ //공백체크
        obj.focus();
        obj.value = obj.value.replace(' ',''); // 공백제거
        return false;	
	}
}


/************************************************************************
함수명 : schChkKey
설 명 : 검색 값 유효성 검사
인 자 : 
사용법 : 
작성일 : 2020-08-30
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2020.08.30   정다빈       최초작성
 ************************************************************************/
function schChkKey(that,schFlag){
	console.log("id조회");
	var sndUrl='';
	var dat;
	//키워드가 무엇인지 판별
	var schId= $(that).attr("name").split("_")[1];
	//텍스트에 값을 입력 안했다면
	if(schId!="empCode" && $(that).parent().children().first().val()==""){
		$(that).parent().parent().children().last().css("color","red");
		$(that).parent().parent().children().last().text("값을 입력해주세요");
	}else{
		//검색버튼이 2개이상일때는 어디로 보낼지 값이 무엇인지 분기처리
		if(schId=="userId"){
			sndUrl="/user/findUserId.ajax";
			dat={"userId":$(that).parent().children().first().val()};
			
			var schData=ajaxMethod(sndUrl, dat);
			//id일 경우는 값이 없을때 사용가능하고 시험코드는 값이 있을때 사용가능함
			if(schData == "" || typeof schData.data === "undefined"){//db에 값 미존재
				$(that).parent().parent().children().last().css("color","blue");
				$(that).parent().parent().children().last().text("사용 가능한 id입니다.");
				schFlag=true;
			}else{//db에 값 존재
				$(that).parent().parent().children().last().css("color","red");
				$(that).parent().parent().children().last().text("이미 사용중인 id입니다.");
				schFlag=false;
			}
		}
	}
	return schFlag;
}
