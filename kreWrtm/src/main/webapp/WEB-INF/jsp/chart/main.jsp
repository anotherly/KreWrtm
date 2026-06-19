<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>무선장치 관리시스템 - 대시보드</title>
    <jsp:include page="../cmn/top.jsp" flush="false" />
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/dashboard-db-ajax.css">
    <script src="<%=request.getContextPath()%>/js/chartJS/chart.umd.readable.js"></script>
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
                        <article class="kpi-card"><div class="kpi-label">전체 관리 단말</div><div class="kpi-value"><span id="kpiTotalDeviceCnt">0</span><span>대</span></div><div class="kpi-desc">장치 관리 등록 단말 기준</div></article>
                        <article class="kpi-card"><div class="kpi-label">현재 데이터 수신 단말</div><div class="kpi-value"><span id="kpiReceiveDeviceCnt">0</span><span>대</span></div><div class="kpi-desc">마지막 수신: <span id="kpiLastRcvDt">-</span></div></article>
                        <article id="kpiAvgRsrpCard" class="kpi-card kpi-status-normal"><div class="kpi-label">평균 RSRP</div><div class="kpi-value"><span id="kpiAvgRsrp">0</span><span>dBm</span></div><div class="kpi-desc">0에 가까울수록 양호</div></article>
                        <article id="kpiAvgRsrqCard" class="kpi-card kpi-status-normal"><div class="kpi-label">평균 RSRQ</div><div class="kpi-value"><span id="kpiAvgRsrq">0</span><span>dB</span></div><div class="kpi-desc">수신품질 평균값</div></article>
                        <article id="kpiCautionDeviceCard" class="kpi-card kpi-status-normal"><div class="kpi-label">주의 이상 단말</div><div class="kpi-value"><span id="kpiCautionDeviceCnt">0</span><span>대</span></div><div class="kpi-desc">RSRP/RSRQ 기준 임계치 후보</div></article>
                    </section>

                    <section class="dashboard-grid">
                        <article class="dash-card trend-card"><div class="card-header"><span class="bar"></span><strong>최근 12분 수신 데이터</strong></div><div class="chart-box chart-line"><canvas id="receiveTrendChart"></canvas></div></article>

                        <article class="dash-card radio-card">
                            <div class="card-header"><span class="bar"></span><strong>무선망 분포</strong><em></em></div>
                            <div class="radio-layout"><div class="chart-box donut-box"><canvas id="radioTypeChart"></canvas></div>
                                <div class="radio-summary">
                                    <div class="radio-row"><div><strong>LTE-R</strong><span id="lteRatioText">0%</span></div><div class="progress"><i id="lteRatioBar" style="width:0%"></i></div></div>
                                    <div class="radio-row"><div><strong>VHF</strong><span id="vhfRatioText">0%</span></div><div class="progress orange"><i id="vhfRatioBar" style="width:0%"></i></div></div>
                                    <div class="radio-row"><div><strong>자동전환 사용</strong><span id="autoSwitchRatioText">0%</span></div><div class="progress blue"><i id="autoSwitchRatioBar" style="width:0%"></i></div></div>
                                </div>
                            </div>
                        </article>

                        <article class="dash-card radar-card">
                            <div class="card-header"><span class="bar"></span><strong>RSRQ/RSRP 상태 분포</strong><em>전체 <span id="rsrpTotalText">0</span>대 기준</em></div>
                            <div class="radar-layout split-radar-layout">
                                <div class="radar-side radar-side-left">
                                    <div class="metric-title" style="color: #2f80ed !important;">RSRQ</div>
                                    <div id="rsrqStatusSummary" class="status-summary metric-status-summary"></div>
                                </div>
                                <div class="chart-box radar-box"><canvas id="rsrpRadarChart"></canvas></div>
                                <div class="radar-side radar-side-right">
                                    <div class="metric-title" style="color: #ff8f1a !important;">RSRP</div>
                                    <div id="rsrpStatusSummary" class="status-summary metric-status-summary"></div>
                                </div>
                            </div>
                        </article>

                        <article class="dash-card table-card">
                            <div class="card-header"><span class="bar"></span><strong>단말기별 데이터 수신 상태</strong><button type="button" id="lastDataMoreBtn" class="more-btn">▶ more</button></div>
                            <div class="table-wrap"><table id="lastDataTable"><thead><tr><th>VoLTE 번호</th><th>편성번호</th><th>무선망</th><th class="sort-th" data-sort-key="rsrp" data-default-dir="asc">RSRP</th><th>RSRP 상태</th><th class="sort-th" data-sort-key="rsrq" data-default-dir="asc">RSRQ</th><th>RSRQ 상태</th><th class="sort-th" data-sort-key="rcvDtSort" data-default-dir="desc">수신시각</th></tr></thead><tbody id="receiveTableBody"><tr><td colspan="8">데이터 조회 중입니다.</td></tr></tbody></table></div>
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
    var lastDataList = [];
    var tableSortState = { key: null, dir: null };

    /*
     * 4K + Windows 배율 150% 환경 보정
     * - 200% 환경에서는 브라우저 CSS viewport가 약 1920x1080 수준이라 기존 크기가 적절함
     * - 150% 환경에서는 viewport가 약 2560x1440 수준으로 넓어져 차트 내부 글씨가 작아 보임
     * - CSS media query와 같은 기준으로 Chart.js 내부 font/point/cutout 값을 키움
     */
    function isWideDashboardMode() {
        return window.matchMedia && window.matchMedia("(min-width: 2200px) and (min-height: 1100px)").matches;
    }

    function chartUiSize() {
        if (isWideDashboardMode()) {
            return {
                legend: 16,
                tick: 15,
                radarTick: 13,
                radarPointLabel: 17,
                radarPointRadius: 6,
                radarBorderWidth: 4,
                centerText: 27,
                legendBox: 14
            };
        }
        return {
            legend: 12,
            tick: 11,
            radarTick: 10,
            radarPointLabel: 13,
            radarPointRadius: 5,
            radarBorderWidth: 3,
            centerText: 19,
            legendBox: 10
        };
    }

    $(document).ready(function () {
        bindTableEvents();
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
        var rsrqStatusList = data.rsrqStatusList || [];
        var receiveList = data.receiveList || [];
        lastDataList = receiveList.slice();
        tableSortState = { key: null, dir: null };

        setText("kpiTotalDeviceCnt", n(kpi.manageDeviceCnt));
        setText("kpiLastRcvDt", v(kpi.lastRcvDt, "-"));
        setText("kpiReceiveDeviceCnt", n(kpi.totalDeviceCnt));
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

        updateKpiStatusColors(kpi);

        drawTrendChart(trendList);
        drawRadioChart(radioList);
        drawRsrpRadarChart(rsrpStatusList, rsrqStatusList);
        drawRsrqRsrpStatusSummary(rsrpStatusList, rsrqStatusList);
        drawReceiveTable(lastDataList);
        updateSortHeader();
    }

    function updateKpiStatusColors(kpi) {
        var avgRsrp = Number(kpi.avgRsrp);
        var avgRsrq = Number(kpi.avgRsrq);
        var totalDeviceCnt = n(kpi.totalDeviceCnt);
        var cautionDeviceCnt = n(kpi.cautionDeviceCnt);
        var cautionRatio = totalDeviceCnt > 0 ? (cautionDeviceCnt / totalDeviceCnt) * 100 : 0;

        setKpiStatusClass("kpiAvgRsrpCard", getRsrpStatusClass(avgRsrp));
        setKpiStatusClass("kpiAvgRsrqCard", getRsrqStatusClass(avgRsrq));
        setKpiStatusClass("kpiCautionDeviceCard", getCautionRatioStatusClass(cautionRatio));
    }

    function getRsrpStatusClass(value) {
        if (value < -110) return "critical";
        if (value < -100) return "warning";
        if (value < -90) return "caution";
        return "normal";
    }

    function getRsrqStatusClass(value) {
        if (value < -18) return "critical";
        if (value < -15) return "warning";
        if (value < -10) return "caution";
        return "normal";
    }

    function getCautionRatioStatusClass(ratio) {
        if (ratio >= 75) return "critical";
        if (ratio >= 50) return "warning";
        if (ratio >= 25) return "caution";
        return "normal";
    }

    function setKpiStatusClass(id, statusClass) {
        var $card = $("#" + id);
        $card.removeClass("kpi-status-normal kpi-status-caution kpi-status-warning kpi-status-critical")
             .addClass("kpi-status-" + statusClass);
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
            options: { maintainAspectRatio: false, responsive: true, cutout: isWideDashboardMode() ? "58%" : "54%", plugins: { legend: { display: false } } },
            plugins: [{ id: "centerText", afterDraw: function(chart) { var ui = chartUiSize(); var ctx = chart.ctx; var x = chart.chartArea.left + (chart.chartArea.right-chart.chartArea.left)/2; var y = chart.chartArea.top + (chart.chartArea.bottom-chart.chartArea.top)/2; ctx.save(); ctx.font = "800 " + ui.centerText + "px " + commonFont; ctx.fillStyle = "#111f30"; ctx.textAlign = "center"; ctx.textBaseline = "middle"; ctx.fillText("무선망", x, y); ctx.restore(); } }]
        });
    }

    function drawRsrpRadarChart(rsrpList, rsrqList) {
        var labels = ["정상", "주의", "경고", "심각"];
        var rsrpMap = listToStatusMap(rsrpList);
        var rsrqMap = listToStatusMap(rsrqList);
        var rsrpData = labels.map(function (label) { return n(rsrpMap[label]); });
        var rsrqData = labels.map(function (label) { return n(rsrqMap[label]); });
        var maxVal = Math.max.apply(null, rsrpData.concat(rsrqData).concat([10]));
        var scaleMax = Math.ceil(maxVal / 10) * 10;

        if (rsrpRadarChart) rsrpRadarChart.destroy();
        rsrpRadarChart = new Chart(document.getElementById("rsrpRadarChart"), {
            type: "radar",
            data: {
                labels: labels,
                datasets: [
                	{
                        label: "RSRQ",
                        data: rsrqData,
                        fill: true,
                        backgroundColor: "rgba(47,128,237,0.18)",
                        borderColor: "#2f80ed",
                        pointBackgroundColor: "#fff",
                        pointBorderColor: "#2f80ed",
                        pointBorderWidth: chartUiSize().radarBorderWidth,
                        pointRadius: chartUiSize().radarPointRadius,
                        borderWidth: chartUiSize().radarBorderWidth
                    },
                    {
                        label: "RSRP",
                        data: rsrpData,
                        fill: true,
                        backgroundColor: "rgba(255,159,26,0.16)",
                        borderColor: "#ff9f1a",
                        pointBackgroundColor: "#fff",
                        pointBorderColor: "#ff9f1a",
                        pointBorderWidth: chartUiSize().radarBorderWidth,
                        pointRadius: chartUiSize().radarPointRadius,
                        borderWidth: chartUiSize().radarBorderWidth
                    }
                ]
            },
            options: {
                maintainAspectRatio: false,
                responsive: true,
                plugins: {
                    legend: {
                        display: true,
                        position: "bottom",
                        labels: { boxWidth: chartUiSize().legendBox, font: { size: chartUiSize().legend, weight: "bold" } }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (ctx) { return ctx.dataset.label + ": " + ctx.raw + "대"; }
                        }
                    }
                },
                layout: { padding: { top: 0, right: 0, bottom: 0, left: 0 } },
                scales: {
                    r: {
                        min: 0,
                        max: scaleMax,
                        ticks: { stepSize: Math.max(1, Math.ceil(scaleMax / 4)), backdropColor: "transparent", font: { size: chartUiSize().radarTick } },
                        grid: { color: "rgba(83,100,122,0.22)" },
                        angleLines: { color: "rgba(83,100,122,0.22)" },
                        pointLabels: { font: { size: chartUiSize().radarPointLabel, weight: "bold" }, color: "#34465d", padding: isWideDashboardMode() ? 6 : 3 }
                    }
                }
            }
        });
    }

    function drawRsrqRsrpStatusSummary(rsrpList, rsrqList) {
        var labels = ["정상", "주의", "경고", "심각"];
        var classes = {"정상":"normal", "주의":"caution", "경고":"warning", "심각":"critical"};

        /*
         * 상태 기준
         * - RSRP: 수신 전력. 0에 가까울수록 양호합니다.
         * - RSRQ: 수신 품질. 0에 가까울수록 양호합니다.
         */
        var rsrpRange = {
            "정상": "RSRP ≥ -90 dBm",
            "주의": "-100 ≤ RSRP < -90 dBm",
            "경고": "-110 ≤ RSRP < -100 dBm",
            "심각": "RSRP < -110 dBm"
        };
        var rsrqRange = {
            "정상": "RSRQ ≥ -10 dB",
            "주의": "-15 ≤ RSRQ < -10 dB",
            "경고": "-18 ≤ RSRQ < -15 dB",
            "심각": "RSRQ < -18 dB"
        };

        var rsrpMap = listToStatusMap(rsrpList);
        var rsrqMap = listToStatusMap(rsrqList);

        var rsrqHtml = "";
        var rsrpHtml = "";

        for (var i=0; i<labels.length; i++) {
            var label = labels[i];
            rsrqHtml += makeStatusSummaryRow(classes[label], label, rsrqRange[label], n(rsrqMap[label]));
            rsrpHtml += makeStatusSummaryRow(classes[label], label, rsrpRange[label], n(rsrpMap[label]));
        }

        $("#rsrqStatusSummary").html(rsrqHtml || '<div class="status-empty">RSRQ 상태 데이터 없음</div>');
        $("#rsrpStatusSummary").html(rsrpHtml || '<div class="status-empty">RSRP 상태 데이터 없음</div>');
    }

    function makeStatusSummaryRow(className, label, rangeText, count) {
        var html = "";
        html += '<div class="status-row ' + className + '">';
        html += '    <div class="status-label-box">';
        html += '        <b>' + esc(label) + '</b>';
        html += '        <small>' + esc(rangeText) + '</small>';
        html += '    </div>';
        html += '    <span>' + n(count) + '대</span>';
        html += '</div>';
        return html;
    }

    function bindTableEvents() {
        $(document).on("click", "#lastDataMoreBtn", function () {
            loadAllLastDataList();
        });

        $(document).on("click", "#lastDataTable th.sort-th", function () {
            var key = $(this).data("sortKey");
            var defaultDir = $(this).data("defaultDir") || "asc";
            if (!key) return;

            if (tableSortState.key === key) {
                tableSortState.dir = tableSortState.dir === "asc" ? "desc" : "asc";
            } else {
                tableSortState.key = key;
                tableSortState.dir = defaultDir;
            }

            drawReceiveTable(sortLastDataList(lastDataList));
            updateSortHeader();
        });
    }

    function loadAllLastDataList() {
        var $btn = $("#lastDataMoreBtn");
        if ($btn.data("loading") === true) return;

        $btn.data("loading", true).text("조회중...");

        $.ajax({
            url: contextPath + "/chart/dashboardLastDataList.ajax",
            type: "POST",
            dataType: "json",
            cache: false,
            success: function (res) {
                if (!res || res.result !== "success") {
                    showError(res && res.message ? res.message : "최신 수신 전체 목록 조회에 실패했습니다.");
                    return;
                }

                lastDataList = res.receiveList || [];
                drawReceiveTable(sortLastDataList(lastDataList));
                updateSortHeader();
                $btn.text("전체 " + lastDataList.length + "건");
            },
            error: function (xhr, status, err) {
                showError("/chart/dashboardLastDataList.ajax 호출 실패: " + status);
                console.log(xhr, err);
            },
            complete: function () {
                $btn.data("loading", false);
                if ($btn.text() === "조회중...") {
                    $btn.text("▶ more");
                }
            }
        });
    }

    function sortLastDataList(list) {
        var arr = (list || []).slice();
        if (!tableSortState.key) return arr;

        arr.sort(function (a, b) {
            var key = tableSortState.key;
            var dir = tableSortState.dir === "desc" ? -1 : 1;
            var av;
            var bv;

            if (key === "rsrp" || key === "rsrq") {
                av = toNumberForSort(getVal(a, key + "Num", getVal(a, key, null)));
                bv = toNumberForSort(getVal(b, key + "Num", getVal(b, key, null)));
            } else if (key === "rcvDtSort") {
                av = String(getVal(a, "rcvDtSort", getVal(a, "rcvTime", "")) || "");
                bv = String(getVal(b, "rcvDtSort", getVal(b, "rcvTime", "")) || "");
            } else {
                av = String(getVal(a, key, "") || "");
                bv = String(getVal(b, key, "") || "");
            }

            if (av === bv) return 0;
            return av > bv ? dir : -dir;
        });

        return arr;
    }

    function toNumberForSort(val) {
        if (val === undefined || val === null || val === "") return 999999;
        var num = Number(String(val).replace(/[^0-9\-\.]/g, ""));
        return isNaN(num) ? 999999 : num;
    }

    function updateSortHeader() {
        $("#lastDataTable th.sort-th").removeClass("sort-asc sort-desc");
        if (!tableSortState.key) return;
        $('#lastDataTable th.sort-th[data-sort-key="' + tableSortState.key + '"]').addClass(tableSortState.dir === "desc" ? "sort-desc" : "sort-asc");
    }

    function drawReceiveTable(list) {
        var html = "";
        for (var i=0; i<list.length; i++) {
            var r = list[i];
            var radio = v(getVal(r, "currentRadioType", "-"), "-");
            var chipClass = radio === "LTE-R" ? "lter" : "vhf";
            html += "<tr>";
            html += "<td>" + esc(v(getVal(r, "volteNum", ""), "")) + "</td>";
            html += "<td>" + esc(v(getVal(r, "carNum", ""), "")) + "</td>";
            html += '<td><span class="chip ' + chipClass + '">' + esc(radio) + '</span></td>';
            html += "<td>" + esc(v(getVal(r, "rsrp", ""), "")) + "</td>";
            html += '<td><span class="state ' + esc(v(getVal(r, "rsrpStatusClass", ""), "")) + '">' + esc(v(getVal(r, "rsrpStatus", ""), "")) + '</span></td>';
            html += "<td>" + esc(v(getVal(r, "rsrq", ""), "")) + "</td>";
            html += '<td><span class="state ' + esc(v(getVal(r, "rsrqStatusClass", ""), "")) + '">' + esc(v(getVal(r, "rsrqStatus", ""), "")) + '</span></td>';
            html += "<td>" + esc(v(getVal(r, "rcvTime", ""), "")) + "</td>";
            html += "</tr>";
        }
        $("#receiveTableBody").html(html || '<tr><td colspan="8">수신 데이터가 없습니다.</td></tr>');
    }

    function listToStatusMap(list) {
        var map = {};
        for (var i=0; i<list.length; i++) {
            var status = getVal(list[i], "status", "");
            var cnt = getVal(list[i], "cnt", 0);
            map[v(status, "")] = n(cnt);
        }
        return map;
    }

    function getVal(row, key, def) {
        if (!row || !key) return def;
        if (row[key] !== undefined && row[key] !== null) return row[key];
        var upperKey = key.toUpperCase();
        if (row[upperKey] !== undefined && row[upperKey] !== null) return row[upperKey];
        for (var k in row) {
            if (row.hasOwnProperty(k) && String(k).toLowerCase() === String(key).toLowerCase()) {
                return row[k];
            }
        }
        return def;
    }

    function chartLineOptions() {
        var ui = chartUiSize();
        return {
            maintainAspectRatio: false,
            responsive: true,
            plugins: {
                legend: {
                    position: "bottom",
                    labels: {
                        boxWidth: ui.legendBox,
                        padding: isWideDashboardMode() ? 18 : 10,
                        font: { size: ui.legend, weight: "bold" }
                    }
                },
                tooltip: { mode: "index", intersect: false }
            },
            scales: {
                x: {
                    grid: { color: "rgba(83,100,122,0.10)" },
                    ticks: { font: { size: ui.tick } }
                },
                y: {
                    beginAtZero: true,
                    grid: { color: "rgba(83,100,122,0.22)", borderDash: [3,3] },
                    ticks: { font: { size: ui.tick } }
                }
            }
        };
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
