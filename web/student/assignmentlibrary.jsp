<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- Nhúng đối tượng Date để so sánh thời gian hiện tại trực tiếp trên JSP -->
<jsp:useBean id="now" class="java.util.Date" />

<!-- Đường dẫn đúng đến thư mục common -->
<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="My Assignments | EduNexus" />
</jsp:include>

<!-- Icon Font Awesome phục vụ trạng thái danh sách bài tập -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<style>
    /* Đồng bộ bảng màu gốc hệ thống EduNexus */
    :root {
        --primary: #1C3A27;
        --primary-hover: #264D35;
        --accent: #81D8D0;
        --white: #FFFFFF;
        --text: #1F2937;
        --muted: #6B7280;
        --border: #E5E7EB;
        --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03), 0 2px 4px -2px rgba(0, 0, 0, 0.03);
    }

    .main-content {
        max-width: 1280px;
        width: 100%;
        margin: 40px auto;
        padding: 0 24px;
        box-sizing: border-box;
    }

    .page-title-section {
        margin-bottom: 28px;
    }
    .page-title-section h1 {
        font-family: 'Playfair Display', serif;
        font-size: 32px;
        font-weight: 700;
        margin: 0 0 8px 0;
        color: var(--primary);
    }
    .page-title-section p {
        margin: 0;
        color: var(--muted);
        font-size: 15px;
    }

    /* --- BẢNG DANH SÁCH BÀI TẬP --- */
    .table-card {
        background: var(--white);
        border-radius: 16px;
        box-shadow: var(--shadow);
        border: 1px solid var(--border);
        overflow: hidden;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        text-align: left;
    }

    th {
        background: #F9FAFB;
        padding: 18px 24px;
        font-size: 13px;
        font-weight: 700;
        color: var(--muted);
        border-bottom: 1px solid var(--border);
        text-transform: uppercase;
        letter-spacing: 0.75px;
    }

    td {
        padding: 18px 24px;
        font-size: 15px;
        border-bottom: 1px solid var(--border);
        vertical-align: middle;
    }

    tr:last-child td {
        border-bottom: none;
    }

    tr:hover td {
        background-color: #F8F9FA;
    }

    .assignment-id {
        font-weight: 600;
        color: var(--muted);
    }
    .assignment-title {
        font-weight: 700;
        color: var(--text);
    }

    /* --- TRẠNG THÁI HỒ SƠ BÀI LÀM --- */
    .badge {
        padding: 6px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        display: inline-flex;
        align-items: center;
        gap: 6px;
    }
    .badge-not-started {
        background: #FEF3C7;
        color: #D97706;
    }
    .badge-submitted {
        background: #DBEAFE;
        color: #2563EB;
    }
    .badge-graded {
        background: #E8F5EE;
        color: #166534;
    }
    .badge-expired {
        background: #FEE2E2;
        color: #991B1B;
    }

    /* --- NÚT HÀNH ĐỘNG --- */
    .btn {
        padding: 10px 18px;
        border-radius: 12px;
        text-decoration: none;
        color: var(--white);
        display: inline-flex;
        align-items: center;
        gap: 6px;
        font-size: 13px;
        font-weight: 700;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        border: none;
        cursor: pointer;
    }

    .btn-submit {
        background: var(--primary);
    }
    .btn-submit:hover {
        background: var(--primary-hover);
        transform: translateY(-1px);
    }

    .btn-review {
        background: var(--muted);
    }
    .btn-review:hover {
        background: #4B5563;
        transform: translateY(-1px);
    }

    .btn-result {
        background: #059669;
    }
    .btn-result:hover {
        background: #047857;
        transform: translateY(-1px);
    }

    .btn-disabled {
        background: #E5E7EB;
        color: #9CA3AF;
        cursor: not-allowed;
    }

    @media (max-width: 768px) {
        th:nth-child(3), td:nth-child(3) {
            display: none;
        }
        td {
            padding: 14px 16px;
        }
    }
</style>

<main class="main-content">
    <div class="page-title-section">
        <h1>My Assignments</h1>
        <p>Theo dõi tiến độ bài tập, thời hạn nộp bài và xem kết quả trực tiếp từ hệ thống.</p>
    </div>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Assignment Title</th>
                    <th>Class</th>
                    <th>Deadline</th>
                    <th>Status</th>
                    <th>Score</th>
                    <th style="text-align: center;">Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${assignmentList}" var="a">
                    <!-- Kiểm tra xem bài tập hiện tại đã quá hạn chưa -->
                    <c:set var="isOverdue" value="${now.time > a.deadline.time}" />

                    <tr>
                        <td class="assignment-id">#${a.assignmentId}</td>
                        <td>
                            <div class="assignment-title">${a.title}</div>
                        </td>
                        <td><span style="color: var(--primary); font-weight: 600;">${a.className}</span></td>
                        <td>
                            <span style="font-size: 14px; font-weight: 500;">
                                <i class="fa-regular fa-clock" style="margin-right: 4px; color: var(--muted);"></i>
                                <fmt:formatDate value="${a.deadline}" pattern="dd/MM/yyyy HH:mm"/>
                            </span>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${!a.submitted && isOverdue}">
                                    <span class="badge badge-expired">
                                        <i class="fa-solid fa-clock-rotate-left"></i> Trễ hạn
                                    </span>
                                </c:when>
                                <c:when test="${!a.submitted}">
                                    <span class="badge badge-not-started">
                                        <i class="fa-solid fa-circle-minus"></i> Chưa làm
                                    </span>
                                </c:when>
                                <c:when test="${a.submitted && !a.graded}">
                                    <span class="badge badge-submitted">
                                        <i class="fa-solid fa-circle-dot"></i> Chờ chấm
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-graded">
                                        <i class="fa-solid fa-circle-check"></i> Đã có điểm
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td style="font-weight: 600;">
                            <c:choose>
                                <c:when test="${a.graded}">
                                    <span style="color: #059669; font-weight: 700; font-size: 16px;">${a.studentScore}</span><span style="color: var(--muted);"> / ${a.totalScore}</span>
                                    </c:when>
                                    <c:otherwise>
                                    <span style="color: var(--muted);">-- / ${a.totalScore}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td style="text-align: center;">
                            <c:choose>
                                <c:when test="${!a.submitted && isOverdue}">
                                    <!-- Quá hạn nộp và chưa nộp bài: Khóa nút không cho nộp -->
                                    <button class="btn btn-disabled" disabled>
                                        <i class="fa-solid fa-ban"></i> Closed
                                    </button>
                                </c:when>
                                <c:when test="${!a.submitted}">
                                    <a class="btn btn-submit" href="${pageContext.request.contextPath}/assignmentsubmit?assignmentId=${a.assignmentId}">
                                        <i class="fa-solid fa-upload"></i> Submit
                                    </a>
                                </c:when>
                                <c:when test="${a.submitted && !a.graded}">
                                    <!-- Cho phép Review lại bài nộp cũ kể cả khi đã hết hạn -->
                                    <a class="btn btn-review" href="${pageContext.request.contextPath}/assignmentresult?assignmentId=${a.assignmentId}">
                                        <i class="fa-solid fa-magnifying-glass"></i> Review
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a class="btn btn-result" href="${pageContext.request.contextPath}/assignmentresult?assignmentId=${a.assignmentId}">
                                        <i class="fa-solid fa-square-poll-vertical"></i> Result
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty assignmentList}">
                    <tr>
                        <td colspan="7" style="text-align:center; padding: 48px 0; color: var(--muted);">
                            <i class="fa-regular fa-folder-open" style="font-size: 36px; display: block; margin-bottom: 12px; color: var(--accent);"></i>
                            Hiện tại chưa có bài tập nào được giao.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/common/footer.jsp" />