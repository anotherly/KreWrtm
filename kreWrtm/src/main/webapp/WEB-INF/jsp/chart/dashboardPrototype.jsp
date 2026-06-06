<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>무선장치 관리시스템 - 대시보드 프로토타입</title>
    <meta charset="UTF-8">
    <jsp:include page="../cmn/top.jsp" flush="false" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dashboard-prototype.css">

<script>
$(document).ready(function(){
    /*
     * 프로토타입 전용 정적 데이터입니다.
     * 추후 Controller 연동 시 아래 객체만 AJAX 결과로 대체하면 화면 구조는 유지할 수 있습니다.
     * 참조 테이블 후보:
     * - tbl_company_info / tbl_router_info / tbl_receive_data / tbl_last_data / tbl_obs_info
     */
    var dashboardData = {
        summary: {
            totalDevice: 100,
            lteCount: 51,
            vhfCount: 49,
            autoSwitchCount: 47,
            avgRsrp: -78.5,
            avgRsrq: -12.0,
            weakDeviceCount: 9,
            lastReceiveTime: "2026-06-05 22:39:15"
        },
        receiveTrend: {
            x: ["22:28", "22:29", "22:30", "22:31", "22:32", "22:33", "22:34", "22:35", "22:36", "22:37", "22:38", "22:39"],
            total: [62, 66, 69, 74, 72, 78, 83, 88, 91, 94, 98, 100],
            lte: [28, 30, 34, 35, 37, 39, 42, 44, 46, 48, 50, 51],
            vhf: [34, 36, 35, 39, 35, 39, 41, 44, 45, 46, 48, 49]
        },
        radioType: [
            ["LTE-R", 51],
            ["VHF", 49]
        ],
        companyQuality: {
            x: ["케이원", "차량본부", "전기본부"],
            receive: [42, 36, 22],
            avgRsrp: [74, 81, 89],
            avgRsrq: [9, 13, 16]
        },
        recentList: [
            {volte:"01300001348", car:"391348", radio:"VHF", rsrp:"-91", rsrq:"-14", cell:"3418480", time:"22:39:15", status:"주의"},
            {volte:"01300001106", car:"391106", radio:"LTE-R", rsrp:"-101", rsrq:"-9", cell:"3418061", time:"22:39:15", status:"주의"},
            {volte:"01300001381", car:"391381", radio:"LTE-R", rsrp:"-75", rsrq:"-4", cell:"3418810", time:"22:39:15", status:"정상"},
            {volte:"01300001820", car:"391820", radio:"LTE-R", rsrp:"-108", rsrq:"-19", cell:"3418201", time:"22:39:15", status:"위험"},
            {volte:"01300001756", car:"391756", radio:"VHF", rsrp:"-115", rsrq:"-8", cell:"3418561", time:"22:39:14", status:"위험"}
        ],
        riskList: [
            {name:"391820 / 01300001820", desc:"RSRP -108, RSRQ -19", rate:88, cls:"red"},
            {name:"391756 / 01300001756", desc:"RSRP -115, RSRQ -8", rate:82, cls:"red"},
            {name:"391799 / 01300001799", desc:"RSRP -104, RSRQ -16", rate:68, cls:"orange"},
            {name:"391106 / 01300001106", desc:"RSRP -101, RSRQ -9", rate:54, cls:"orange"}
        ]
    };

    $("#kpiTotalDevice").text(dashboardData.summary.totalDevice);
    $("#kpiLteRatio").text(Math.round(dashboardData.summary.lteCount / dashboardData.summary.totalDevice * 100) + "%");
    $("#kpiAvgRsrp").text(dashboardData.summary.avgRsrp);
    $("#kpiAvgRsrq").text(dashboardData.summary.avgRsrq);
    $("#kpiWeakDevice").text(dashboardData.summary.weakDeviceCount);
    $("#lastReceiveTime").text(dashboardData.summary.lastReceiveTime);

    var recentHtml = "";
    $.each(dashboardData.recentList, function(i, row){
        var badgeClass = row.status === "정상" ? "green" : (row.status === "위험" ? "red" : "orange");
        recentHtml += "<tr>" +
            "<td>" + row.volte + "</td>" +
            "<td>" + row.car + "</td>" +
            "<td><span class='wdm-badge'>" + row.radio + "</span></td>" +
            "<td>" + row.rsrp + "</td>" +
            "<td>" + row.rsrq + "</td>" +
            "<td>" + row.cell + "</td>" +
            "<td>" + row.time + "</td>" +
            "<td><span class='wdm-badge " + badgeClass + "'>" + row.status + "</span></td>" +
        "</tr>";
    });
    $("#recentReceiveBody").html(recentHtml);

    var riskHtml = "";
    $.each(dashboardData.riskList, function(i, row){
        riskHtml += "<div class='wdm-status-item'>" +
            "<div class='wdm-status-top'><span>" + row.name + "</span><span>" + row.rate + "%</span></div>" +
            "<div class='wdm-card-sub' style='margin-bottom:8px;'>" + row.desc + "</div>" +
            "<div class='wdm-status-bar'><div class='wdm-status-fill " + row.cls + "' style='width:" + row.rate + "%;'></div></div>" +
        "</div>";
    });
    $("#riskDeviceList").html(riskHtml);

    c3.generate({
        bindto: "#receiveTrendChart",
        size: { height: 300 },
        data: {
            x: "x",
            columns: [
                ["x"].concat(dashboardData.receiveTrend.x),
                ["전체 수신"].concat(dashboardData.receiveTrend.total),
                ["LTE-R"].concat(dashboardData.receiveTrend.lte),
                ["VHF"].concat(dashboardData.receiveTrend.vhf)
            ],
            types: {
                "전체 수신": "area-spline",
                "LTE-R": "spline",
                "VHF": "spline"
            }
        },
        color: { pattern: ["#0b84d8", "#16b36b", "#ff9f1c"] },
        axis: {
            x: { type: "category", tick: { rotate: 0, multiline: false } },
            y: { min: 0, padding: { bottom: 0 }, label: { text: "수신 건수", position: "outer-middle" } }
        },
        grid: { y: { show: true } },
        legend: { position: "bottom" },
        point: { r: 3 }
    });

    c3.generate({
        bindto: "#radioTypeChart",
        size: { height: 205 },
        data: {
            columns: dashboardData.radioType,
            type: "donut"
        },
        color: { pattern: ["#16b36b", "#ff9f1c"] },
        donut: {
            title: "무선망",
            width: 28,
            label: { format: function(value, ratio) { return Math.round(ratio * 100) + "%"; } }
        },
        legend: { show: false }
    });

    c3.generate({
        bindto: "#companyQualityChart",
        size: { height: 254 },
        data: {
            x: "x",
            columns: [
                ["x"].concat(dashboardData.companyQuality.x),
                ["수신 건수"].concat(dashboardData.companyQuality.receive),
                ["RSRP 절대값"].concat(dashboardData.companyQuality.avgRsrp),
                ["RSRQ 절대값"].concat(dashboardData.companyQuality.avgRsrq)
            ],
            type: "bar"
        },
        color: { pattern: ["#0b84d8", "#7c5cff", "#13b8d6"] },
        axis: { x: { type: "category" }, y: { min: 0, padding: { bottom: 0 } } },
        grid: { y: { show: true } },
        bar: { width: { ratio: 0.55 } },
        legend: { position: "bottom" }
    });
});
</script>
</head>
<body class="open dashboard-proto-body">
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar">
            <ul class="menu-inner"></ul>
        </nav>
    </aside>

    <div id="container" class="container-wrap" style="margin-top:60px;background:none;">
        <div id="header" class="header-wrap"></div>

        <div class="wdm-dashboard">
            <div class="wdm-page-head">
                <div class="wdm-page-title-wrap">
                    <span class="wdm-eyebrow">WIRELESS DEVICE MANAGEMENT</span>
                    <h1 class="wdm-page-title">무선장치 통합 대시보드</h1>
                    <p class="wdm-page-desc">수신 데이터, 무선망 상태, 단말 품질, 장애 징후를 한 화면에서 확인하는 프로토타입 화면입니다.</p>
                </div>
                <div class="wdm-toolbar">
                    <select class="wdm-select">
                        <option>금일 기준</option>
                        <option>최근 7일</option>
                        <option>최근 30일</option>
                    </select>
                    <button type="button" class="wdm-button">새로고침</button>
                </div>
            </div>

            <div class="wdm-kpi-grid">
                <div class="wdm-kpi-card">
                    <div class="wdm-kpi-label">전체 수신 단말 <span class="wdm-kpi-icon">📡</span></div>
                    <div class="wdm-kpi-value"><span id="kpiTotalDevice">0</span><span style="font-size:16px;"> 대</span></div>
                    <div class="wdm-kpi-sub">마지막 수신: <span id="lastReceiveTime">-</span></div>
                </div>
                <div class="wdm-kpi-card green">
                    <div class="wdm-kpi-label">LTE-R 비율 <span class="wdm-kpi-icon">✓</span></div>
                    <div class="wdm-kpi-value" id="kpiLteRatio">0%</div>
                    <div class="wdm-kpi-sub">VHF와 LTE-R 무선망 분포 기준</div>
                </div>
                <div class="wdm-kpi-card purple">
                    <div class="wdm-kpi-label">평균 RSRP <span class="wdm-kpi-icon">↘</span></div>
                    <div class="wdm-kpi-value"><span id="kpiAvgRsrp">0</span><span style="font-size:16px;"> dBm</span></div>
                    <div class="wdm-kpi-sub">수신전력 평균값</div>
                </div>
                <div class="wdm-kpi-card orange">
                    <div class="wdm-kpi-label">평균 RSRQ <span class="wdm-kpi-icon">≋</span></div>
                    <div class="wdm-kpi-value"><span id="kpiAvgRsrq">0</span><span style="font-size:16px;"> dB</span></div>
                    <div class="wdm-kpi-sub">수신품질 평균값</div>
                </div>
                <div class="wdm-kpi-card red">
                    <div class="wdm-kpi-label">주의 단말 <span class="wdm-kpi-icon">!</span></div>
                    <div class="wdm-kpi-value"><span id="kpiWeakDevice">0</span><span style="font-size:16px;"> 대</span></div>
                    <div class="wdm-kpi-sub">RSRP/RSRQ 기준 임계치 후보</div>
                </div>
            </div>

            <div class="wdm-layout-grid">
                <div class="wdm-card wdm-c3-clean">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">실시간 수신 추이</h2>
                        <span class="wdm-card-sub">최근 12분 프로토타입 데이터</span>
                    </div>
                    <div class="wdm-card-body">
                        <div id="receiveTrendChart" class="wdm-chart-large"></div>
                    </div>
                </div>

                <div class="wdm-card wdm-c3-clean">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">무선망 상태 분포</h2>
                        <span class="wdm-card-sub">CurrentRadioType 기준</span>
                    </div>
                    <div class="wdm-card-body">
                        <div class="wdm-donut-wrap">
                            <div id="radioTypeChart" class="wdm-chart-small"></div>
                            <div class="wdm-status-list">
                                <div class="wdm-status-item">
                                    <div class="wdm-status-top"><span>LTE-R</span><span>51%</span></div>
                                    <div class="wdm-status-bar"><div class="wdm-status-fill green" style="width:51%;"></div></div>
                                </div>
                                <div class="wdm-status-item">
                                    <div class="wdm-status-top"><span>VHF</span><span>49%</span></div>
                                    <div class="wdm-status-bar"><div class="wdm-status-fill orange" style="width:49%;"></div></div>
                                </div>
                                <div class="wdm-status-item">
                                    <div class="wdm-status-top"><span>자동전환 사용</span><span>47%</span></div>
                                    <div class="wdm-status-bar"><div class="wdm-status-fill" style="width:47%;"></div></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="wdm-bottom-grid">
                <div class="wdm-card wdm-c3-clean">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">소속기관별 수신품질</h2>
                        <span class="wdm-card-sub">수신 건수 / RSRP / RSRQ</span>
                    </div>
                    <div class="wdm-card-body">
                        <div id="companyQualityChart" class="wdm-chart-mid"></div>
                    </div>
                </div>

                <div class="wdm-card">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">위험 징후 단말</h2>
                        <span class="wdm-card-sub">수신품질 임계치 후보</span>
                    </div>
                    <div class="wdm-card-body">
                        <div id="riskDeviceList" class="wdm-status-list"></div>
                    </div>
                </div>
            </div>

            <div class="wdm-bottom-grid" style="margin-top:18px;">
                <div class="wdm-card">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">최근 수신 단말 목록</h2>
                        <span class="wdm-card-sub">tbl_receive_data 주요 필드 기준</span>
                    </div>
                    <div class="wdm-card-body" style="padding-top:10px;">
                        <table class="wdm-table">
                            <thead>
                                <tr>
                                    <th>VoLTE 번호</th>
                                    <th>편성번호</th>
                                    <th>무선망</th>
                                    <th>RSRP</th>
                                    <th>RSRQ</th>
                                    <th>Cell ID</th>
                                    <th>수신시각</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody id="recentReceiveBody"></tbody>
                        </table>
                    </div>
                </div>

                <div class="wdm-card">
                    <div class="wdm-card-header">
                        <h2 class="wdm-card-title">GPS 수신 위치</h2>
                        <span class="wdm-card-sub">지도 연동 전 배치 프로토타입</span>
                    </div>
                    <div class="wdm-card-body">
                        <div class="wdm-map-card">
                            <div class="wdm-map-gridline"></div>
                            <span class="wdm-map-pin green" style="left:32%; top:42%;"></span>
                            <span class="wdm-map-pin" style="left:48%; top:35%;"></span>
                            <span class="wdm-map-pin orange" style="left:62%; top:56%;"></span>
                            <span class="wdm-map-pin red" style="left:72%; top:48%;"></span>
                            <span class="wdm-map-pin" style="left:55%; top:68%;"></span>
                            <div class="wdm-map-caption">
                                <strong>부산권 수신 샘플</strong>
                                <span>GPS_lat / GPS_lon 값을 지도 API와 연동 예정</span>
                            </div>
                        </div>
                        <div class="wdm-mini-grid">
                            <div class="wdm-mini-stat">
                                <div class="wdm-mini-label">최저 RSRP</div>
                                <div class="wdm-mini-value">-118</div>
                            </div>
                            <div class="wdm-mini-stat">
                                <div class="wdm-mini-label">최저 RSRQ</div>
                                <div class="wdm-mini-value">-20</div>
                            </div>
                            <div class="wdm-mini-stat">
                                <div class="wdm-mini-label">수집 샘플</div>
                                <div class="wdm-mini-value">100</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
