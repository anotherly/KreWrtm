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
                    <div class="ctn_tbl_header">
					<img class="list-title-img" src="<%=request.getContextPath()%>/images/icons/ico_setting_title.png"/>
						<div class="ttl_ctn" style="font-size : 32px;">설정</div>
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
                                <div class="auth-panel-heading">
                                    <div class="panel-title">사용자 권한</div>
                                    <div class="auth-heading-actions">
                                        <button type="button" id="editAuthNameBtn" class="auth-action-btn">수정</button>
                                        <button type="button" id="deleteAuthBtn" class="auth-action-btn danger">삭제</button>
                                    </div>
                                </div>
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
                                <div class="auth-panel-footer">
                                    <button type="button" id="addAuthBtn" class="add-auth-btn"><span>+</span> 신규 권한 추가</button>
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

                    <div id="authModal" class="setting-modal" aria-hidden="true">
                        <div class="setting-modal-backdrop"></div>
                        <div class="setting-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="authModalTitle">
                            <div class="setting-modal-header">
                                <h3 id="authModalTitle">신규 권한 추가</h3>
                                <button type="button" id="closeAuthModalBtn" class="setting-modal-close" aria-label="닫기">×</button>
                            </div>
                            <div class="setting-modal-body">
                                <label for="authNameInput">권한명</label>
                                <input type="text" id="authNameInput" maxlength="16" autocomplete="off" placeholder="예: 협업사 관리자">
                                <p>권한명은 16자 이내로 입력해 주세요.</p>
                            </div>
                            <div class="setting-modal-footer">
                                <button type="button" id="cancelAuthModalBtn" class="setting-btn">취소</button>
                                <button type="button" id="saveAuthBtn" class="setting-btn primary">저장</button>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
    </div>

<script>
(function () {
    var contextPath = "${pageContext.request.contextPath}";
    var selectedAuthId = null;
    var selectedAuthName = "";
    var authModalMode = "create";

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

        $("#authList").on("dblclick", ".auth-item", function () {
            selectAuth($(this));
            openAuthModal("edit");
        });

        $("#editAuthNameBtn").on("click", function () { openAuthModal("edit"); });
        $("#deleteAuthBtn").on("click", deleteSelectedAuth);
        $("#addAuthBtn").on("click", function () { openAuthModal("create"); });
        $("#closeAuthModalBtn, #cancelAuthModalBtn, .setting-modal-backdrop").on("click", closeAuthModal);
        $("#saveAuthBtn").on("click", saveAuth);
        $("#authNameInput").on("keydown", function (event) {
            if (event.keyCode === 13) saveAuth();
            if (event.keyCode === 27) closeAuthModal();
        });

        $("#permissionTree").on("change", ".group-check", function () {
            $(this).closest(".permission-group").find(".url-check:not(:disabled)").prop("checked", this.checked);
			enforceAllPermissionDependencies();
            updateCheckState();
        });

        $("#permissionTree").on("change", ".url-check", function () {
			enforcePermissionDependencies($(this));
			updateCheckState();
		});

        $("#checkAllUrls").on("change", function () {
            $(".url-check:not(:disabled)").prop("checked", this.checked);
			enforceAllPermissionDependencies();
            updateCheckState();
        });

        $("#savePermissionBtn").on("click", savePermissions);
    }

    function openAuthModal(mode) {
        if (mode === "edit" && selectedAuthId === null) {
            showToast("수정할 권한을 선택해 주세요.", true);
            return;
        }
        authModalMode = mode;
        $("#authModalTitle").text(mode === "edit" ? "권한명 수정" : "신규 권한 추가");
        $("#authNameInput").val(mode === "edit" ? selectedAuthName : "");
        $("#authModal").addClass("open").attr("aria-hidden", "false");
        window.setTimeout(function () { $("#authNameInput").focus().select(); }, 0);
    }

    function closeAuthModal() {
        $("#authModal").removeClass("open").attr("aria-hidden", "true");
        $("#saveAuthBtn").prop("disabled", false);
    }

    function saveAuth() {
        var authDefine = $.trim($("#authNameInput").val());
        if (!authDefine) {
            showToast("권한명을 입력해 주세요.", true);
            $("#authNameInput").focus();
            return;
        }
        if (authDefine.length > 16) {
            showToast("권한명은 16자 이내로 입력해 주세요.", true);
            return;
        }

        var isEdit = authModalMode === "edit";
        var data = { authDefine: authDefine };
        if (isEdit) data.authId = selectedAuthId;

        $("#saveAuthBtn").prop("disabled", true);
        $.ajax({
            url: contextPath + (isEdit ? "/setting/updateAuthName.ajax" : "/setting/createAuth.ajax"),
            type: "POST",
            dataType: "json",
            data: data,
            success: function (res) {
                if (!res || res.result !== "success") {
                    showToast(res && res.message ? res.message : "권한 정보를 저장하지 못했습니다.", true);
                    $("#saveAuthBtn").prop("disabled", false);
                    return;
                }

                if (isEdit) {
                    var $selected = $(".auth-item[data-auth-id='" + selectedAuthId + "']");
                    selectedAuthName = String(res.authDefine || authDefine);
                    $selected.attr("data-auth-name", selectedAuthName).data("auth-name", selectedAuthName);
                    $selected.find(".auth-name").text(selectedAuthName);
                    $("#selectedAuthName").text(selectedAuthName);
                } else {
                    var $newAuth = createAuthItem(Number(res.authId), String(res.authDefine || authDefine));
                    $("#authList").append($newAuth);
                    selectAuth($newAuth);
                    $newAuth[0].scrollIntoView({ block: "nearest" });
                }
                closeAuthModal();
                showToast(res.message || "권한 정보를 저장했습니다.", false);
            },
            error: function () {
                showToast("권한 정보를 저장하지 못했습니다.", true);
                $("#saveAuthBtn").prop("disabled", false);
            }
        });
    }

    function createAuthItem(authId, authName) {
        var $button = $("<button>", {
            type: "button",
            "class": "auth-item",
            "data-auth-id": authId,
            "data-auth-name": authName
        });
        $button.append($("<span>", { "class": "auth-id", text: authId }));
        $button.append($("<span>", { "class": "auth-name", text: authName }));
        $button.append($("<span>", { "class": "auth-arrow", text: "›" }));
        return $button;
    }

    function deleteSelectedAuth() {
        if (selectedAuthId === null) {
            showToast("삭제할 권한을 선택해 주세요.", true);
            return;
        }
        if (selectedAuthId === 1) {
            alert("코레일 관리자 권한은 삭제할 수 없습니다.");
            return;
        }
        if (!confirm(selectedAuthName + " 권한을 삭제하시겠습니까?\n삭제한 권한은 복구할 수 없습니다.")) return;

        $("#deleteAuthBtn").prop("disabled", true);
        $.ajax({
            url: contextPath + "/setting/deleteAuth.ajax",
            type: "POST",
            dataType: "json",
            data: { authId: selectedAuthId },
            complete: function () { $("#deleteAuthBtn").prop("disabled", false); },
            success: function (res) {
                if (!res || res.result !== "success") {
                    alert(res && res.message ? res.message : "권한을 삭제하지 못했습니다.");
                    return;
                }

                var deletedAuthId = selectedAuthId;
                $(".auth-item[data-auth-id='" + deletedAuthId + "']").remove();
                selectedAuthId = null;
                selectedAuthName = "";
                var $firstAuth = $(".auth-item").first();
                if ($firstAuth.length) {
                    selectAuth($firstAuth);
                } else {
                    $("#selectedAuthName").text("-");
                    $("#selectedCount").text("0개 기능 허용");
                    $("#permissionTree").html('<div class="permission-empty">등록된 권한이 없습니다.</div>');
                    $("#savePermissionBtn").prop("disabled", true);
                }
                showToast(res.message || "권한을 삭제했습니다.", false);
            },
            error: function () {
                alert("권한을 삭제하지 못했습니다.");
            }
        });
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
		enforceAllPermissionDependencies();
        updateCheckState();
    }

	var crudGroups = [
		["/user/userList", "/user/userInsert", "/user/userDetail", "/user/userUpdate", "/user/userDelete"],
		["/company/companyList", "/company/companyInsert", "/company/companyDetail", "/company/companyUpdate", "/company/companyDelete"],
		["/router/routerList", "/router/routerInsert", "/router/routerDetail", "/router/routerUpdate", "/router/routerDelete"],
		["/obs/list", "/obs/insert", "/obs/detail", "/obs/update", "/obs/delete"],
		["/dataroom/list", "/dataroom/insert", "/dataroom/detail", "/dataroom/update", "/dataroom/delete", "/dataroom/fileDownload"]
	];

	function enforceAllPermissionDependencies() {
		$.each(crudGroups, function (_, urls) {
			enforceCrudGroup(urls, null);
		});
	}

	function enforcePermissionDependencies($changed) {
		var changedUrl = String($changed.val() || "");
		$.each(crudGroups, function (_, urls) {
			if ($.inArray(changedUrl, urls) >= 0) {
				enforceCrudGroup(urls, changedUrl);
				return false;
			}
		});
	}

	function enforceCrudGroup(urls, changedUrl) {
		var $list = findUrlCheck(urls[0]);
		var $insert = findUrlCheck(urls[1]);
		var $detail = findUrlCheck(urls[2]);
		var $update = findUrlCheck(urls[3]);
		var $delete = findUrlCheck(urls[4]);
		var $additional = $();
		for (var i = 5; i < urls.length; i++) {
			$additional = $additional.add(findUrlCheck(urls[i]));
		}

		if (!$list.length) return;

		if (changedUrl === urls[0] && !$list.prop("checked")) {
			$insert.add($detail).add($update).add($delete).add($additional).prop("checked", false);
		}
		if (changedUrl === urls[2] && !$detail.prop("checked") && $update.prop("checked")) {
			$detail.prop("checked", true);
			alert("수정 권한을 먼저 해제해야 상세 권한을 해제할 수 있습니다.");
		}
		if ($update.prop("checked")) {
			$detail.prop("checked", true);
		}
		if ($additional.filter(":checked").length) {
			$detail.prop("checked", true);
		}

		var hasChild = $insert.add($detail).add($update).add($delete).add($additional)
			.filter(":checked").length > 0;
		if (hasChild) {
			$list.prop("checked", true);
		}
	}

	function findUrlCheck(url) {
		return $(".url-check").filter(function () { return this.value === url; });
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
