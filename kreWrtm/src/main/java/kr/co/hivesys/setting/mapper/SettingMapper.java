package kr.co.hivesys.setting.mapper;

import org.apache.ibatis.annotations.Param;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("settingMapper")
public interface SettingMapper {
    String selectSettingValue(String settingKey);
    int upsertSetting(@Param("settingKey") String settingKey, @Param("settingValue") String settingValue);
}
