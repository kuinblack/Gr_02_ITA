<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Course Progress"/>
</jsp:include>

<style>
    .container{
        max-width:1100px;
        margin:32px auto;
        padding:0 20px;
    }

    .card{
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:20px;
        padding:24px;
        margin-bottom:24px;
    }

    .progress-bar{
        width:100%;
        height:12px;
        background:#e5e7eb;
        border-radius:999px;
        overflow:hidden;
        margin-top:10px;
    }

    .progress-fill{
        height:100%;
        background:#1C3A27;
        transition: width 0.3s ease;
    }

    .module{
        border:1px solid #e5e7eb;
        border-radius:16px;
        padding:20px;
        margin-bottom:18px;
    }

    .lesson{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        padding:12px 0;
        border-top:1px solid #f1f5f9;
    }

    .lesson:first-child{
        border-top:none;
    }

    .status-group {
        display: flex;
        align-items: center;
        gap: 16px;
    }

    .done{
        color:#16a34a;
        font-weight:700;
    }

    .current{
        color:#ea580c;
        font-weight:700;
    }

    .pending{
        color:#64748b;
        font-weight:700;
    }

    .btn{
        text-decoration:none;
        padding:8px 14px;
        border-radius:10px;
        font-weight:700;
        background:#1C3A27;
        color:#fff;
        transition: background 0.2s;
    }

    .btn:hover {
        background: #13271a;
    }
</style>

<!-- Xử lý an toàn dữ liệu đầu vào chống NullPointerException tại tầng hiển thị -->
<c:set var="completedCount" value="${not empty completedLessons ? fn:length(completedLessons) : 0}"/>
<c:set var="totalCount" value="${not empty totalLessons and totalLessons gt 0 ? totalLessons : 0}"/>

<!-- Tính toán phần trăm với kiểu dữ liệu Double tường minh -->
<c:set var="percent" value="${totalCount gt 0 ? (completedCount * 100.0 / totalCount) : 0.0}"/>

<div class="container">

    <div class="card">
        <h1><c:out value="${course.title}"/></h1>
        <p><c:out value="${course.description}"/></p>

        <div style="display:flex;justify-content:space-between;margin-top:20px">
            <strong>Progress</strong>
            <strong><c:out value="${completedCount}"/> / <c:out value="${totalCount}"/> lessons</strong>
        </div>

        <div class="progress-bar">
            <!-- Đẩy trực tiếp phần trăm vào thuộc tính CSS width -->
            <div class="progress-fill" style="width: <c:out value="${percent}"/>%;"></div>
        </div>

        <p style="margin-top:10px">
            <strong>
                <!-- Format hiển thị số và gán cứng hậu tố % phía sau để tránh mất ký tự -->
                <fmt:formatNumber value="${percent}" type="number" maxFractionDigits="0"/>% completed
            </strong>
        </p>
    </div>

    <!-- Hiển thị danh sách Modules và các Lessons tương ứng -->
    <c:forEach items="${modules}" var="m">
        <div class="module">
            <h2><c:out value="${m.moduleTitle}"/></h2>

            <c:forEach items="${lessonMap[m.moduleId]}" var="l">
                <div class="lesson">
                    <div>
                        <strong><c:out value="${l.lessonTitle}"/></strong>
                    </div>

                    <div class="status-group">
                        <c:choose>
                            <c:when test="${not empty completedLessons and completedLessons.contains(l.lessonId)}">
                                <span class="done">✓ Completed</span>
                            </c:when>

                            <c:when test="${currentLessonId == l.lessonId}">
                                <span class="current">▶ Current</span>
                            </c:when>

                            <c:otherwise>
                                <span class="pending">○ Not started</span>
                            </c:otherwise>
                        </c:choose>

                        <a class="btn"
                           href="${pageContext.request.contextPath}/lessonview?lessonId=${l.lessonId}">
                            Open
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:forEach>
</div>

<jsp:include page="/common/footer.jsp"/>