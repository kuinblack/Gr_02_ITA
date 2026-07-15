<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Courses"/>
</jsp:include>

<style>
    :root {
        --primary-green: #1C3A27;
        --hover-green: #264D35;
        --bg-light: #F8FAFC;
        --text-dark: #1F2937;
        --text-muted: #6B7280;
        --border-color: #ECECEC;
        --accent-teal: #81D8D0;
    }

    .page {
        max-width: 1300px;
        margin: 0 auto;
        padding: 35px 24px 80px;
        font-family: 'Plus Jakarta Sans', sans-serif;
    }

    /* ==================== HERO SECTION ==================== */
    .hero {
        background: linear-gradient(135deg, #1C3A27, #2E5A40);
        color: white;
        border-radius: 26px;
        padding: 50px;
        margin-bottom: 40px;
        position: relative;
        overflow: hidden;
    }
    .hero::after {
        content: '';
        position: absolute;
        right: -80px;
        top: -80px;
        width: 300px;
        height: 300px;
        border-radius: 50%;
        background: rgba(255, 255, 255, 0.04);
        pointer-events: none;
    }
    .hero h1 {
        margin: 0;
        font-size: 38px;
        font-weight: 800;
        letter-spacing: -0.5px;
    }
    .hero p {
        margin: 14px 0 0;
        font-size: 16px;
        opacity: 0.9;
        max-width: 600px;
        line-height: 1.6;
    }

    /* ==================== COURSE GRID ==================== */
    .course-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
        gap: 30px;
    }

    .course-card {
        background: white;
        border: 1px solid var(--border-color);
        border-radius: 24px;
        overflow: hidden;
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        display: flex;
        flex-direction: column;
    }
    .course-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
    }

    /* Banner giả lập tạo điểm nhấn cho thẻ */
    .course-banner {
        height: 120px;
        background: linear-gradient(135deg, #1C3A27, #3B7255);
        position: relative;
    }
    .course-badge {
        position: absolute;
        right: 20px;
        top: 20px;
        background: white;
        color: var(--primary-green);
        padding: 6px 14px;
        border-radius: 999px;
        font-size: 13px;
        font-weight: 700;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .course-content {
        padding: 26px;
        display: flex;
        flex-direction: column;
        flex: 1;
    }

    .course-title {
        margin: 0;
        font-size: 22px;
        font-weight: 700;
        color: var(--text-dark);
        line-height: 1.4;
    }

    /* Ép văn bản mô tả cắt bằng dấu 3 chấm nếu quá 3 dòng */
    .course-desc {
        color: var(--text-muted);
        font-size: 14px;
        line-height: 1.7;
        margin: 12px 0 20px;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
        flex: 1; /* Đẩy khối action xuống đáy nếu mô tả ngắn */
    }

    /* Thanh tiến độ cho từng khóa học */
    .course-progress {
        margin-bottom: 24px;
    }
    .progress-info {
        display: flex;
        justify-content: space-between;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-dark);
        margin-bottom: 8px;
    }
    .progress-bar {
        height: 8px;
        background: #E5E7EB;
        border-radius: 999px;
        overflow: hidden;
    }
    .progress-fill {
        height: 100%;
        background: var(--primary-green);
        border-radius: 999px;
        transition: width 0.5s ease;
    }

    /* ==================== BUTTONS / ACTIONS ==================== */
    .action-group {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
        margin-top: auto;
    }

    .btn {
        padding: 12px 18px;
        border-radius: 12px;
        font-size: 14px;
        font-weight: 700;
        text-decoration: none;
        text-align: center;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }
    .btn-primary {
        background: var(--primary-green);
        color: white;
        flex: 1 1 100%; /* Ưu tiên nút học tiếp chiếm toàn bộ hàng hoặc dòng riêng */
        margin-bottom: 4px;
    }
    .btn-primary:hover {
        background: var(--hover-green);
    }
    .btn-outline {
        border: 1px solid #D8D8D8;
        color: var(--text-dark);
        background: white;
        flex: 1;
    }
    .btn-outline:hover {
        background: var(--bg-light);
        border-color: #B5B5B5;
    }

    /* ==================== RESPONSIVE ==================== */
    @media(max-width: 768px) {
        .page {
            padding: 20px 16px 60px;
        }
        .hero {
            padding: 35px 24px;
        }
        .hero h1 {
            font-size: 30px;
        }
        .course-grid {
            grid-template-columns: 1fr;
            gap: 20px;
        }
        .action-group {
            flex-direction: column;
        }
        .btn {
            flex: 1 1 100%;
        }
    }
</style>

<div class="page">

    <!-- Hero Section -->
    <div class="hero">
        <h1>📚 Explore Courses</h1>
        <p>Continue your learning journey, master core components, and discover new knowledge pathways on EduNexus.</p>
    </div>

    <!-- Course Grid Matrix -->
    <div class="course-grid">
        <c:forEach items="${courseList}" var="c">
            <div class="course-card">
                <!-- Thêm Banner & Badge lớp học đồng bộ với Dashboard -->
                <div class="course-banner">
                    <span class="course-badge">${c.className != null ? c.className : "Enrolled"}</span>
                </div>

                <div class="course-content">
                    <h3 class="course-title">${c.title}</h3>

                    <p class="course-desc">
                        ${c.description}
                    </p>

                    <!-- Bổ sung Progress Bar trực quan -->
                    <div class="course-progress">
                        <div class="progress-info">
                            <span>Progress</span>
                            <span>${c.progressPercent}%</span>
                        </div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${c.progressPercent}%"></div>
                        </div>
                    </div>

                    <div class="action-group">
                        <a class="btn btn-primary"
                           href="${pageContext.request.contextPath}/moduleview?courseId=${c.courseId}">
                            Continue Learning
                        </a>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/flashcardview?courseId=${c.courseId}">
                            Flashcards
                        </a>

                        <a class="btn btn-outline"
                           href="${pageContext.request.contextPath}/personalprogress?courseId=${c.courseId}">
                            Progress
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</div>

<jsp:include page="/common/footer.jsp"/>