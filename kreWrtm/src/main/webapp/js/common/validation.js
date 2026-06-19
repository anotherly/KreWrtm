/**
 * 사용자 ID 최종 형식 검사
 * - 영문 소문자와 숫자를 각각 1자 이상 포함
 * - 전체 길이 6~12자
 */
function validateId(id) {
    return /^(?=.*[a-z])(?=.*\d)[a-z0-9]{6,12}$/.test(String(id || ""));
}

/**
 * 비밀번호 최종 형식 검사
 * - 영문, 숫자, 허용 특수문자를 각각 1자 이상 포함
 * - 전체 길이 6~20자
 */
function validatePassword(password) {
    var regex = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[~!@#$%^&*()_+|\[\]])[A-Za-z\d~!@#$%^&*()_+|\[\]]{6,20}$/;
    return regex.test(String(password || ""));
}

/**
 * 사용자 등록/수정 폼 저장 전 최종 유효성 검사
 * - 필수 입력값, 신규 ID 형식, 비밀번호 형식과 일치 여부 확인
 * - 수정 화면의 hidden ID는 기존 데이터 호환을 위해 재검사하지 않음
 */
function boardWriteCheck(form) {
    console.log("사용자정보 저장 시 유효성검사");

    var inputs = $(form).find("input");
    for (var i = 0; i < inputs.length; i++) {
        var el = inputs[i];

        if ($(el).hasClass("input_base_require")) {
            if ($(el).val() == null || $(el).val().trim() === "") {
                alert("필수 항목을 기재해 주세요");
                $(el).focus();
                return false;
            }
        }

        if (el.name === "userId" && el.type !== "hidden" && !el.readOnly) {
            if (!validateId(el.value)) {
                alert("ID는 영문 소문자와 숫자를 조합하여 6~12자리로 입력해 주세요.");
                el.focus();
                return false;
            }
        }

        if (el.name === "userPw" && el.value.length > 0) {
            if (!validatePassword(el.value)) {
                alert("비밀번호 형식이 올바르지 않습니다.");
                el.focus();
                return false;
            }
        }
    }

    if ($("#userPw").val() !== $("#userPw2").val()) {
        alert("비밀번호가 서로 일치하지 않습니다.");
        $("#userPw2").focus();
        return false;
    }

    return true;
}

/**
 * 일반 전화번호 최종 형식 검사
 * - 휴대전화: 010/011/016/017/018/019-xxxx-xxxx
 * - 서울: 02-xxx(x)-xxxx
 * - 지역번호: 실제 국내 지역번호-xxx(x)-xxxx
 */
function isValidPhoneNumber(value) {
    var onlyNum = String(value || "").replace(/-/g, "");
    var regex = /^(01[016789]\d{8}|02\d{7,8}|0(31|32|33|41|42|43|44|51|52|53|54|55|61|62|63|64)\d{7,8})$/;
    return regex.test(onlyNum);
}

/* VoLTE 번호에서 허용하는 3자리 접두어 목록 */
var VOLTE_PREFIXES = [
    "010", "011", "016", "017", "018", "019",
    "031", "032", "033",
    "041", "042", "043", "044",
    "051", "052", "053", "054", "055",
    "061", "062", "063", "064"
];

/**
 * 장비 VoLTE 번호 최종 형식 검사
 * - 허용 접두어 3자리와 가입자 번호 8자리로 구성된 번호만 허용
 */
function isValidVolteNumber(value) {
    var onlyNum = String(value || "").replace(/-/g, "");
    return /^\d{11}$/.test(onlyNum)
        && VOLTE_PREFIXES.indexOf(onlyNum.substring(0, 3)) !== -1;
}

/**
 * 필수/선택 전화번호 2개를 저장 전에 검사
 * @param {string} phone1 첫 번째 필수 전화번호 input name
 * @param {string} phone2 두 번째 선택 전화번호 input name
 */
function phoneCellChk(phone1, phone2) {
    var $phone1 = $('input[name="' + phone1 + '"]');
    var $phone2 = $('input[name="' + phone2 + '"]');
    var value1 = $.trim($phone1.val());
    var value2 = $.trim($phone2.val());

    if (!isValidPhoneNumber(value1)) {
        alert("연락처1 형식이 올바르지 않습니다.");
        $phone1.focus();
        return false;
    }

    if (value2 !== "" && !isValidPhoneNumber(value2)) {
        alert("연락처2 형식이 올바르지 않습니다.");
        $phone2.focus();
        return false;
    }

    return true;
}

/**
 * 로그인 입력값의 공백/특수문자/한글 제거
 * 기존 로그인 화면에서 호출하므로 함수명과 동작을 유지함
 */
function spaceChk(obj) {
    var strSpace = /\s/;
    var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\('\"]/gi;

    if (strSpace.exec(obj.value)) {
        obj.focus();
        obj.value = obj.value.replace(" ", "");
        return false;
    }

    if (!(obj.name === "userPw" || obj.name === "userPw2")) {
        if (regExp.test(obj.value)) {
            obj.focus();
            obj.value = "";
            return false;
        }
    }

    if (!(obj.name === "userName" || obj.name === "userRank" || obj.name === "userDept")) {
        var currentEvent = window.event;
        if (currentEvent && (currentEvent.keyCode === 8 || currentEvent.keyCode === 9
            || currentEvent.keyCode === 37 || currentEvent.keyCode === 39)) {
            return false;
        }
        obj.value = obj.value.replace(/[ㄱ-ㅎㅏ-ㅡ가-핳]/g, "");
    }
}

/**
 * 공통 실시간 입력 유효성 검사 모듈
 *
 * JSP에는 data-input-rule 속성만 지정하고 이벤트 처리는 이 모듈에서 일괄 수행합니다.
 * - user-id: 영문 소문자와 숫자만 허용
 * - password: 영문, 숫자, 지정 특수문자만 허용
 * - company-code: 영문만 허용하고 대문자로 변환
 * - phone: 국내 일반 전화번호 형식으로 자동 하이픈 처리
 * - volte: 허용된 3자리 접두어의 xxx-xxxx-xxxx 형식으로 자동 하이픈 처리
 *
 * 한글 IME 조합 중에는 값을 변경하지 않고 compositionend에서 조합 전 정상값을
 * 복원하므로, 한글 입력 때문에 기존 영문/숫자가 사라지는 현상을 방지합니다.
 */
(function (window, document) {
    "use strict";

    if (window.KreInputValidationInitialized) return;
    window.KreInputValidationInitialized = true;

    var RULE_USER_ID = "user-id";
    var RULE_PASSWORD = "password";
    var RULE_COMPANY_CODE = "company-code";
    var RULE_PHONE = "phone";
    var RULE_VOLTE = "volte";

    /** input에 지정된 공통 입력 규칙명을 반환합니다. */
    function getRule(input) {
        if (!input || input.tagName !== "INPUT") return "";
        return input.getAttribute("data-input-rule") || "";
    }

    /** 규칙별로 사용자가 직접 입력할 수 있는 문자인지 검사합니다. */
    function isAllowedInputText(rule, text) {
        if (text == null || text === "") return true;
        if (rule === RULE_USER_ID) return /^[a-z0-9]+$/.test(text);
        if (rule === RULE_PASSWORD) return /^[A-Za-z0-9~!@#$%^&*()_+|\[\]]+$/.test(text);
        if (rule === RULE_COMPANY_CODE) return /^[A-Za-z]+$/.test(text);
        if (rule === RULE_PHONE || rule === RULE_VOLTE) return /^\d+$/.test(text);
        return true;
    }

    /** input의 현재 값과 커서 위치를 마지막 정상 상태로 저장합니다. */
    function saveState(input) {
        input._validationLastValue = input.value || "";
        input._validationLastStart = typeof input.selectionStart === "number"
            ? input.selectionStart : input._validationLastValue.length;
        input._validationLastEnd = typeof input.selectionEnd === "number"
            ? input.selectionEnd : input._validationLastStart;
    }

    /** 잘못된 입력 발생 시 마지막 정상값과 커서 위치를 복원합니다. */
    function restoreState(input) {
        input.value = input._validationLastValue || "";
        setSelection(input, input._validationLastStart, input._validationLastEnd);
    }

    /** 브라우저가 지원하는 경우 input 커서/선택 위치를 복원합니다. */
    function setSelection(input, start, end) {
        var nextStart = typeof start === "number" ? start : (input.value || "").length;
        var nextEnd = typeof end === "number" ? end : nextStart;
        try {
            input.setSelectionRange(nextStart, nextEnd);
        } catch (ignore) {
            // 비활성 또는 구형 브라우저에서는 커서 복원을 생략합니다.
        }
    }

    /** 문자열에서 숫자 개수를 계산합니다. */
    function countDigits(value) {
        var matched = String(value || "").match(/\d/g);
        return matched ? matched.length : 0;
    }

    /** 포맷된 전화번호에서 지정한 숫자 순번 다음의 커서 위치를 계산합니다. */
    function findPhoneCursor(formattedValue, digitIndex) {
        if (digitIndex <= 0) return 0;
        var digitCount = 0;
        for (var i = 0; i < formattedValue.length; i++) {
            if (/\d/.test(formattedValue.charAt(i))) {
                digitCount++;
                if (digitCount >= digitIndex) return i + 1;
            }
        }
        return formattedValue.length;
    }

    /** 일반 전화번호가 입력 중 허용 가능한 국내 접두어인지 검사합니다. */
    function isAllowedPhonePrefix(digits) {
        if (digits === "") return true;
        if (digits.charAt(0) !== "0") return false;
        if (digits.length === 1) return true;
        if (/^02/.test(digits)) return true;
        if (digits.length === 2) return digits.charAt(1) === "1" || /[3-6]/.test(digits.charAt(1));
        return /^(010|011|016|017|018|019|031|032|033|041|042|043|044|051|052|053|054|055|061|062|063|064)/.test(digits);
    }

    /** VoLTE 번호가 입력 중 허용 접두어 목록을 따르는지 검사합니다. */
    function isAllowedVoltePrefix(digits) {
        if (digits === "") return true;

        for (var i = 0; i < VOLTE_PREFIXES.length; i++) {
            var prefix = VOLTE_PREFIXES[i];
            if (prefix.indexOf(digits) === 0 || digits.indexOf(prefix) === 0) {
                return true;
            }
        }

        return false;
    }

    /** 숫자 문자열을 일반 전화번호 또는 VoLTE 표시 형식으로 변환합니다. */
    function formatPhoneDigits(digits, rule) {
        if (rule === RULE_VOLTE) {
            if (digits.length > 7) return digits.replace(/(\d{3})(\d{4})(\d{1,4})/, "$1-$2-$3");
            if (digits.length > 3) return digits.replace(/(\d{3})(\d{1,4})/, "$1-$2");
            return digits;
        }

        if (/^02/.test(digits)) {
            if (digits.length === 9) return digits.replace(/(\d{2})(\d{3})(\d{4})/, "$1-$2-$3");
            if (digits.length >= 10) return digits.replace(/(\d{2})(\d{4})(\d{1,4})/, "$1-$2-$3");
            if (digits.length > 2) return digits.replace(/(\d{2})(\d{1,4})/, "$1-$2");
            return digits;
        }

        if (digits.length === 10) return digits.replace(/(\d{3})(\d{3})(\d{4})/, "$1-$2-$3");
        if (digits.length >= 11) return digits.replace(/(\d{3})(\d{4})(\d{1,4})/, "$1-$2-$3");
        if (digits.length > 3) return digits.replace(/(\d{3})(\d{1,4})/, "$1-$2");
        return digits;
    }

    /** 현재 input 값을 규칙에 맞게 검사·변환하고 정상 상태로 저장합니다. */
    function applyRule(input) {
        var rule = getRule(input);
        if (!rule || input._validationComposing) return;

        var rawValue = input.value || "";
        var selectionStart = typeof input.selectionStart === "number" ? input.selectionStart : rawValue.length;
        var nextValue = rawValue;
        var nextCursor = selectionStart;

        if (rule === RULE_USER_ID) {
            if (/[^a-z0-9]/.test(rawValue)) return restoreState(input);
            nextValue = rawValue.substring(0, 12);
            nextCursor = Math.min(selectionStart, nextValue.length);
        } else if (rule === RULE_PASSWORD) {
            if (/[^A-Za-z0-9~!@#$%^&*()_+|\[\]]/.test(rawValue)) return restoreState(input);
            nextValue = rawValue.substring(0, 20);
            nextCursor = Math.min(selectionStart, nextValue.length);
        } else if (rule === RULE_COMPANY_CODE) {
            if (/[^A-Za-z]/.test(rawValue)) return restoreState(input);
            nextValue = rawValue.toUpperCase().substring(0, 4);
            nextCursor = Math.min(selectionStart, nextValue.length);
        } else if (rule === RULE_PHONE || rule === RULE_VOLTE) {
            if (/[^0-9-]/.test(rawValue)) return restoreState(input);

            var digitCursorIndex = countDigits(rawValue.substring(0, selectionStart));
            var digits = rawValue.replace(/-/g, "").substring(0, 11);
            var allowedPrefix = rule === RULE_VOLTE
                ? isAllowedVoltePrefix(digits) : isAllowedPhonePrefix(digits);

            if (!allowedPrefix) return restoreState(input);

            nextValue = formatPhoneDigits(digits, rule);
            nextCursor = findPhoneCursor(nextValue, Math.min(digitCursorIndex, 11));
        }

        input.value = nextValue;
        setSelection(input, nextCursor, nextCursor);
        saveState(input);
    }

    /** 초기 표시값을 포맷하고 정상 상태를 저장합니다. */
    function initializeInput(input) {
        if (!getRule(input)) return;
        input._validationLastValue = input.value || "";
        input._validationLastStart = input._validationLastValue.length;
        input._validationLastEnd = input._validationLastStart;
        applyRule(input);
    }

    document.addEventListener("focus", function (event) {
        if (!getRule(event.target)) return;
        saveState(event.target);
    }, true);

    document.addEventListener("beforeinput", function (event) {
        var rule = getRule(event.target);
        if (!rule) return;
        if (event.inputType && (event.inputType.indexOf("delete") === 0 || event.inputType.indexOf("history") === 0)) return;
        if (!isAllowedInputText(rule, event.data)) event.preventDefault();
    }, true);

    document.addEventListener("paste", function (event) {
        var rule = getRule(event.target);
        if (!rule) return;
        var text = event.clipboardData ? event.clipboardData.getData("text") : "";
        if (!isAllowedInputText(rule, text)) event.preventDefault();
    }, true);

    document.addEventListener("drop", function (event) {
        var rule = getRule(event.target);
        if (!rule) return;
        var text = event.dataTransfer ? event.dataTransfer.getData("text") : "";
        if (!isAllowedInputText(rule, text)) event.preventDefault();
    }, true);

    document.addEventListener("compositionstart", function (event) {
        var input = event.target;
        if (!getRule(input)) return;
        saveState(input);
        input._validationCompositionValue = input._validationLastValue;
        input._validationCompositionStart = input._validationLastStart;
        input._validationCompositionEnd = input._validationLastEnd;
        input._validationComposing = true;
    }, true);

    document.addEventListener("input", function (event) {
        applyRule(event.target);
    }, true);

    document.addEventListener("compositionend", function (event) {
        var input = event.target;
        if (!getRule(input)) return;
        input._validationComposing = false;
        input.value = input._validationCompositionValue || "";
        setSelection(input, input._validationCompositionStart, input._validationCompositionEnd);
        saveState(input);
        applyRule(input);
    }, true);

    function initializeAll() {
        var inputs = document.querySelectorAll("input[data-input-rule]");
        for (var i = 0; i < inputs.length; i++) initializeInput(inputs[i]);
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initializeAll);
    } else {
        initializeAll();
    }
})(window, document);
