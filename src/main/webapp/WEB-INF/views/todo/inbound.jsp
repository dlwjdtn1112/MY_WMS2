<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<html>
<head>
    <title>WMS 대시보드</title>
    <style>
        body {
            margin: 0;
            font-family: "Noto Sans KR", sans-serif;
            background: #f4f9ff;
            display: flex;
        }
        h1 {
            margin: 0;
            font-size: 1.2rem;
            font-weight: 600;
            color: #0053a0;
        }

        /* 사이드바 */
        .sidebar {
            width: 160px;
            background-color: #0053a0;
            color: white;
            height: 100vh;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.05);
        }

        .sidebar h2 {
            font-size: 1.3rem;
            margin-bottom: 30px;
        }

        .menu-btn {
            display: block;
            margin: 8px 0;
            padding: 12px;
            border-radius: 10px;
            background: white;
            color: #0053a0;
            text-decoration: none;
            text-align: center;
            font-weight: bold;
            transition: background 0.3s;
        }

        .menu-btn:hover {
            background-color: #eeeeee;
        }

        /* 우측 메인 */
        .main {
            flex: 1;
            padding: 20px 30px;
        }

        .top-bar {display: flex;               /* ✅ 추가 */
            justify-content: space-between;
            align-items: flex-start;     /* 텍스트를 위로 정렬 */
            margin-bottom: 10px;
        }

        .user-info {
            position: absolute;
            top:20px;
            right:20px;
            background: white;
            padding: 10px 14px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            font-size: 8px;
            line-height: 1.6;
            min-width: 170px;
            text-align: left;
        }

        .user-info div {
            margin-bottom: 4px;
        }

        .dashboard {
            margin-top: 30px;
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 24px 20px;
            width: 100px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
        }

        .card-title {
            font-size: 14px;
            color: #888;
            margin-bottom: 6px;
        }

        .card-value {
            font-size: 22px;
            font-weight: bold;
            color: #0053a0;
        }

        /* 입고 테이블 */
        .table-container {
            background: white;
            margin-top: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            /* ✅ 추가된 부분 */
            max-height: 320px;     /* 테이블 최대 높이 지정 */
            overflow-y: auto;      /* 스크롤 활성화 */
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background-color: #0053a0;
            color: white;
        }

        th, td {
            padding: 14px;
            text-align: center;
            font-size: 11px;
        }

        tr:nth-child(even) {
            background-color: #f2f6fb;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 9999px;
            font-size: 10px;
        }

        .approved {
            background: #e0f2ff;
            color: #0053a0;
        }

        .pending {
            background: #ffe9e6;
            color: #c62828;
        }
    </style>
</head>
<body>

<!-- 좌측 사이드바 -->
<div class="sidebar">
    <h2>👤 회원 메뉴</h2>
    <a href="/todo/inbound" class="menu-btn">입고 목록</a>
    <a href="/todo/outbound" class="menu-btn">출고 목록</a>
    <a href="/todo/inventory" class="menu-btn">재고 목록</a>
    <a href="/todo/inbound/requestForm" class="menu-btn">입고 요청</a>
    <a href="/todo/outbound/requestForm" class="menu-btn">출고 요청</a>
</div>

<!-- 메인 콘텐츠 -->
<div class="main">
    <div class="top-bar">
        <h1>📦 회원 입고 메뉴</h1>
        <div class="user-info">
            <div><strong><c:out value="${sessionScope.name}" /></strong>님 환영합니다</div>
            <div>📧 <c:out value="${sessionScope.email}" /></div>
            <div>📞 <c:out value="${sessionScope.phone}" /></div>
            <div>🏢 <c:out value="${sessionScope.company}" /></div>
            <div>🔐 <c:out value="${sessionScope.role}" /></div>

            <form action="/todo/logout" method="post" style="margin-top: 8px; text-align: right;">
                <button type="submit" style="margin-top: 6px; background: #0053a0; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 11px; cursor: pointer;">
                    로그아웃
                </button>
            </form>
        </div>
    </div>

    <!-- 카드 -->
    <div class="dashboard">
        <div class="card">
            <div class="card-title">총 입고 요청</div>
            <div class="card-value">${fn:length(dtoList1)}건</div>
        </div>
        <div class="card">
            <div class="card-title">승인된 입고</div>
            <div class="card-value">
                <c:set var="approvedCount" value="0"/>
                <c:forEach items="${dtoList1}" var="dto">
                    <c:if test="${dto.status eq '승인'}">
                        <c:set var="approvedCount" value="${approvedCount + 1}"/>
                    </c:if>
                </c:forEach>
                ${approvedCount}건
            </div>
        </div>
    </div>

    <!-- 테이블 -->
    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>입고 ID</th>
                <th>상품 ID</th>
                <th>수량</th>
                <th>요청일</th>
                <th>창고</th>
                <th>회원</th>
                <th>상태</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${dtoList1}" var="dto">
                <tr>
                    <td><c:out value="${dto.inbound_id}"/></td>
                    <td><c:out value="${dto.product_id}"/></td>
                    <td><c:out value="${dto.inbound_quantity}"/></td>
                    <td><c:out value="${dto.req_inbound_day}"/></td>
                    <td><c:out value="${dto.warehouse_id}"/></td>
                    <td><c:out value="${dto.userid}"/></td>
                    <td>
                        <span class="badge ${dto.status eq '승인' ? 'approved' : 'pending'}">
                            <c:out value="${dto.status}"/>
                        </span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
