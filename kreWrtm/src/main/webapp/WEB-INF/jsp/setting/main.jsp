<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>무선장치 관리시스템 - 설정</title>
    <jsp:include page="../cmn/top.jsp" flush="false" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/setting.css">
</head>
<body class="open">
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar navbar-expand-sm navbar-default"><ul class="menu-inner"></ul></nav>
    </aside>

    <div id="container" class="container-wrap" style="margin-top: 0px;">
        <div id="header" class="header-wrap"></div>
        <div id="contents" class="contents-wrap">
            <div id="work" class="work-wrap setting-work">
                <main id="contents_box" class="contents_box setting-page">
                    <div class="setting-title-row">
                        <div>
                            <h2>설정</h2>
                            <p>대시보드 갱신 주기와 사용자 권한별 접근 메뉴를 관리합니다.</p>
                        </div>
                    </div>

                    <section class="refresh-setting" aria-labelledby="refreshTitle">
                        <div class="setting-section-heading">
                            <div class="setting-heading-icon">↻</div>
                            <div>
                                <h3 id="refreshTitle">대시보드 갱신 주기</h3>
                                <p>현재 브라우저에서 대시보드 데이터를 다시 조회하는 간격입니다.</p>
                            </div>
                        </div>
                        <div class="refresh-controls">
                            <div class="refresh-options" role="radiogroup" aria-label="대시보드 갱신 주기">
                                <button type="button" class="refresh-option" data-seconds="30">30초</button>
                                <button type="button" class="refresh-option" data-seconds="60">1분</button>
                                <button type="button" class="refresh-option" data-seconds="300">5분</button>
                                <button type="button" class="refresh-option" data-seconds="600">10분</button>
                            </div>
                            <button type="button" id="saveRefreshBtn" class="setting-btn primary">적용</button>
                        </div>
                    </section>

                    <section class="permission-setting" aria-labelledby="permissionTitle">
                        <div class="permission-header">
                            <div class="setting-section-heading">
                                <div class="setting-heading-icon">✓</div>
                                <div>
                                    <h3 id="permissionTitle">사용자 권한 관리</h3>
                                    <p>왼쪽에서 권한을 선택한 후 접근을 허용할 메뉴와 기능을 체크합니다.</p>
                                </div>
                            </div>
                            <button type="button" id="savePermissionBtn" class="setting-btn primary">권한 저장</button>
                        </div>

                        <div class="permission-layout">
                            <div class="auth-panel">
                                <div class="panel-title">사용자 권한</div>
                                <div id="authList" class="auth-list">
                                    <c:forEach var="auth" items="${authList}" varStatus="status">
                                        <button type="button" class="auth-item<c:if test='${status.first}'> active</c:if>"
                                                data-auth-id="${auth.authId}" data-auth-name="${auth.authDefine}">
                                            <span class="auth-id">${auth.authId}</span>
                                            <span class="auth-name">${auth.authDefine}</span>
                                            <span class="auth-arrow">›</span>
                                        </button>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="url-panel">
                                <div class="panel-title-row">
                                    <div>
                                        <div class="panel-title"><span id="selectedAuthName">-</span> 접근 메뉴</div>
                                        <div id="selectedCount" class="selected-count">0개 기능 허용</div>
                                    </div>
                                    <label class="check-all-label"><input type="checkbox" id="checkAllUrls"> 전체 선택</label>
                                </div>
                                <div id="permissionTree" class="permission-tree">
                                    <div class="permission-loading">접근 메뉴를 불러오는 중입니다.</div>
                                </div>
                            </div>
                        </div>
                    </section>
                    <div id="settingToast" class="setting-toast" role="status" aria-live="polite"></div>
                </main>
            </div>
        </div>
    </div>

<script>
(function () {
    var contextPath = "${pageContext.request.contextPath}";
    var selectedAuthId = null;
    var selectedAuthName = "";

    $(document).ready(function () {
        initRefreshSetting();
        bindSettingEvents();
        var $firstAuth = $(".auth-item").first();
        if ($firstAuth.length) {
            selectAuth($firstAuth);
        }
    });

    function initRefreshSetting() {
        var seconds = Number("${dashboardRefreshSeconds}") || 60;
		/* 화면에서 선택 가능한 정식 주기는 기존 4개 값으로 유지합니다. */
		if ([30, 60, 300, 600].indexOf(seconds) < 0) seconds = 60;
        $(".refresh-option[data-seconds='" + seconds + "']").addClass("active").attr("aria-checked", "true");
    }

    function bindSettingEvents() {
        $(".refresh-option").on("click", function () {
            $(".refresh-option").removeClass("active").attr("aria-checked", "false");
            $(this).addClass("active").attr("aria-checked", "true");
        });

        $("#saveRefreshBtn").on("click", function () {
            var seconds = Number($(".refresh-option.active").data("seconds"));
			$(this).prop("disabled", true);
			$.ajax({
				url: contextPath + "/setting/saveRefresh.ajax",
				type: "POST",
				dataType: "json",
				data: { refreshSeconds: seconds },
				complete: function () { $("#saveRefreshBtn").prop("disabled", false); },
				success: function (res) {
					showToast(res && res.message ? res.message : "갱신 주기를 저장했습니다.", !res || res.result !== "success");
				},
				error: function () { showToast("갱신 주기를 저장하지 못했습니다.", true); }
			});
        });

        $("#authList").on("click", ".auth-item", function () {
            selectAuth($(this));
        });

        $("#permissionTree").on("change", ".group-check", function () {
            $(this).closest(".permission-group").find(".url-check:not(:disabled)").prop("checked", this.checked);
            updateCheckState();
        });

        $("#permissionTree").on("change", ".url-check", updateCheckState);

        $("#checkAllUrls").on("change", function () {
            $(".url-check:not(:disabled)").prop("checked", this.checked);
            updateCheckState();
        });

        $("#savePermissionBtn").on("click", savePermissions);
    }

    function selectAuth($button) {
        $(".auth-item").removeClass("active");
        $button.addClass("active");
        selectedAuthId = Number($button.data("auth-id"));
        selectedAuthName = String($button.data("auth-name"));
        $("#selectedAuthName").text(selectedAuthName);
        loadPermissions();
    }

    function loadPermissions() {
        $("#permissionTree").html('<div class="permission-loading">접근 메뉴를 불러오는 중입니다.</div>');
        $("#savePermissionBtn").prop("disabled", true);
        $.ajax({
            url: contextPath + "/setting/authUrls.ajax",
            type: "POST",
            dataType: "json",
            data: { authId: selectedAuthId },
            success: function (res) {
                if (!res || res.result !== "success") {
                    showPermissionError(res && res.message ? res.message : "접근 메뉴를 조회하지 못했습니다.");
                    return;
                }
                renderPermissionTree(res.urlList || []);
                $("#savePermissionBtn").prop("disabled", false);
            },
            error: function () {
                showPermissionError("접근 메뉴를 조회하지 못했습니다.");
            }
        });
    }

    function renderPermissionTree(list) {
        if (!list.length) {
            $("#permissionTree").html('<div class="permission-empty">등록된 접근 메뉴가 없습니다.</div>');
            updateCheckState();
            return;
        }

        var groups = {};
        $.each(list, function (_, item) {
            var groupName = item.authUrlName1 || "기타";
            if (!groups[groupName]) groups[groupName] = [];
            groups[groupName].push(item);
        });

        var html = "";
        $.each(groups, function (groupName, items) {
            html += '<section class="permission-group">';
            html += '<label class="group-heading"><input type="checkbox" class="group-check"><span>' + escapeHtml(groupName) + '</span><em>' + items.length + '</em></label>';
            html += '<div class="permission-items">';
            $.each(items, function (_, item) {
                var locked = isRequiredUrl(item.url);
                var checked = item.useYn === "Y";
                var name = item.authUrlName2 || item.authUrlName3 || "기능";
                html += '<label class="permission-item' + (locked ? ' locked' : '') + '">';
                html += '<input type="checkbox" class="url-check" value="' + escapeHtml(item.url) + '"' + (checked ? ' checked' : '') + (locked ? ' disabled' : '') + '>';
                html += '<span class="permission-checkmark"></span>';
                html += '<span class="permission-text"><b>' + escapeHtml(name) + '</b><small>' + escapeHtml(item.url) + '</small></span>';
                if (locked) html += '<span class="required-label">필수</span>';
                html += '</label>';
            });
            html += '</div></section>';
        });
        $("#permissionTree").html(html);
        updateCheckState();
    }

    function updateCheckState() {
        $(".permission-group").each(function () {
            var $enabled = $(this).find(".url-check:not(:disabled)");
            var checked = $enabled.filter(":checked").length;
            $(this).find(".group-check").prop("checked", $enabled.length > 0 && checked === $enabled.length)
                .prop("indeterminate", checked > 0 && checked < $enabled.length);
        });

        var $all = $(".url-check:not(:disabled)");
        var totalChecked = $(".url-check:checked").length;
        var editableChecked = $all.filter(":checked").length;
        $("#checkAllUrls").prop("checked", $all.length > 0 && editableChecked === $all.length)
            .prop("indeterminate", editableChecked > 0 && editableChecked < $all.length);
        $("#selectedCount").text(totalChecked + "개 기능 허용");
    }

    function savePermissions() {
        if (selectedAuthId === null) return;
        var urlList = [];
        $(".url-check:checked:not(:disabled)").each(function () { urlList.push(this.value); });

        if (!confirm(selectedAuthName + "의 접근 권한을 저장하시겠습니까?")) return;

        $("#savePermissionBtn").prop("disabled", true);
        $.ajax({
            url: contextPath + "/setting/saveAuthUrls.ajax",
            type: "POST",
            dataType: "json",
            traditional: true,
            data: { authId: selectedAuthId, "urlList[]": urlList },
            success: function (res) {
                if (res && res.result === "success") {
                    showToast(res.message || "접근 권한을 저장했습니다.", false);
                    loadPermissions();
                } else {
                    showToast(res && res.message ? res.message : "접근 권한 저장에 실패했습니다.", true);
                    $("#savePermissionBtn").prop("disabled", false);
                }
            },
            error: function () {
                showToast("접근 권한 저장에 실패했습니다.", true);
                $("#savePermissionBtn").prop("disabled", false);
            }
        });
    }

    function showPermissionError(message) {
        $("#permissionTree").html('<div class="permission-empty error">' + escapeHtml(message) + '</div>');
        $("#savePermissionBtn").prop("disabled", true);
        updateCheckState();
    }

    function showToast(message, isError) {
        var $toast = $("#settingToast");
        $toast.stop(true, true).toggleClass("error", !!isError).text(message).fadeIn(150).delay(2200).fadeOut(250);
    }

    function isRequiredUrl(url) {
        return String(url || "").indexOf("/setting/") === 0
            || url === "/chart/main"
            || url === "/chart/dashboardData"
            || url === "/chart/dashboardLastDataList";
    }

    function escapeHtml(value) {
        return $("<div>").text(value == null ? "" : String(value)).html();
    }
})();
</script>
</body>
</html>
