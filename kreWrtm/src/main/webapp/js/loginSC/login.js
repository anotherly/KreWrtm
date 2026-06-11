/*
 * 최초 index 페이지 진입 시
 * 세션 및 로그인 여부에 따라 로그인화면으로 전송할지
 * 메인화면으로 전송할 지 판별
 */

var logBfurl = "";

/*
 * 정적 JS 파일에서는 request.getContextPath()를 직접 쓸 수 없으므로
 * JSP에서 window.APP_CONTEXT_PATH를 선언한 경우 그 값을 우선 사용한다.
 *
 * 중요:
 * window.location.pathname 이 "/" 인 경우 firstPath가 빈 문자열이 되므로
 * 반드시 ""을 반환해야 한다.
 * 이전 수정본처럼 "/"를 반환하면 location.href = "//login/login.do"가 되어
 * 브라우저가 http://login/login.do 로 이동해버린다.
 */
function getContextPath() {
    if (typeof window.APP_CONTEXT_PATH !== "undefined") {
        return window.APP_CONTEXT_PATH || "";
    }

    var path = window.location.pathname || "";
    var firstPath = path.split("/")[1] || "";

    // ROOT 배포: /, /login/login.do, /chart/main.do 등
    if (firstPath === ""
            || firstPath === "login"
            || firstPath === "chart"
            || firstPath === "user"
            || firstPath === "css"
            || firstPath === "js"
            || firstPath === "images"
            || firstPath === "DataTables"
            || firstPath === "calender"
            || firstPath === "firmwareFile") {
        return "";
    }

    // 컨텍스트 배포: /KreWrtm/login/login.do 등
    return "/" + firstPath;
}

function toAppUrl(path) {
    var contextPath = getContextPath();

    if (!path) {
        return contextPath || "/";
    }

    if (path.charAt(0) !== "/") {
        path = "/" + path;
    }

    return contextPath + path;
}

function stMainIdx(sessionVo, url) {
    console.log("세션 체크");

    window.onunload = function() {
        console.log("unload");
        // reloadOrKill(false);
    };

    if (sessionVo == "") {
        // 로그인 안 되어 있음
        console.log("로그인 페이지로 이동");
        location.href = toAppUrl("/login/login.do");
    } else {
        location.href = toAppUrl("/user/userList.do");
    }

    // 탭이나 창 닫기시 로그아웃 처리
    $(window).bind("beforeunload", function(e) {
        if (typeof rkFlag !== "undefined") {
            console.log("언로드됨 : " + rkFlag);
        }
    });
}

/*
 * 로그인 처리 및 불완전 접속 종료 시
 * 기존 세션을 끊고 신규 세션 생성
 */
function inputLogin(inputVal, loginurl) {
    console.log("입력값에 따른 로그인 처리");
    console.log("loginurl : " + loginurl);

    $.ajax({
        url: loginurl,
        type: "POST",
        dataType: "json",
        data: inputVal,

        // ajax 통신 성공 시 로직 수행
        success: function(json) {
            console.log("login success response", json);

            // 서버측으로부터 받은 별도의 에러메시지가 없을 경우 로그인 처리
            if (json.msg == "" || typeof json.msg === "undefined") {
                location.href = toAppUrl(json.url);
            } else {
                if (json.msg == "중복로그인") {
                    ajaxMethod(toAppUrl("/login/loginPost.do?relgn=1"), inputVal);
                    location.href = toAppUrl(json.url);
                } else {
                    alert(json.msg);
                }
            }
        },

        error: function(xhr, status, error) {
            console.log("AJAX ERROR");
            console.log("status : " + status);
            console.log("error : " + error);
            console.log("responseText : " + xhr.responseText);

            alert("로그인 요청 중 오류가 발생했습니다. 서버 로그를 확인하세요.");
        },

        // finally 기능 수행
        complete: function(xhr) {
            console.log("파이널리.");
            if (xhr && typeof xhr.status !== "undefined") {
                console.log("HTTP status : " + xhr.status);
            }
        }
    });
}
