<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="${lesson.lessonTitle}"/>
</jsp:include>

<style>
    .lesson-container{
        max-width: 1400px;
        margin: 32px auto;
        padding: 0 24px;
        box-sizing: border-box;
    }

    .breadcrumb{
        color: #64748b;
        font-size: 14px;
        margin-bottom: 12px;
    }

    .lesson-header{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:20px;
        margin-bottom:24px;
    }

    .lesson-title{
        font-size:38px;
        margin:0;
        color:#0f172a;
        line-height:1.2;
    }

    .lesson-layout{
        display:grid;
        grid-template-columns:minmax(0,1fr) 340px;
        gap:24px;
        align-items:start;
    }

    .card{
        background:#fff;
        border-radius:20px;
        border:1px solid #e2e8f0;
        box-shadow:0 6px 24px rgba(15,23,42,.04);
    }

    .video-card{
        overflow:hidden;
    }

    .video-card iframe{
        width:100%;
        aspect-ratio:16/9;
        border:none;
        display:block;
    }

    .content-card{
        padding:32px;
        margin-top:20px;
    }

    .content-card h2{
        margin-top:0;
        color:#0f172a;
    }

    .summary{
        background:#f8fafc;
        border:1px solid #e2e8f0;
        border-radius:14px;
        padding:18px;
        margin:24px 0;
        line-height:1.7;
    }

    .lesson-content{
        line-height:1.9;
        color:#1f2937;
        font-size:16px;
    }

    .lesson-content h1,
    .lesson-content h2,
    .lesson-content h3{
        color:#0f172a;
    }

    .lesson-content img{
        max-width:100%;
        border-radius:12px;
    }

    .sidebar{
        position:sticky;
        top:100px;
    }

    .sidebar-card{
        padding:22px;
    }

    .sidebar-title{
        margin:0 0 4px;
        font-size:22px;
        color:#0f172a;
    }

    .sidebar-subtitle{
        margin:0 0 18px;
        color:#64748b;
        font-size:14px;
    }

    .lesson-link{
        display:flex;
        align-items:center;
        gap:12px;
        padding:12px;
        border-radius:12px;
        text-decoration:none;
        color:#111827;
        transition:all .2s;
        margin-bottom:8px;
    }

    .lesson-link:hover{
        background:#f1f5f9;
    }

    .lesson-link.current{
        background:#dbeafe;
        color:#1d4ed8;
        font-weight:700;
    }

    .lesson-link.completed{
        background:#ecfdf5;
        color:#16a34a;
        font-weight:600;
    }

    .lesson-index{
        width:28px;
        height:28px;
        border-radius:50%;
        display:flex;
        align-items:center;
        justify-content:center;
        background:#f1f5f9;
        font-size:13px;
        flex-shrink:0;
    }

    .lesson-link.current .lesson-index{
        background:#2563eb;
        color:white;
    }

    .lesson-link.completed .lesson-index{
        background:#16a34a;
        color:white;
    }

    .complete-section{
        display:flex;
        justify-content:flex-end;
        padding-top:24px;
        margin-top:24px;
        border-top:1px solid #e5e7eb;
    }

    .navigation{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        flex-wrap:wrap;
        margin-top:28px;
    }

    .btn{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        gap:8px;
        padding:12px 18px;
        border-radius:12px;
        text-decoration:none;
        font-weight:700;
        border:none;
        cursor:pointer;
        transition:all .2s;
    }

    .btn-secondary{
        background:#fff;
        border:1px solid #cbd5e1;
        color:#0f172a;
    }

    .btn-secondary:hover{
        background:#f8fafc;
    }

    .btn-primary{
        background:#2563eb;
        color:#fff;
    }

    .btn-primary:hover{
        background:#1d4ed8;
        transform:translateY(-1px);
    }

    .btn-success{
        background:#16a34a;
        color:#fff;
        cursor:default;
    }

    @media (max-width: 1024px){
        .lesson-layout{
            grid-template-columns:1fr;
        }
        .sidebar{
            position:static;
        }
        .lesson-title{
            font-size:30px;
        }
    }
</style>

<div class="lesson-container">

    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/studentdashboard"
           style="color:inherit;text-decoration:none;">
            My Courses
        </a>
        &nbsp;/&nbsp;
        <c:out value="${course.title}"/>
        &nbsp;/&nbsp;
        Module <c:out value="${module.displayOrder}"/>
    </div>

    <div class="lesson-header">
        <div>
            <h1 class="lesson-title">
                <c:out value="${lesson.lessonTitle}"/>
            </h1>
        </div>
    </div>

    <div class="lesson-layout">

        <!-- MAIN CONTENT -->
        <div>
            <c:if test="${not empty lesson.youtubeUrl}">
                <c:choose>
                    <c:when test="${fn:contains(lesson.youtubeUrl, 'youtube.com')}">
                        <c:set var="embedUrl" value="${lesson.youtubeUrl}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="embedUrl"
                               value="https://www.youtube.com/embed/${lesson.youtubeUrl}"/>
                    </c:otherwise>
                </c:choose>

                <div class="card video-card">
                    <iframe src="${embedUrl}" allowfullscreen></iframe>
                </div>
            </c:if>

            <div class="card content-card">
                <h2>📖 Lesson Content</h2>

                <c:if test="${not empty lesson.summary}">
                    <div class="summary">
                        <b>Summary</b>
                        <br><br>
                        <c:out value="${lesson.summary}"/>
                    </div>
                </c:if>

                <div class="lesson-content">
                    ${lesson.content}
                </div>

                <c:if test="${sessionScope.account.roleId == 3}">
                    <div class="complete-section">
                        <c:choose>
                            <c:when test="${completed}">
                                <span class="btn btn-success">
                                    ✔ Completed
                                </span>
                            </c:when>
                            <c:otherwise>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/lessonprogress">
                                    <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                                    <input type="hidden" name="courseId" value="${course.courseId}">
                                    <button type="submit" class="btn btn-primary">
                                        ✔ Mark as Completed
                                    </button>
                                </form>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <div class="navigation">
                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/personalprogress?courseId=${course.courseId}">
                        ← Course Progress
                    </a>

                    <c:choose>
                        <c:when test="${not empty nextLesson}">
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/lessonview?lessonId=${nextLesson.lessonId}">
                                Continue Learning →
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-primary"
                               href="${pageContext.request.contextPath}/personalprogress?courseId=${course.courseId}">
                                Finish Course →
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- SIDEBAR -->
        <aside class="sidebar">
            <div class="card sidebar-card">
                <h3 class="sidebar-title">
                    📚 Module <c:out value="${module.displayOrder}"/>
                </h3>
                <p class="sidebar-subtitle">
                    <c:out value="${module.moduleTitle}"/>
                </p>

                <c:forEach items="${lessonList}" var="l" varStatus="st">
                    <!-- Dùng trực tiếp l.isCompleted thay cho việc lặp lồng progressList -->
                    <a href="${pageContext.request.contextPath}/lessonview?lessonId=${l.lessonId}"
                       class="lesson-link
                       ${lesson.lessonId == l.lessonId ? 'current' : ''}
                       ${l.isCompleted ? 'completed' : ''}">

                        <span class="lesson-index">
                            <c:choose>
                                <c:when test="${l.isCompleted}">✔</c:when>
                                <c:otherwise>${st.index + 1}</c:otherwise>
                            </c:choose>
                        </span>

                        <span>
                            <c:out value="${l.lessonTitle}"/>
                        </span>
                    </a>
                </c:forEach>
            </div>
        </aside>

    </div>
</div>

<jsp:include page="/common/footer.jsp"/>