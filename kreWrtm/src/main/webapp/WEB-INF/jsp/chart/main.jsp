<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>무선장치 관리시스템 - 대시보드</title>
    <jsp:include page="../cmn/top.jsp" flush="false" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dashboard-db-ajax.css">
    <script src="<%=request.getContextPath()%>/js/chartJS/chart.min.js"></script>
</head>
<body class="open">
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar navbar-expand-sm navbar-default"><ul class="menu-inner"></ul></nav>
    </aside>

    <div id="container" class="container-wrap" style="margin-top: 0px;">
        <div id="header" class="header-wrap"></div>
        <div id="contents" class="contents-wrap">
            <div id="work" class="work-wrap dashboard-work">
                <div id="contents_box" class="contents_box dashboard-page dashboard-db-page">
                    <div id="dashboardError" class="dashboard-error" style="display:none;"></div>

                    <section class="kpi-grid">
                        <article class="kpi-card"><div class="kpi-label">전체 수신 단말</div><div class="kpi-value"><span id="kpiTotalDeviceCnt">0</span><span>대</span></div><div class="kpi-desc">마지막 수신: <span id="kpiLastRcvDt">-</span></div></article>
                        <article class="kpi-card"><div class="kpi-label">LTE-R 비율</div><div class="kpi-value"><span id="kpiLteRatio">0</span><span>%</span></div><div class="kpi-desc">CurrentRadioType 기준</div></article>
                        <article class="kpi-card"><div class="kpi-label">평균 RSRP</div><div class="kpi-value"><span id="kpiAvgRsrp">0</span><span>dBm</span></div><div class="kpi-desc">0에 가까울수록 양호</div></article>
                        <article class="kpi-card"><div class="kpi-label">평균 RSRQ</div><div class="kpi-value"><span id="kpiAvgRsrq">0</span><span>dB</span></div><div class="kpi-desc">수신품질 평균값</div></article>
                        <article class="kpi-card warning"><div class="kpi-label">주의 이상 단말</div><div class="kpi-value"><span id="kpiCautionDeviceCnt">0</span><span>대</span></div><div class="kpi-desc">RSRP 기준 임계치 후보</div></article>
                    </section>

                    <section class="dashboard-grid">
                        <article class="dash-card trend-card"><div class="card-header"><span class="bar"></span><strong>최근 12분 수신 데이터</strong></div><div class="chart-box chart-line"><canvas id="receiveTrendChart"></canvas></div></article>

                        <article class="dash-card radio-card">
                            <div class="card-header"><span class="bar"></span><strong>무선망 분포</strong><em>CurrentRadioType 기준</em></div>
                            <div class="radio-layout"><div class="chart-box donut-box"><canvas id="radioTypeChart"></canvas></div>
                                <div class="radio-summary">
                                    <div class="radio-row"><div><strong>LTE-R</strong><span id="lteRatioText">0%</span></div><div class="progress"><i id="lteRatioBar" style="width:0%"></i></div></div>
                                    <div class="radio-row"><div><strong>VHF</strong><span id="vhfRatioText">0%</span></div><div class="progress orange"><i id="vhfRatioBar" style="width:0%"></i></div></div>
                                    <div class="radio-row"><div><strong>자동전환 사용</strong><span id="autoSwitchRatioText">0%</span></div><div class="progress blue"><i id="autoSwitchRatioBar" style="width:0%"></i></div></div>
                                </div>
                            </div>
                        </article>

                        <article class="dash-card radar-card">
                            <div class="card-header"><span class="bar"></span><strong>RSRP 상태 분포</strong><em>전체 <span id="rsrpTotalText">0</span>대 기준</em></div>
                            <div class="radar-layout"><div class="chart-box radar-box"><canvas id="rsrpRadarChart"></canvas></div><div id="rsrpStatusSummary" class="status-summary"></div></div>
                        </article>

                        <article class="dash-card table-card">
                            <div class="card-header"><span class="bar"></span><strong>tbl_receive_data 주요 필드</strong><em>Cell ID 제외</em></div>
                            <div class="table-wrap"><table><thead><tr><th>VoLTE 번호</th><th>편성번호</th><th>무선망</th><th>RSRP</th><th>RSRQ</th><th>수신시각</th><th>상태</th></tr></thead><tbody id="receiveTableBody"><tr><td colspan="7">데이터 조회 중입니다.</td></tr></tbody></table></div>
                        </article>
                    </section>
                </div>
            </div>
        </div>
    </div>

<script>
(function () {
    var contextPath = "${pageContext.request.contextPath}";
    var receiveTrendChart = null;
    var radioTypeChart = null;
    var rsrpRadarChart = null;
    var commonFont = "'Malgun Gothic', 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif";

    $(document).ready(function () {
        loadDashboardData();
    });

    function loadDashboardData() {
        $.ajax({
            url: contextPath + "/chart/dashboardData.ajax",
            type: "POST",
            dataType: "json",
            cache: false,
            success: function (res) {
                if (!res || res.result !== "success") {
                    showError(res && res.message ? res.message : "대시보드 데이터 조회에 실패했습니다.");
                    return;
                }
                bindDashboard(res.dashboardData || {});
            },
            error: function (xhr, status, err) {
                showError("/chart/dashboardData.ajax 호출 실패: " + status);
                console.log(xhr, err);
            }
        });
    }

    function bindDashboard(data) {
        var kpi = data.kpi || {};
        var trendList = data.trendList || [];
        var radioList = data.radioList || [];
        var rsrpStatusList = data.rsrpStatusList || [];
        var receiveList = data.receiveList || [];

        setText("kpiTotalDeviceCnt", n(kpi.totalDeviceCnt));
        setText("kpiLastRcvDt", v(kpi.lastRcvDt, "-"));
        setText("kpiLteRatio", n(kpi.lteRatio));
        setText("kpiAvgRsrp", v(kpi.avgRsrp, "0"));
        setText("kpiAvgRsrq", v(kpi.avgRsrq, "0"));
        setText("kpiCautionDeviceCnt", n(kpi.cautionDeviceCnt));
        setText("lteRatioText", n(kpi.lteRatio) + "%");
        setText("vhfRatioText", n(kpi.vhfRatio) + "%");
        setText("autoSwitchRatioText", n(kpi.autoSwitchRatio) + "%");
        setText("rsrpTotalText", n(kpi.totalDeviceCnt));
        setWidth("lteRatioBar", n(kpi.lteRatio));
        setWidth("vhfRatioBar", n(kpi.vhfRatio));
        setWidth("autoSwitchRatioBar", n(kpi.autoSwitchRatio));

        drawTrendChart(trendList);
        drawRadioChart(radioList);
        drawRsrpRadarChart(rsrpStatusList);
        drawRsrpStatusSummary(rsrpStatusList);
        drawReceiveTable(receiveList);
    }

    function drawTrendChart(list) {
        var labels = list.map(function (r) { return v(r.label, ""); });
        var total = list.map(function (r) { return n(r.totalCnt); });
        var lte = list.map(function (r) { return n(r.lteCnt); });
        var vhf = list.map(function (r) { return n(r.vhfCnt); });
        if (receiveTrendChart) receiveTrendChart.destroy();
        receiveTrendChart = new Chart(document.getElementById("receiveTrendChart"), {
            type: "line",
            data: { labels: labels, datasets: [
                { label: "전체 수신", data: total, borderWidth: 2, tension: 0.35, fill: true, backgroundColor: "rgba(24,136,218,0.16)", borderColor: "#1688da", pointRadius: 2.5 },
                { label: "LTE-R", data: lte, borderWidth: 2, tension: 0.35, borderColor: "#20b872", pointRadius: 2.5 },
                { label: "VHF", data: vhf, borderWidth: 2, tension: 0.35, borderColor: "#ff9f1a", pointRadius: 2.5 }
            ]},
            options: chartLineOptions()
        });
    }

    function drawRadioChart(list) {
        var labels = list.map(function (r) { return v(r.radioType, "기타"); });
        var data = list.map(function (r) { return n(r.cnt); });
        if (radioTypeChart) radioTypeChart.destroy();
        radioTypeChart = new Chart(document.getElementById("radioTypeChart"), {
            type: "doughnut",
            data: { labels: labels, datasets: [{ data: data, backgroundColor: ["#20b872", "#ff9f1a", "#1688da"], borderWidth: 0, hoverOffset: 2 }] },
            options: { maintainAspectRatio: false, responsive: true, cutout: "54%", plugins: { legend: { display: false } } },
            plugins: [{ id: "centerText", afterDraw: function(chart) { var ctx = chart.ctx; var x = chart.chartArea.left + (chart.chartArea.right-chart.chartArea.left)/2; var y = chart.chartArea.top + (chart.chartArea.bottom-chart.chartArea.top)/2; ctx.save(); ctx.font = "800 19px " + commonFont; ctx.fillStyle = "#111f30"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText("무선망", x, y); ctx.restore(); } }]
        });
    }

    function drawRsrpRadarChart(list) {
        var labels = list.map(function (r) { return v(r.status, ""); });
        var data = list.map(function (r) { return n(r.cnt); });
        var maxVal = Math.max.apply(null, data.concat([10]));
        var scaleMax = Math.ceil(maxVal / 10) * 10;
        if (rsrpRadarChart) rsrpRadarChart.destroy();
        rsrpRadarChart = new Chart(document.getElementById("rsrpRadarChart"), {
            type: "radar",
            data: { labels: labels, datasets: [{ label: "장비 수", data: data, fill: true, backgroundColor: "rgba(47,128,237,0.20)", borderColor: "#2f80ed", pointBackgroundColor: "#fff", pointBorderColor: "#2f80ed", pointBorderWidth: 3, pointRadius: 4, borderWidth: 3 }] },
            options: { maintainAspectRatio: false, responsive: true, plugins: { legend: { display: false } }, layout: { padding: { top: 8, right: 8, bottom: 8, left: 8 } }, scales: { r: { min: 0, max: scaleMax, ticks: { stepSize: Math.max(1, Math.ceil(scaleMax / 4)), backdropColor: "transparent", font: { size: 9 } }, grid: { color: "rgba(83,100,122,0.22)" }, angleLines: { color: "rgba(83,100,122,0.22)" }, pointLabels: { font: { size: 11, weight: "bold" }, color: "#34465d", padding: 4 } } } }
        });
    }

    function drawRsrpStatusSummary(list) {
        var html = "";
        for (var i=0; i<list.length; i++) {
            var r = list[i];
            html += '<div class="status-row ' + esc(v(r.statusClass, "")) + '">';
            html += '<b>' + esc(v(r.status, "")) + '</b>';
            html += '<span>' + n(r.cnt) + '대</span>';
            html += '<small>' + esc(v(r.rangeText, "")) + '</small>';
            html += '</div>';
        }
        $("#rsrpStatusSummary").html(html || '<div class="status-empty">RSRP 데이터 없음</div>');
    }

    function drawReceiveTable(list) {
        var html = "";
        for (var i=0; i<list.length; i++) {
            var r = list[i];
            var radio = v(r.currentRadioType, "-");
            var chipClass = radio === "LTE-R" ? "lter" : "vhf";
            html += "<tr>";
            html += "<td>" + esc(v(r.volteNum, "")) + "</td>";
            html += "<td>" + esc(v(r.carNum, "")) + "</td>";
            html += '<td><span class="chip ' + chipClass + '">' + esc(radio) + '</span></td>';
            html += "<td>" + esc(v(r.rsrp, "")) + "</td>";
            html += "<td>" + esc(v(r.rsrq, "")) + "</td>";
            html += "<td>" + esc(v(r.rcvTime, "")) + "</td>";
            html += '<td><span class="state ' + esc(v(r.statusClass, "")) + '">' + esc(v(r.status, "")) + '</span></td>';
            html += "</tr>";
        }
        $("#receiveTableBody").html(html || '<tr><td colspan="7">수신 데이터가 없습니다.</td></tr>');
    }

    function chartLineOptions() {
        return { maintainAspectRatio: false, responsive: true, plugins: { legend: { position: "bottom", labels: { boxWidth: 10, font: { size: 12, weight: "bold" } } }, tooltip: { mode: "index", intersect: false } }, scales: { x: { grid: { color: "rgba(83,100,122,0.10)" }, ticks: { font: { size: 11 } } }, y: { beginAtZero: true, grid: { color: "rgba(83,100,122,0.22)", borderDash: [3,3] }, ticks: { font: { size: 11 } } } } };
    }

    function setText(id, val) { $("#" + id).text(val); }
    function setWidth(id, val) { $("#" + id).css("width", Math.max(0, Math.min(100, Number(val) || 0)) + "%"); }
    function v(val, def) { return (val === undefined || val === null || val === "") ? def : val; }
    function n(val) { var num = Number(v(val, 0)); return isNaN(num) ? 0 : num; }
    function esc(str) { return String(str == null ? "" : str).replace(/[&<>'"]/g, function(c) { return ({"&":"&amp;","<":"&lt;",">":"&gt;","'":"&#39;",'"':"&quot;"})[c]; }); }
    function showError(msg) { $("#dashboardError").text(msg).show(); }
})();
</script>
</body>
</html>
