/*
 * 최초 index 페이지 진입 시
 * 세션 및 로그인 여부에 따라 로그인화면으로 전송할지
 * 메인화면으로 전송할 지 판별
 */

var logBfurl = "";

function stMainIdx(sessionVo, url) {
    console.log("세션 체크");
    var contextPath = window.APP_CONTEXT_PATH || "";

    window.onunload = function() {
        console.log("unload");
        // reloadOrKill(false);
    };

    if (sessionVo == "") {
        // 로그인 안 되어 있음
        console.log("로그인 페이지로 이동");
        location.href = contextPath + "/login/login.do";
    } else {
        location.href = contextPath + "/user/userList.do";
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
    var contextPath = window.APP_CONTEXT_PATH || "";

    $.ajax({
        url: contextPath + loginurl,
        type: "POST",
        dataType: "json",
        data: inputVal,

        // ajax 통신 성공 시 로직 수행
        success: function(json) {
            console.log("login success response", json);

            // 서버측으로부터 받은 별도의 에러메시지가 없을 경우 로그인 처리
            if (json.msg == "" || typeof json.msg === "undefined") {
                location.href = contextPath + json.url;
            } else {
                if (json.msg == "중복로그인") {
                    ajaxMethod("/login/loginPost.do?relgn=1", inputVal);
                    location.href = contextPath + json.url;
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

            alert("로그인 요청 중 오류가 발생했습니다.");
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
