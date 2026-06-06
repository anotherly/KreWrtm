<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>무선장치 관리시스템 - 대시보드 프로토타입</title>

    <jsp:include page="../cmn/top.jsp" flush="false" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard-prototype-v3.css">

    <%--
        Chart.js 레이더 차트 사용.
        운영망이 외부 CDN 차단 환경이면 chart.umd.min.js를 내려받아
        /js/chart/chart.umd.min.js 같은 내부 경로로 변경하면 됩니다.
    --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.7/dist/chart.umd.min.js"></script>
</head>

<body class="open dashboard-v5-body">
    <!-- lnb Start -->
    <aside id="lnb" class="lnb">
        <a class="lnb-control" title="메뉴 펼침/닫침"><span class="menu-toggle">메뉴 펼침/닫침</span></a>
        <nav class="navbar navbar-expand-sm navbar-default">
            <ul class="menu-inner"></ul>
        </nav>
    </aside>
    <!-- lnb End -->

    <!-- container Start -->
    <div id="container" class="container-wrap" style="margin-top: 0px;">
        <!-- header Start -->
        <div id="header" class="header-wrap"></div>
        <!-- header End -->

        <!-- contents Start -->
        <div id="contents" class="contents-wrap">
            <div id="work" class="work-wrap dashboard-work">
                <div id="contents_box" class="contents_box dashboard-page">
<%-- 상단 소개 문구와 금일 기준/새로고침은 요청에 따라 제거/주석 처리
            <div class="dashboard-hero">
                <div>
                    <span class="eyebrow">WIRELESS DEVICE MANAGEMENT</span>
                    <h1>무선장치 통합 대시보드</h1>
                    <p>수신 데이터, 무선망 상태, 단말 품질, 장애 징후를 한 화면에서 확인하는 프로토타입 화면입니다.</p>
                </div>
                <div class="dashboard-actions">
                    <select>
                        <option>금일 기준</option>
                    </select>
                    <button type="button">새로고침</button>
                </div>
            </div>
            --%>

            <section class="kpi-grid">
                <article class="kpi-card">
                    <div class="kpi-label">전체 수신 단말</div>
                    <div class="kpi-value">100<span>대</span></div>
                    <div class="kpi-desc">마지막 수신: 2026-06-05 22:39:15</div>
                </article>

                <article class="kpi-card">
                    <div class="kpi-label">LTE-R 비율</div>
                    <div class="kpi-value">51<span>%</span></div>
                    <div class="kpi-desc">CurrentRadioType 기준</div>
                </article>

                <article class="kpi-card">
                    <div class="kpi-label">평균 RSRP</div>
                    <div class="kpi-value">-78.5<span>dBm</span></div>
                    <div class="kpi-desc">0에 가까울수록 양호</div>
                </article>

                <article class="kpi-card">
                    <div class="kpi-label">평균 RSRQ</div>
                    <div class="kpi-value">-12<span>dB</span></div>
                    <div class="kpi-desc">수신품질 평균값</div>
                </article>

                <article class="kpi-card warning">
                    <div class="kpi-label">주의 이상 단말</div>
                    <div class="kpi-value">9<span>대</span></div>
                    <div class="kpi-desc">RSRP/RSRQ 기준 임계치 후보</div>
                </article>
            </section>

            <section class="dashboard-grid">
                <article class="dash-card trend-card">
                    <div class="card-header">
                        <span class="bar"></span>
                        <strong>최근 12분 프로토타입 데이터</strong>
                    </div>
                    <div class="chart-box chart-line">
                        <canvas id="receiveTrendChart"></canvas>
                    </div>
                </article>

                <article class="dash-card radio-card">
                    <div class="card-header">
                        <span class="bar"></span>
                        <strong>무선망 분포</strong>
                        <em>CurrentRadioType 기준</em>
                    </div>
                    <div class="radio-layout">
                        <div class="chart-box donut-box">
                            <canvas id="radioTypeChart"></canvas>
                        </div>
                        <div class="radio-summary">
                            <div class="radio-row">
                                <div><strong>LTE-R</strong><span>51%</span></div>
                                <div class="progress"><i style="width:51%"></i></div>
                            </div>
                            <div class="radio-row">
                                <div><strong>VHF</strong><span>49%</span></div>
                                <div class="progress orange"><i style="width:49%"></i></div>
                            </div>
                            <div class="radio-row">
                                <div><strong>자동전환 사용</strong><span>47%</span></div>
                                <div class="progress blue"><i style="width:47%"></i></div>
                            </div>
                        </div>
                    </div>
                </article>

                <article class="dash-card radar-card">
                    <div class="card-header">
                        <span class="bar"></span>
                        <strong>RSRP 상태 분포</strong>
                        <em>전체 340대 기준</em>
                    </div>
                    <div class="radar-layout">
                        <div class="chart-box radar-box">
                            <canvas id="rsrpRadarChart"></canvas>
                        </div>
                        <div class="status-summary">
                            <div class="status-row normal"><b>정상</b><span>100대</span><small>RSRP ≥ -90</small></div>
                            <div class="status-row caution"><b>주의</b><span>120대</span><small>-100 ≤ RSRP &lt; -90</small></div>
                            <div class="status-row warning"><b>경고</b><span>90대</span><small>-110 ≤ RSRP &lt; -100</small></div>
                            <div class="status-row critical"><b>심각</b><span>30대</span><small>RSRP &lt; -110</small></div>
                        </div>
                    </div>
                </article>

                <article class="dash-card table-card">
                    <div class="card-header">
                        <span class="bar"></span>
                        <strong>tbl_receive_data 주요 필드</strong>
                        <em>Cell ID 제외</em>
                    </div>
                    <div class="table-wrap">
                        <table>
                            <thead>
                                <tr>
                                    <th>VoLTE 번호</th>
                                    <th>편성번호</th>
                                    <th>무선망</th>
                                    <th>RSRP</th>
                                    <th>RSRQ</th>
                                    <th>수신시각</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>01300001348</td>
                                    <td>391348</td>
                                    <td><span class="chip vhf">VHF</span></td>
                                    <td>-91</td>
                                    <td>-14</td>
                                    <td>22:39:15</td>
                                    <td><span class="state caution">주의</span></td>
                                </tr>
                                <tr>
                                    <td>01300001106</td>
                                    <td>391106</td>
                                    <td><span class="chip lter">LTE-R</span></td>
                                    <td>-101</td>
                                    <td>-9</td>
                                    <td>22:39:15</td>
                                    <td><span class="state warning">경고</span></td>
                                </tr>
                                <tr>
                                    <td>01300001381</td>
                                    <td>391381</td>
                                    <td><span class="chip lter">LTE-R</span></td>
                                    <td>-75</td>
                                    <td>-4</td>
                                    <td>22:39:15</td>
                                    <td><span class="state normal">정상</span></td>
                                </tr>
                                <tr>
                                    <td>01300001820</td>
                                    <td>391820</td>
                                    <td><span class="chip lter">LTE-R</span></td>
                                    <td>-108</td>
                                    <td>-19</td>
                                    <td>22:39:13</td>
                                    <td><span class="state warning">경고</span></td>
                                </tr>
                                <tr>
                                    <td>01300001756</td>
                                    <td>391756</td>
                                    <td><span class="chip vhf">VHF</span></td>
                                    <td>-115</td>
                                    <td>-8</td>
                                    <td>22:39:14</td>
                                    <td><span class="state critical">심각</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </article>
            </section>
        </div>
    </div>
                </div>
            </div>
        </div>
        <!-- contents End -->
    </div>
    <!-- container End -->

<script>
(function () {
    var commonFont = "'Malgun Gothic', 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif";
    Chart.defaults.font.family = commonFont;
    Chart.defaults.color = "#40516a";

    var gridColor = "rgba(83, 100, 122, 0.22)";

    new Chart(document.getElementById("receiveTrendChart"), {
        type: "line",
        data: {
            labels: ["22:28", "22:29", "22:30", "22:31", "22:32", "22:33", "22:34", "22:35", "22:36", "22:37", "22:38", "22:39"],
            datasets: [
                {
                    label: "전체 수신",
                    data: [62, 66, 69, 74, 72, 78, 83, 88, 91, 94, 98, 100],
                    borderWidth: 2,
                    tension: 0.35,
                    fill: true,
                    backgroundColor: "rgba(24, 136, 218, 0.16)",
                    borderColor: "#1688da",
                    pointRadius: 2.5
                },
                {
                    label: "LTE-R",
                    data: [28, 30, 34, 35, 37, 39, 42, 44, 46, 48, 50, 51],
                    borderWidth: 2,
                    tension: 0.35,
                    borderColor: "#20b872",
                    pointRadius: 2.5
                },
                {
                    label: "VHF",
                    data: [34, 36, 35, 39, 35, 39, 41, 44, 45, 46, 48, 49],
                    borderWidth: 2,
                    tension: 0.35,
                    borderColor: "#ff9f1a",
                    pointRadius: 2.5
                }
            ]
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            plugins: {
                legend: { position: "bottom", labels: { boxWidth: 10, font: { size: 12, weight: "bold" } } },
                tooltip: { mode: "index", intersect: false }
            },
            scales: {
                x: { grid: { color: "rgba(83,100,122,0.10)" }, ticks: { font: { size: 11 } } },
                y: { beginAtZero: true, max: 110, grid: { color: gridColor, borderDash: [3, 3] }, ticks: { font: { size: 11 } } }
            }
        }
    });

    new Chart(document.getElementById("radioTypeChart"), {
        type: "doughnut",
        data: {
            labels: ["LTE-R", "VHF"],
            datasets: [{
                data: [51, 49],
                backgroundColor: ["#20b872", "#ff9f1a"],
                borderWidth: 0,
                hoverOffset: 2
            }]
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            cutout: "54%",
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (ctx) {
                            return ctx.label + " " + ctx.raw + "%";
                        }
                    }
                }
            }
        },
        plugins: [{
            id: "centerText",
            afterDraw: function(chart) {
                var ctx = chart.ctx;
                var x = chart.chartArea.left + (chart.chartArea.right - chart.chartArea.left) / 2;
                var y = chart.chartArea.top + (chart.chartArea.bottom - chart.chartArea.top) / 2;
                ctx.save();
                ctx.font = "800 19px " + commonFont;
                ctx.fillStyle = "#111f30";
                ctx.textAlign = "center";
                ctx.textBaseline = "middle";
                ctx.fillText("무선망", x, y);
                ctx.restore();
            }
        }]
    });

    new Chart(document.getElementById("rsrpRadarChart"), {
        type: "radar",
        data: {
            labels: ["정상", "주의", "경고", "심각"],
            datasets: [{
                label: "장비 수",
                data: [100, 120, 90, 30],
                fill: true,
                backgroundColor: "rgba(47, 128, 237, 0.20)",
                borderColor: "#2f80ed",
                pointBackgroundColor: "#ffffff",
                pointBorderColor: "#2f80ed",
                pointBorderWidth: 3,
                pointRadius: 4,
                borderWidth: 3
            }]
        },
        options: {
            maintainAspectRatio: false,
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function (ctx) {
                            return ctx.raw + "대";
                        }
                    }
                }
            },
            scales: {
                r: {
                    min: 0,
                    max: 120,
                    ticks: {
                        stepSize: 30,
                        backdropColor: "transparent",
                        font: { size: 10 }
                    },
                    grid: { color: "rgba(83,100,122,0.22)" },
                    angleLines: { color: "rgba(83,100,122,0.22)" },
                    pointLabels: {
                        font: { size: 13, weight: "bold" },
                        color: "#34465d"
                    }
                }
            }
        }
    });
})();
</script>
</body>
</html>
