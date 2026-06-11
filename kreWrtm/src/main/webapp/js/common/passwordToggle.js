/*
 * 비밀번호 보기/숨김 공통 처리
 * - 사용자 등록/수정, 로그인 화면에서 공통 사용
 * - 보기 상태에서 다른 입력칸/영역으로 포커스가 빠지면 자동으로 숨김 처리
 */
(function ($) {
    "use strict";

    var EYE_ICON = ''
        + '<svg class="icon-eye" viewBox="0 0 24 24" aria-hidden="true">'
        + '    <path d="M1.5 12s3.8-6.5 10.5-6.5S22.5 12 22.5 12 18.7 18.5 12 18.5 1.5 12 1.5 12z" stroke-linecap="round" stroke-linejoin="round"></path>'
        + '    <circle cx="12" cy="12" r="3.2"></circle>'
        + '</svg>';

    var EYE_OFF_ICON = ''
        + '<svg class="icon-eye-off" viewBox="0 0 24 24" aria-hidden="true">'
        + '    <path d="M1.5 12s3.8-6.5 10.5-6.5S22.5 12 22.5 12 18.7 18.5 12 18.5 1.5 12 1.5 12z" stroke-linecap="round" stroke-linejoin="round"></path>'
        + '    <circle cx="12" cy="12" r="3.2"></circle>'
        + '    <line x1="4" y1="4" x2="20" y2="20" stroke-linecap="round"></line>'
        + '</svg>';

    function initPasswordToggle() {
        normalizeButtons();

        $(document)
            .off("mousedown.pwToggle", ".btn_pw_toggle")
            .on("mousedown.pwToggle", ".btn_pw_toggle", function (e) {
                // 버튼 클릭 시 input blur가 먼저 발생해서 바로 숨김 처리되는 것을 방지
                e.preventDefault();
            });

        $(document)
            .off("click.pwToggle", ".btn_pw_toggle")
            .on("click.pwToggle", ".btn_pw_toggle", function (e) {
                e.preventDefault();

                var $button = $(this);
                var $input = getTargetInput($button);

                if ($input.length === 0) {
                    return;
                }

                if ($input.attr("type") === "password") {
                    showPassword($input, $button);
                } else {
                    hidePassword($input, $button);
                }

                $input.focus();
            });

        $(document)
            .off("blur.pwToggle", ".password_input_box input")
            .on("blur.pwToggle", ".password_input_box input", function () {
                var input = this;

                setTimeout(function () {
                    var active = document.activeElement;
                    var $box = $(input).closest(".password_input_box");

                    if ($box.find(active).length === 0) {
                        var $button = $box.find(".btn_pw_toggle").first();
                        hidePassword($(input), $button);
                    }
                }, 120);
            });
    }

    function normalizeButtons() {
        $(".btn_pw_toggle").each(function () {
            var $button = $(this);

            if ($button.find(".icon-eye").length === 0 || $button.find(".icon-eye-off").length === 0) {
                $button.html(EYE_ICON + EYE_OFF_ICON);
            }

            if (!$button.attr("title")) {
                $button.attr("title", "비밀번호 보기");
            }
            if (!$button.attr("aria-label")) {
                $button.attr("aria-label", "비밀번호 보기");
            }
        });
    }

    function getTargetInput($button) {
        var targetId = $button.data("target");
        var $input = $();

        if (targetId) {
            $input = $("#" + targetId);
        }

        if ($input.length === 0) {
            $input = $button.closest(".password_input_box").find("input").first();
        }

        return $input;
    }

    function showPassword($input, $button) {
        $input.attr("type", "text");
        $button.addClass("is_visible");
        $button.attr("title", "비밀번호 숨기기");
        $button.attr("aria-label", "비밀번호 숨기기");
    }

    function hidePassword($input, $button) {
        if ($input.length === 0) {
            return;
        }

        $input.attr("type", "password");
        $button.removeClass("is_visible");
        $button.attr("title", "비밀번호 보기");
        $button.attr("aria-label", "비밀번호 보기");
    }

    window.initPasswordToggle = initPasswordToggle;

    $(document).ready(function () {
        initPasswordToggle();
    });
})(jQuery);
