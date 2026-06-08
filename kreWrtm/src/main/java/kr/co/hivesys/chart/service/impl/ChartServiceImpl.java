package kr.co.hivesys.chart.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.co.hivesys.chart.mapper.ChartMapper;
import kr.co.hivesys.chart.service.ChartService;

@Service("chartService")
public class ChartServiceImpl implements ChartService {

    @Resource(name = "chartMapper")
    private ChartMapper chartMapper;

    @Override
    public Map<String, Object> selectDashboardKpi(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardKpi(param);
    }

    @Override
    public List<Map<String, Object>> selectDashboardTrendList(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardTrendList(param);
    }

    @Override
    public List<Map<String, Object>> selectDashboardRadioList(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardRadioList(param);
    }

    @Override
    public List<Map<String, Object>> selectDashboardRsrpStatusList(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardRsrpStatusList(param);
    }

    @Override
    public List<Map<String, Object>> selectDashboardRsrqStatusList(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardRsrqStatusList(param);
    }

    @Override
    public List<Map<String, Object>> selectDashboardReceiveList(Map<String, Object> param) throws Exception {
        return chartMapper.selectDashboardReceiveList(param);
    }
}
