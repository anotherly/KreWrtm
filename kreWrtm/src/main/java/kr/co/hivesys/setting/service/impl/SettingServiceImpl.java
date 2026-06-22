package kr.co.hivesys.setting.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.setting.mapper.SettingMapper;
import kr.co.hivesys.setting.service.SettingService;

@Service("settingService")
public class SettingServiceImpl implements SettingService {

    private static final String DASHBOARD_REFRESH_KEY = "DASHBOARD_REFRESH_SECONDS";

    @Resource(name = "settingMapper")
    private SettingMapper settingMapper;

    @Override
    public int selectDashboardRefreshSeconds() {
        String value = settingMapper.selectSettingValue(DASHBOARD_REFRESH_KEY);

		/* DB 값이 없거나 공백이면 기본값 60초를 사용합니다. */
		if (value == null || value.trim().isEmpty()) {
			return 60;
		}

        try {
			int seconds = Integer.parseInt(value.trim());

			/*
			 * 조회 시에는 양의 정수를 그대로 반환합니다.
			 * 따라서 DB에서 테스트 목적으로 3을 넣으면 대시보드도 3초로 동작합니다.
			 */
			if (seconds > 0) {
				return seconds;
			}
		} catch (NumberFormatException e) {
			/* 숫자가 아닌 DB 값은 아래 기본값으로 처리합니다. */
        }

		return 60;
    }

    @Override
    public void updateDashboardRefreshSeconds(int refreshSeconds) {
		/* 설정 화면에서 저장할 수 있는 정식 주기는 기존 4개 값만 허용합니다. */
        if (!isAllowed(refreshSeconds)) {
            throw new IllegalArgumentException("허용되지 않은 갱신 주기입니다.");
        }
        settingMapper.upsertSetting(DASHBOARD_REFRESH_KEY, String.valueOf(refreshSeconds));
    }

    private boolean isAllowed(int seconds) {
        return seconds == 30 || seconds == 60 || seconds == 300 || seconds == 600;
    }
}
