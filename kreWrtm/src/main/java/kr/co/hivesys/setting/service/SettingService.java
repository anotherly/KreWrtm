package kr.co.hivesys.setting.service;

public interface SettingService {
    int selectDashboardRefreshSeconds();
    void updateDashboardRefreshSeconds(int refreshSeconds);
}
