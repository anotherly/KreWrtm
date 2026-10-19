/* 모니터링 최초 화면 및 AJAX 상세 콘텐츠에 공통으로 적용 */
(function ($) {
    'use strict';
    $(function () {
        var contextPath = window.APP_CONTEXT_PATH || '';
        var $container = $('.left-container');

        $container.on('click', '.monitor-remote-btn', function () {
            var $btn = $(this);
            var carNum = $btn.attr('data-car-num');
            var volteNum = $btn.attr('data-volte-num');
            if (typeof canRemoteControl === 'undefined' || !canRemoteControl) {
                alert('권한이 없습니다. 코레일 관리자에게 문의하세요.');
                return;
            }
            if (!volteNum) {
                alert('원격제어용 VoLTE 번호가 없습니다.');
                return;
            }
            if (confirm('해당 호차(' + carNum + ') 원격 제어를 실행하시겠습니까?\n\n주의! 사용자 PC에 TightVNC가 설치되어 있어야 합니다.')) {
                window.location.href = contextPath +
                    '/remote/remoteControll.ajax?volteNum=' + encodeURIComponent(volteNum);
            }
        });

        $container.on('change', '.wireless-send-options input[name="flagSend"]', function () {
            var $radio = $(this);
            var $panel = $radio.closest('.wireless-send-panel');
            var $radios = $panel.find('input[name="flagSend"]');
            var $status = $panel.find('.wireless-send-status');
            var deviceId = $panel.attr('data-device-id');
            var value = $radio.val();
            var previous = $panel.data('saved-value');
            if (typeof previous === 'undefined') {
                previous = $radios.not($radio).val();
            }

            if (!deviceId || (value !== '0' && value !== '1')) {
                alert('장비 또는 전송 설정 값이 올바르지 않습니다.');
                $radios.filter('[value="' + previous + '"]').prop('checked', true);
                return;
            }

            $radios.prop('disabled', true);
            $status.text('저장 중...').removeClass('send-error send-saved');
            $.ajax({
                url: contextPath + '/search/updateSendFlag.ajax',
                type: 'POST',
                dataType: 'json',
                data: {deviceId: deviceId, flagSend: value},
                success: function (result) {
                    if (result && result.result === 1) {
                        $panel.data('saved-value', value);
                        $status.text('저장되었습니다.').addClass('send-saved');
                    } else {
                        $radios.filter('[value="' + previous + '"]').prop('checked', true);
                        $status.text((result && result.msg) || '저장에 실패했습니다.').addClass('send-error');
                    }
                },
                error: function (xhr) {
                    $radios.filter('[value="' + previous + '"]').prop('checked', true);
                    $status.text(xhr.status === 403 ? '변경 권한이 없습니다.' : '저장 중 오류가 발생했습니다.')
                        .addClass('send-error');
                },
                complete: function () {
                    // 응답을 기다리는 동안 다른 단말기로 이동했다면 과거 패널만 갱신된다.
                    $radios.prop('disabled', false);
                }
            });
        });
    });
})(jQuery);
