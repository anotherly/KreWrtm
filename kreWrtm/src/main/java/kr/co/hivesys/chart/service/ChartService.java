package kr.co.hivesys.chart.service;

import java.util.List;
import java.util.Map;

public interface ChartService {

    public Map<String, Object> selectDashboardKpi(Map<String, Object> param) throws Exception;

    public List<Map<String, Object>> selectDashboardTrendList(Map<String, Object> param) throws Exception;

    public List<Map<String, Object>> selectDashboardRadioList(Map<String, Object> param) throws Exception;

    public List<Map<String, Object>> selectDashboardRsrpStatusList(Map<String, Object> param) throws Exception;

    public List<Map<String, Object>> selectDashboardRsrqStatusList(Map<String, Object> param) throws Exception;

    public List<Map<String, Object>> selectDashboardReceiveList(Map<String, Object> param) throws Exception;
}
