// 영문 소문자와 숫자 이외의 입력을 값이 변경되기 전에 차단
function blockInvalidIdInput(event) {
    // 삭제, 커서 이동 등은 허용
    if (event.data == null) {
        return true;
    }

    if (!/^[a-z0-9]+$/.test(event.data)) {
        event.preventDefault();
        return false;
    }

    return true;
}

// 붙여넣기 등 예외 상황에 대한 보조 검사
function checkId(input) {
    var value = input.value || "";

    if (/[^a-z0-9]/.test(value)) {
        input.value = input._lastValidId || "";
        return;
    }

    if (value.length > 12) {
        value = value.substring(0, 12);
        input.value = value;
    }

    input._lastValidId = value;
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

//ID 검사 함수 (영문 소문자 반드시 포함, 숫자는 선택, 6~12자리)
// ^ 시작 ~ $ 끝
// (?=.*[a-z]) → 소문자 반드시 1개 이상
// [a-z0-9]{6,12} → 허용 문자로만 6~12자리
function validateId(id) {
    const regex = /^(?=.*[a-z])[a-z0-9]{6,12}$/;
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
함수명 : phoneCellChk
설 명 : 전화번호 체크
인 자 : 
사용법 : 
작성일 : 2020-08-25
작성자 : 솔루션사업팀 정다빈
수정일        수정자       수정내용
----------- ------ -------------------
2025.08.25   정다빈       최초작성
************************************************************************/

function phoneCellChk(phone1,phone2) {
    var makeVal1 = $('input[name="'+phone1+'"]').val().trim();
    var makeVal2 = $('input[name="'+phone2+'"]').val().trim();

    if (!isValidPhoneNumber(makeVal1)) {
        console.log(phone1 + " 전화번호 형식 불일치");
        alert("연락처1 형식이 올바르지 않습니다.");
        $('input[name="'+phone1+'"]').focus();
        return false;
    }

    // 연락처2는 선택값이면 입력한 경우에만 검사
    if (makeVal2 !== "" && !isValidPhoneNumber(makeVal2)) {
        console.log(phone2 + " 전화번호 형식 불일치");
        alert("연락처2 형식이 올바르지 않습니다.");
        $('input[name="'+phone2+'"]').focus();
        return false;
    }

    return true;
}

/**
 * 허용 전화번호 형식을 공통으로 검사합니다.
 * - 휴대전화: 010/011/016/017/018/019 + 8자리
 * - 서울: 02 + 7~8자리
 * - 지역번호: 031~064의 실제 지역번호 + 7~8자리
 */
function isValidPhoneNumber(value) {
    var onlyNum = String(value || "").replace(/-/g, "");
    var reg = /^(01[016789]\d{8}|02\d{7,8}|0(31|32|33|41|42|43|44|51|52|53|54|55|61|62|63|64)\d{7,8})$/;
    return reg.test(onlyNum);
}

/**
 * 전화번호 자동 하이픈 처리 함수
 * @param {HTMLInputElement} input - 이벤트가 발생한 input
 * @param {string} type - 'mobile' 또는 'tel'
 *    - 'volte' → 010-1234-5678 (3-4-4)
 *    - 'default'    → 02-1234-5678 또는 031-1234-5678 (2or3-4-4)
 */
function formatPhoneAuto(input,type) {
    if (!input) return;

    // 한글 IME 조합 중에는 input 값을 변경하지 않습니다.
    if (input._phoneComposing) return;

    var originalValue = input.value || "";

    // 숫자와 자동 생성된 하이픈 이외 문자가 들어오면 입력 직전 정상값을 복원합니다.
    if (/[^0-9-]/.test(originalValue)) {
        input.value = input._phoneLastValidValue || "";
        restorePhoneCursor(input, input._phoneLastValidCursor);
        return;
    }

    var selectionStart = (typeof input.selectionStart === "number") ? input.selectionStart : originalValue.length;

    // 현재 커서 앞에 존재하는 숫자 개수를 기준으로 포맷 후 커서 위치를 복원합니다.
    // 이 방식은 중간 숫자 선택 후 덮어쓰기, 중간 삭제, 중간 삽입을 모두 처리합니다.
    var digitCursorIndex = countDigits(originalValue.substring(0, selectionStart));
    var digits = originalValue.replace(/[^0-9]/g, "");

    // 국내에서 허용한 전화번호 접두어가 아니면 직전 정상값을 유지합니다.
    if (!hasAllowedPhonePrefix(digits, type)) {
        input.value = input._phoneLastValidValue || "";
        restorePhoneCursor(input, input._phoneLastValidCursor);
        return;
    }

    // 최대 11자리 제한
    if (digits.length > 11) {
        digits = digits.substring(0, 11);
        if (digitCursorIndex > 11) digitCursorIndex = 11;
    }

    var formattedValue = formatPhoneDigits(digits, type);
    input.value = formattedValue;

    var nextCursor = findCursorPositionByDigitIndex(formattedValue, digitCursorIndex);
    try {
        input.setSelectionRange(nextCursor, nextCursor);
    } catch (e) {
        // 일부 구형 브라우저/비활성 input에서는 setSelectionRange가 실패할 수 있으므로 무시합니다.
    }

    input._phoneLastValidValue = formattedValue;
    input._phoneLastValidCursor = nextCursor;
}

function restorePhoneCursor(input, cursor) {
    var nextCursor = (typeof cursor === "number") ? cursor : (input.value || "").length;
    try {
        input.setSelectionRange(nextCursor, nextCursor);
    } catch (e) {
        // 일부 구형 브라우저에서는 setSelectionRange가 지원되지 않을 수 있습니다.
    }
}

/*
 * 기존 사용자 등록/수정 JSP에 연결된 함수명입니다.
 * 화면 파일 교체 순서와 관계없이 공통 전화번호 로직이 동작하도록 유지합니다.
 */
function beginUserPhoneComposition(input) {
    if (!input) return;
    input._phoneComposing = true;
    input._phoneValueBeforeComposition = input._phoneLastValidValue !== undefined
        ? input._phoneLastValidValue : (input.value || "");
    input._phoneCursorBeforeComposition = (typeof input.selectionStart === "number")
        ? input.selectionStart : input._phoneValueBeforeComposition.length;
}

function formatUserPhoneInput(input, type) {
    if (!input || input._phoneComposing) return;
    formatPhoneAuto(input, type);
}

function endUserPhoneComposition(input, type) {
    if (!input) return;
    input._phoneComposing = false;
    input.value = input._phoneValueBeforeComposition || input._phoneLastValidValue || "";
    restorePhoneCursor(input, input._phoneCursorBeforeComposition);
    formatPhoneAuto(input, type);
}

function hasAllowedPhonePrefix(digits, type) {
    digits = String(digits || "");
    if (digits === "") return true;
    if (digits.charAt(0) !== "0") return false;
    if (digits.length < 2) return true;

    // VoLTE 번호는 현재 정책상 013으로 시작하는 번호만 허용합니다.
    if (type === "volte") {
        if (digits.length === 1) return digits === "0";
        if (digits.length === 2) return digits === "01";
        return digits.indexOf("013") === 0;
    }

    // 서울 지역번호는 두 자리 접두어입니다.
    if (/^02/.test(digits)) return true;
    if (digits.length < 3) return digits.charAt(1) === "1" || /[3-6]/.test(digits.charAt(1));

    return /^(010|011|016|017|018|019|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)/.test(digits);
}

function isPhoneFormatInput(input) {
    if (!input || input.tagName !== "INPUT") return false;
    var oninput = input.getAttribute("oninput") || "";
    return oninput.indexOf("formatPhoneAuto") !== -1
        || oninput.indexOf("formatUserPhoneInput") !== -1
        || input.getAttribute("data-phone-format") === "Y";
}

function getPhoneFormatType(input) {
    var oninput = input.getAttribute("oninput") || "";
    return oninput.indexOf("'volte'") !== -1 || oninput.indexOf('"volte"') !== -1 ? "volte" : undefined;
}

/*
 * formatPhoneAuto()를 사용하는 모든 화면에 공통 적용합니다.
 * 잘못된 키·한글 조합·문자 붙여넣기를 값 변경 전에 차단하여 기존 번호를 보존합니다.
 */
(function bindCommonPhoneInputEvents() {
    if (window.__KRE_PHONE_INPUT_BIND_DONE) return;
    window.__KRE_PHONE_INPUT_BIND_DONE = true;

    document.addEventListener("focus", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        input._phoneLastValidValue = input.value || "";
        input._phoneLastValidCursor = (typeof input.selectionStart === "number") ? input.selectionStart : input._phoneLastValidValue.length;
    }, true);

    document.addEventListener("keydown", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input) || event.ctrlKey || event.metaKey || event.altKey) return;

        var key = event.key || "";
        var allowedControlKeys = ["Backspace", "Delete", "Tab", "Enter", "Escape", "ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Home", "End", "Shift", "Control", "Alt", "CapsLock"];
        if (/^F\d{1,2}$/.test(key)) return;
        if (/^\d$/.test(key) || allowedControlKeys.indexOf(key) !== -1) return;
        event.preventDefault();
    }, true);

    document.addEventListener("beforeinput", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        if (event.inputType && (event.inputType.indexOf("delete") === 0 || event.inputType.indexOf("history") === 0)) return;
        if (event.data !== null && event.data !== undefined && !/^\d+$/.test(event.data)) {
            event.preventDefault();
        }
    }, true);

    document.addEventListener("paste", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        var pastedText = event.clipboardData ? event.clipboardData.getData("text") : "";
        if (!/^\d+$/.test(pastedText)) event.preventDefault();
    }, true);

    document.addEventListener("drop", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        var droppedText = event.dataTransfer ? event.dataTransfer.getData("text") : "";
        if (!/^\d+$/.test(droppedText)) event.preventDefault();
    }, true);

    document.addEventListener("compositionstart", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        input._phoneComposing = true;
        input._phoneValueBeforeComposition = input._phoneLastValidValue !== undefined
            ? input._phoneLastValidValue : (input.value || "");
        input._phoneCursorBeforeComposition = (typeof input.selectionStart === "number")
            ? input.selectionStart : input._phoneValueBeforeComposition.length;
    }, true);

    document.addEventListener("compositionend", function(event) {
        var input = event.target;
        if (!isPhoneFormatInput(input)) return;
        input._phoneComposing = false;
        input.value = input._phoneValueBeforeComposition || "";
        restorePhoneCursor(input, input._phoneCursorBeforeComposition);
        formatPhoneAuto(input, getPhoneFormatType(input));
    }, true);
})();

function countDigits(str) {
    var match = String(str || "").match(/\d/g);
    return match ? match.length : 0;
}

function findCursorPositionByDigitIndex(formattedValue, digitIndex) {
    if (digitIndex <= 0) return 0;

    var digitCount = 0;
    for (var i = 0; i < formattedValue.length; i++) {
        if (/\d/.test(formattedValue.charAt(i))) {
            digitCount++;
            if (digitCount >= digitIndex) {
                return i + 1;
            }
        }
    }
    return formattedValue.length;
}

function formatPhoneDigits(val, type) {
    val = String(val || "");

    // 휴대폰 번호 (010, 011, 016, 017, 018, 019)
    if (/^01[016789]/.test(val)) {
        if (val.length > 7) {
            return val.replace(/(\d{3})(\d{3,4})(\d{1,4})/, "$1-$2-$3");
        } else if (val.length > 3) {
            return val.replace(/(\d{3})(\d{1,4})/, "$1-$2");
        }
        return val;
    }

    // 서울 02. VoLTE 번호는 지역번호 판단에서 제외합니다.
    if (/^02/.test(val) && type != "volte") {
        if (val.length === 9) {
            return val.replace(/(\d{2})(\d{3})(\d{4})/, "$1-$2-$3");
        } else if (val.length >= 10) {
            return val.replace(/(\d{2})(\d{4})(\d{1,4})/, "$1-$2-$3");
        } else if (val.length > 2) {
            return val.replace(/(\d{2})(\d{1,4})/, "$1-$2");
        }
        return val;
    }

    // 나머지 지역번호 또는 VoLTE 번호 (3자리-3/4자리-4자리)
    if (/^\d{3}/.test(val)) {
        if (val.length === 10) {
            return val.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
        } else if (val.length >= 11) {
            return val.replace(/(\d{3})(\d{4})(\d{1,4})/, "$1-$2-$3");
        } else if (val.length > 3) {
            return val.replace(/(\d{3})(\d{1,4})/, "$1-$2");
        }
        return val;
    }

    return val;
}

/**
 * VoLTE 번호 최종 검사 함수입니다.
 * - 현재 정책: 013으로 시작하는 11자리 숫자만 허용
 * - 화면에는 013-1234-5678 형태로 표시될 수 있으므로 하이픈은 제거 후 검사
 */
function isValidVolteNumber(value) {
    var onlyNum = String(value || "").replace(/[^0-9]/g, "");
    return /^013\d{8}$/.test(onlyNum);
}

/**
 * 차량번호 최종 검사 함수입니다.
 * - 숫자 6자리만 허용
 */
function validateCarNumber(value) {
    return /^\d{6}$/.test(String(value || ""));
}

/**
 * 숫자 전용 입력값을 정리하는 공통 함수입니다.
 * - 한글 IME 조합 중에는 값을 변경하지 않고, 조합 종료 시 조합 전 정상값으로 복원
 * - 영문/한글/특수문자 입력 또는 붙여넣기 시 기존 정상값 보존
 * - maxLength 인자가 있으면 해당 자리수까지만 허용
 */
function formatDigitsOnlyInput(input, maxLength) {
    if (!input) return;
    if (input._digitsComposing) return;

    var rawValue = input.value || "";
    var cursor = (typeof input.selectionStart === "number") ? input.selectionStart : rawValue.length;

    if (/[^0-9]/.test(rawValue)) {
        input.value = input._digitsLastValidValue || "";
        restoreDigitsCursor(input, input._digitsLastValidCursor);
        return;
    }

    if (maxLength && rawValue.length > maxLength) {
        rawValue = rawValue.substring(0, maxLength);
        input.value = rawValue;
        cursor = Math.min(cursor, maxLength);
    }

    input._digitsLastValidValue = input.value || "";
    input._digitsLastValidCursor = cursor;
}

function restoreDigitsCursor(input, cursor) {
    var nextCursor = (typeof cursor === "number") ? cursor : (input.value || "").length;
    try {
        input.setSelectionRange(nextCursor, nextCursor);
    } catch (e) {
        // 일부 구형 브라우저에서는 setSelectionRange가 지원되지 않을 수 있습니다.
    }
}

function isDigitsOnlyInput(input) {
    if (!input || input.tagName !== "INPUT") return false;
    return input.getAttribute("data-digits-only") === "Y"
        || input.getAttribute("data-input-rule") === "digits"
        || input.getAttribute("oninput") === "formatDigitsOnlyInput(this,6)"
        || input.getAttribute("oninput") === "formatDigitsOnlyInput(this, 6)";
}

function getDigitsMaxLength(input) {
    var dataMax = parseInt(input.getAttribute("data-digits-max"), 10);
    if (!isNaN(dataMax) && dataMax > 0) return dataMax;

    var attrMax = parseInt(input.getAttribute("maxlength"), 10);
    if (!isNaN(attrMax) && attrMax > 0) return attrMax;

    return null;
}

/*
 * 숫자 전용 input 공통 이벤트입니다.
 * validation.js가 중복 로드되어도 이벤트가 중복 등록되지 않도록 1회만 바인딩합니다.
 */
(function bindDigitsOnlyInputEvents() {
    if (window.__KRE_DIGITS_ONLY_BIND_DONE) return;
    window.__KRE_DIGITS_ONLY_BIND_DONE = true;

    document.addEventListener("focus", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        input._digitsLastValidValue = input.value || "";
        input._digitsLastValidCursor = (typeof input.selectionStart === "number") ? input.selectionStart : input._digitsLastValidValue.length;
    }, true);

    document.addEventListener("keydown", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input) || event.ctrlKey || event.metaKey || event.altKey) return;

        var key = event.key || "";
        var allowedControlKeys = ["Backspace", "Delete", "Tab", "Enter", "Escape", "ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown", "Home", "End", "Shift", "Control", "Alt", "CapsLock"];
        if (/^F\d{1,2}$/.test(key)) return;
        if (/^\d$/.test(key) || allowedControlKeys.indexOf(key) !== -1) return;
        event.preventDefault();
    }, true);

    document.addEventListener("beforeinput", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        if (event.inputType && (event.inputType.indexOf("delete") === 0 || event.inputType.indexOf("history") === 0)) return;
        if (event.data !== null && event.data !== undefined && !/^\d+$/.test(event.data)) {
            event.preventDefault();
        }
    }, true);

    document.addEventListener("paste", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        var pastedText = event.clipboardData ? event.clipboardData.getData("text") : "";
        if (!/^\d+$/.test(pastedText)) event.preventDefault();
    }, true);

    document.addEventListener("drop", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        var droppedText = event.dataTransfer ? event.dataTransfer.getData("text") : "";
        if (!/^\d+$/.test(droppedText)) event.preventDefault();
    }, true);

    document.addEventListener("compositionstart", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        input._digitsComposing = true;
        input._digitsValueBeforeComposition = input._digitsLastValidValue !== undefined ? input._digitsLastValidValue : (input.value || "");
        input._digitsCursorBeforeComposition = (typeof input.selectionStart === "number") ? input.selectionStart : input._digitsValueBeforeComposition.length;
    }, true);

    document.addEventListener("compositionend", function(event) {
        var input = event.target;
        if (!isDigitsOnlyInput(input)) return;
        input._digitsComposing = false;
        input.value = input._digitsValueBeforeComposition || "";
        restoreDigitsCursor(input, input._digitsCursorBeforeComposition);
        formatDigitsOnlyInput(input, getDigitsMaxLength(input));
    }, true);
})();

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
