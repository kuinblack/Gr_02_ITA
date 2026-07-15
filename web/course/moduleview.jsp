<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Course Modules"/>
</jsp:include>

<style>
    :root {
        --primary-green: #1C3A27;
        --hover-green: #264D35;
        --bg-light: #F8FAFC;
        --text-dark: #1F2937;
        --text-muted: #6B7280;
        --border-color: #E5E7EB;
        --success-green: #10B981; /* Thêm màu cho trạng thái hoàn thành */
    }

    .container {
        max-width: 1100px;
        margin: 40px auto 80px;
        padding: 0 24px;
        font-family: 'Plus Jakarta Sans', sans-serif;
    }

    /* ==================== COURSE HERO CARD ==================== */
    .course-hero {
        background: linear-gradient(135deg, #1C3A27, #2E5A40);
        color: white;
        border-radius: 24px;
        padding: 45px;
        margin-bottom: 35px;
        position: relative;
        overflow: hidden;
        box-shadow: 0 10px 30px rgba(28, 58, 39, 0.1);
    }
    .course-hero::after {
        content: '';
        position: absolute;
        right: -60px;
        top: -60px;
        width: 250px;
        height: 250px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.04);
        pointer-events: none;
    }
    .course-hero h1 {
        margin: 0;
        font-size: 34px;
        font-weight: 800;
        letter-spacing: -0.5px;
    }
    .course-hero p {
        margin: 14px 0 0;
        font-size: 16px;
        opacity: 0.9;
        line-height: 1.7;
        max-width: 700px;
    }

    /* ==================== MODULE CONTAINER ==================== */
    .module-card {
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 20px;
        padding: 30px;
        margin-bottom: 24px;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.02);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .module-card:hover {
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
    }
    .module-card h2 {
        margin: 0 0 16px 0;
        font-size: 22px;
        color: var(--text-dark);
        font-weight: 700;
    }

    /* ==================== ACTION HUBS ==================== */
    .actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-bottom: 28px;
        padding-bottom: 20px;
        border-bottom: 1px solid #F1F5F9;
    }

    /* ==================== LESSON MATRIX ==================== */
    .lesson-section-title {
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--text-muted);
        margin-bottom: 14px;
        font-weight: 800;
    }

    .lesson-wrapper {
        background: var(--bg-light);
        border-radius: 14px;
        padding: 8px 16px;
    }

    .lesson {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        padding: 14px 8px;
        border-top: 1px solid #E2E8F0;
        transition: transform 0.2s ease;
    }
    .lesson:first-child {
        border-top: none;
    }
    .lesson:hover {
        transform: translateX(4px);
    }
    .lesson-info {
        display: flex;
        align-items: center;
        gap: 12px;
        color: var(--text-dark);
        font-size: 15px;
    }
    .lesson-icon {
        font-size: 18px;
        opacity: 0.7;
    }

    /* Giao diện cho text bài học đã hoàn thành */
    .lesson.completed-lesson .lesson-info strong {
        color: var(--text-muted);
        text-decoration: line-through; /* Gạch ngang nhẹ nếu muốn (tùy chọn) */
    }

    .status-badge {
        font-size: 16px;
        color: var(--success-green);
    }

    /* ==================== BUTTONS SYSTEM ==================== */
    .btn {
        text-decoration: none;
        padding: 10px 18px;
        border-radius: 10px;
        font-weight: 700;
        font-size: 13.5px;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s ease;
    }
    .btn-primary {
        background: var(--primary-green);
        color: #fff;
        box-shadow: 0 4px 12px rgba(28, 58, 39, 0.15);
    }
    .btn-primary:hover {
        background: var(--hover-green);
        transform: translateY(-1px);
    }
    .btn-outline {
        border: 1px solid #D1D5DB;
        color: var(--text-dark);
        background: white;
    }
    .btn-outline:hover {
        background: var(--bg-light);
        border-color: #9CA3AF;
    }

    /* Empty Box */
    .empty-state {
        text-align: center;
        padding: 50px 20px;
        color: var(--text-muted);
        background: white;
        border: 1px dashed var(--border-color);
        border-radius: 20px;
    }

    /* ==================== RESPONSIVE ==================== */
    @media(max-width: 768px) {
        .container {
            padding: 0 16px;
            margin-top: 20px;
        }
        .course-hero {
            padding: 30px 20px;
        }
        .course-hero h1 {
            font-size: 26px;
        }
        .module-card {
            padding: 20px;
        }
        .actions {
            flex-direction: column;
            gap: 8px;
        }
        .btn {
            width: 100%;
            text-align: center;
        }
        .lesson {
            flex-direction: column;
            align-items: flex-start;
            gap: 12px;
        }
        .lesson .btn {
            width: auto;
            align-self: flex-end;
        }
    }
</style>

<div class="container">

    <!-- Course Info Top Banner -->
    <div class="course-hero">
        <h1>📖 ${course.title}</h1>
        <p>${course.description}</p>
    </div>

    <!-- Modules Iterator Matrix -->
    <c:choose>
        <c:when test="${empty moduleList}">
            <div class="empty-state">
                <h3>No Modules Available</h3>
                <p>The matrix architecture for this course is currently empty or unassigned.</p>
            </div>
        </c:when>

        <c:otherwise>
            <c:forEach items="${moduleList}" var="m">
                <div class="module-card">
                    <h2>📦 ${m.moduleTitle}</h2>

                    <!-- Module Satellite Management Grid -->
                    <div class="actions">
                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/flashcardview?courseId=${course.courseId}&moduleId=${m.moduleId}">
                            🃏 Flashcards
                        </a>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/assignmentlibrary?moduleId=${m.moduleId}">
                            📝 Assignments
                        </a>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/studentquestionlist?moduleId=${m.moduleId}">
                            ❓ Questions
                        </a>
                    </div>

                    <!-- Lessons List Core -->
                    <div class="lesson-section-title">Module Syllabus</div>

                    <div class="lesson-wrapper">
                        <c:choose>
                            <c:when test="${empty m.lessons}">
                                <p style="padding: 10px 8px; margin: 0; color: var(--text-muted); font-size: 14px;">
                                    No sequential lessons found in this module layer.
                                </p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${m.lessons}" var="l">
                                    <!-- Thêm class completed-lesson nếu bài học đã hoàn thành -->
                                    <div class="lesson ${l.isCompleted ? 'completed-lesson' : ''}">
                                        <div class="lesson-info">
                                            <!-- Thay đổi icon hoặc bổ sung nhãn tích xanh dựa vào trạng thái -->
                                            <c:choose>
                                                <c:when test="${l.isCompleted}">
                                                    <span class="status-badge">✅</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="lesson-icon">📄</span>
                                                </c:otherwise>
                                            </c:choose>
                                            <strong>${l.lessonTitle}</strong>
                                        </div>

                                        <a class="btn btn-primary"
                                           href="${pageContext.request.contextPath}/lessonview?lessonId=${l.lessonId}">
                                            ${l.isCompleted ? 'Review Lesson' : 'Study Lesson'}
                                        </a>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

</div>

<jsp:include page="/common/footer.jsp"/>