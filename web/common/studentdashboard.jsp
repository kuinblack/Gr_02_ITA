<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Student Dashboard"/>
</jsp:include>

<style>
    .dashboard{
        max-width:1300px;
        margin:auto;
        padding:35px 24px 60px;
    }

    /* ================= HERO ================= */
    .hero{
        background:linear-gradient(135deg,#1C3A27,#2E5A40);
        color:white;
        border-radius:26px;
        padding:45px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:40px;
        margin-bottom:35px;
        overflow:hidden;
        position:relative;
    }
    .hero::after{
        content:'';
        position:absolute;
        right:-120px;
        top:-120px;
        width:350px;
        height:350px;
        border-radius:50%;
        background:rgba(255,255,255,.05);
    }
    .hero-left{
        flex:1;
    }
    .hero h1{
        margin:0;
        font-size:40px;
        font-weight:800;
    }
    .hero p{
        margin-top:18px;
        line-height:1.8;
        opacity:.9;
        max-width:620px;
        font-size:16px;
    }
    .hero-buttons{
        display:flex;
        gap:16px;
        margin-top:30px;
        flex-wrap:wrap;
    }
    .hero-btn{
        padding:14px 22px;
        border-radius:14px;
        text-decoration:none;
        font-weight:700;
        transition:.25s;
    }
    .hero-primary{
        background:white;
        color:#1C3A27;
    }
    .hero-primary:hover{
        transform:translateY(-2px);
    }
    .hero-outline{
        border:2px solid rgba(255,255,255,.45);
        color:white;
    }
    .hero-outline:hover{
        background:rgba(255,255,255,.08);
    }
    .hero-right{
        width:240px;
        text-align:center;
    }
    .hero-circle{
        width:180px;
        height:180px;
        border-radius:50%;
        margin:auto;
        background:rgba(255,255,255,.12);
        display:flex;
        flex-direction:column;
        justify-content:center;
        align-items:center;
        border:10px solid rgba(255,255,255,.15);
    }
    .hero-circle h2{
        margin:0;
        font-size:46px;
    }
    .hero-circle span{
        margin-top:8px;
        font-size:14px;
    }

    /*==================== STATS ====================*/
    .stats{
        display:grid;
        grid-template-columns:repeat(4,1fr);
        gap:22px;
        margin-bottom:35px;
    }
    .stat-card{
        background:white;
        border-radius:22px;
        padding:28px;
        box-shadow:0 8px 26px rgba(0,0,0,.05);
        transition:.25s;
    }
    .stat-card:hover{
        transform:translateY(-5px);
    }
    .stat-icon{
        font-size:34px;
    }
    .stat-value{
        margin-top:16px;
        font-size:36px;
        font-weight:800;
        color:#1C3A27;
    }
    .stat-label{
        margin-top:6px;
        color:#6B7280;
        font-size:14px;
    }

    /*=============== CONTINUE CARD ================*/
    .continue-card{
        background:white;
        border-radius:22px;
        padding:30px;
        margin-bottom:35px;
        box-shadow:0 8px 26px rgba(0,0,0,.05);
    }
    .continue-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:25px;
    }
    .continue-header h2{
        margin:0;
    }
    .lesson-card{
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:25px;
        background:#F8FAFC;
        border-radius:18px;
        padding:22px;
    }
    .lesson-info h3{
        margin:0;
        font-size:22px;
    }
    .lesson-info p{
        color:#6B7280;
        margin:10px 0;
    }
    .progress-bar{
        width:350px;
        height:10px;
        background:#E5E7EB;
        border-radius:999px;
        overflow:hidden;
    }
    .progress-fill{
        height:100%;
        background:#1C3A27;
    }
    .resume-btn{
        background:#1C3A27;
        color:white;
        text-decoration:none;
        padding:14px 22px;
        border-radius:14px;
        font-weight:700;
    }
    .resume-btn:hover{
        background:#264D35;
    }

    /* =========================== GRID =========================== */
    .dashboard-grid{
        display:grid;
        grid-template-columns:2fr 1fr;
        gap:28px;
    }

    /* =========================== SECTION CARD =========================== */
    .section-card{
        background:#fff;
        border-radius:24px;
        padding:30px;
        margin-bottom:28px;
        box-shadow:0 8px 28px rgba(0,0,0,.05);
    }
    .section-header{
        display:flex;
        justify-content:space-between;
        align-items:center;
        margin-bottom:24px;
    }
    .section-header h2{
        margin:0;
        font-size:24px;
        color:#1C3A27;
    }
    .section-header span{
        color:#6B7280;
        font-weight:600;
    }

    /* =========================== COURSE GRID =========================== */
    .course-grid{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(340px,1fr));
        gap:24px;
    }
    .course-card{
        border:1px solid #ECECEC;
        border-radius:22px;
        overflow:hidden;
        transition:.3s;
        background:white;
    }
    .course-card:hover{
        transform:translateY(-6px);
        box-shadow:0 16px 40px rgba(0,0,0,.08);
    }
    .course-banner{
        height:110px;
        background:linear-gradient(135deg,#1C3A27,#3B7255);
        position:relative;
    }
    .course-badge{
        position:absolute;
        right:18px;
        top:18px;
        background:white;
        color:#1C3A27;
        padding:7px 14px;
        border-radius:999px;
        font-size:13px;
        font-weight:700;
    }
    .course-content{
        padding:24px;
    }
    .course-content h3{
        margin:0;
        font-size:24px;
    }
    .course-content p{
        color:#6B7280;
        line-height:1.7;
        margin:14px 0 22px;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
    }
    .course-progress{
        margin-bottom:24px;
    }
    .progress-info{
        display:flex;
        justify-content:space-between;
        font-size:14px;
        margin-bottom:8px;
        font-weight:600;
    }

    /* =========================== BUTTONS =========================== */
    .course-actions{
        display:flex;
        gap:10px;
        flex-wrap:wrap;
    }
    .btn-primary{
        background:#1C3A27;
        color:white;
        text-decoration:none;
        padding:12px 18px;
        border-radius:12px;
        font-weight:700;
    }
    .btn-primary:hover{
        background:#264D35;
    }
    .btn-outline{
        border:1px solid #D8D8D8;
        color:#1F2937;
        text-decoration:none;
        padding:12px 18px;
        border-radius:12px;
        font-weight:700;
        background:white;
    }
    .btn-outline:hover{
        background:#F7F7F7;
    }

    /* =========================== HUB =========================== */
    .hub-menu{
        display:flex;
        flex-direction:column;
        gap:14px;
    }
    .hub-menu a{
        text-decoration:none;
        color:#1F2937;
        background:#F8FAFC;
        padding:18px;
        border-radius:16px;
        font-weight:700;
        transition:.25s;
    }
    .hub-menu a:hover{
        background:#EAF3EC;
        color:#1C3A27;
        transform:translateX(5px);
    }

    /* =========================== ACTIVITY =========================== */
    .activity-list{
        display:flex;
        flex-direction:column;
        gap:18px;
    }
    .activity-item{
        display:flex;
        gap:18px;
        align-items:center;
    }
    .activity-icon{
        width:56px;
        height:56px;
        border-radius:50%;
        background:#F3F8F4;
        display:flex;
        align-items:center;
        justify-content:center;
        font-size:24px;
    }
    .activity-item p{
        margin:6px 0 0;
        color:#6B7280;
    }

    /* =========================== ACHIEVEMENT =========================== */
    .achievement{
        display:flex;
        gap:18px;
        align-items:center;
        background:#F8FAFC;
        padding:18px;
        border-radius:16px;
        margin-bottom:16px;
        font-size:30px;
    }
    .achievement b{
        font-size:16px;
    }
    .achievement p{
        margin:4px 0 0;
        color:#6B7280;
        font-size:14px;
    }

    /* =========================== EMPTY =========================== */
    .empty-card{
        text-align:center;
        padding:60px 20px;
        color:#6B7280;
    }
    .empty-card h3{
        margin-bottom:12px;
    }

    /* =========================== RESPONSIVE =========================== */
    @media(max-width:1100px){
        .stats{
            grid-template-columns:repeat(2,1fr);
        }
        .hero{
            flex-direction:column;
            align-items:flex-start;
        }
        .lesson-card{
            flex-direction:column;
            align-items:flex-start;
        }
        .progress-bar{
            width:100%;
        }
        .dashboard-grid{
            grid-template-columns:1fr;
        }
        .course-grid{
            grid-template-columns:1fr;
        }
    }
    @media(max-width:768px){
        .stats{
            grid-template-columns:1fr;
        }
        .dashboard{
            padding:20px;
        }
        .hero{
            padding:30px;
        }
        .hero h1{
            font-size:32px;
        }
        .course-actions{
            flex-direction:column;
        }
        .btn-primary, .btn-outline{
            text-align:center;
        }
    }
</style>

<div class="dashboard">

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-left">
            <h1>Welcome back, ${sessionScope.account.fullName}! 👋</h1>
            <p>
                Continue your learning journey with EduNexus.
                Study lessons, review flashcards, practice questions,
                complete assignments and monitor your progress in one place.
            </p>
            <div class="hero-buttons">
                <c:if test="${not empty courseList}">
                    <a class="hero-btn hero-primary"
                       href="${pageContext.request.contextPath}/moduleview?courseId=${courseList[0].courseId}">
                        Continue Learning
                    </a>
                    <a class="hero-btn hero-outline"
                       href="${pageContext.request.contextPath}/flashcardview?courseId=${courseList[0].courseId}">
                        Flashcards
                    </a>
                </c:if>
                <a class="hero-btn hero-outline" href="${pageContext.request.contextPath}/assignmentlibrary">
                    Assignments
                </a>
            </div>
        </div>
        <div class="hero-right">
            <div class="hero-circle">
                <h2>${overallProgress}%</h2>
                <span>Learning Progress</span>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats">
        <div class="stat-card">
            <div class="stat-icon">📚</div>
            <div class="stat-value">${courseList.size()}</div>
            <div class="stat-label">Courses</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📖</div>
            <div class="stat-value">${totalAllLessonsCompleted}</div>
            <div class="stat-label">Lessons Completed</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📝</div>
   <div class="stat-value">${totalAssignments}</div>
            <div class="stat-label">Assignments</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">🔥</div>
<div class="stat-value">${dayStreak}</div>
            <div class="stat-label">Day Streak</div>
        </div>
    </section>

    <!-- Continue Card Section -->
    <c:if test="${not empty courseList}">
        <section class="continue-card">
            <div class="continue-header">
                <h2>Continue Learning</h2>
            </div>
            <div class="lesson-card">
                <div class="lesson-info">
                    <h3>${courseList[0].title}</h3>
                    <p>Resume where you left off and keep making progress.</p>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width:${courseList[0].progressPercent}%"></div>
                    </div>
                </div>
                <a class="resume-btn" href="${pageContext.request.contextPath}/moduleview?courseId=${courseList[0].courseId}">
                    Resume →
                </a>
            </div>
        </section>
    </c:if>

    <!-- Dashboard Grid Layout -->
    <div class="dashboard-grid">

        <!-- ================= LEFT PANEL ================= -->
        <div class="left-panel">
            <section class="section-card">
                <div class="section-header">
                    <h2>📚 My Courses</h2>
                    <span>${courseList.size()} enrolled</span>
                </div>
                <c:choose>
                    <c:when test="${empty courseList}">
                        <div class="empty-card">
                            <h3>No Courses Yet</h3>
                            <p>You haven't enrolled in any courses.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="course-grid">
                            <c:forEach items="${courseList}" var="c">
                                <div class="course-card">
                                    <div class="course-banner">
                                        <span class="course-badge">${c.className}</span>
                                    </div>
                                    <div class="course-content">
                                        <h3>${c.title}</h3>
                                        <p>${c.description}</p>
                                        <div class="course-progress">
                                            <div class="progress-info">
                                                <span>Progress</span>
                                                <span>${c.progressPercent}%</span>
                                            </div>
                                            <div class="progress-bar">
                                                <div class="progress-fill" style="width:${c.progressPercent}%"></div>
                                            </div>
                                        </div>
                                        <div class="course-actions">
                                            <a class="btn-primary" href="${pageContext.request.contextPath}/moduleview?courseId=${c.courseId}">
                                                Continue
                                            </a>
                                            <a class="btn-outline" href="${pageContext.request.contextPath}/flashcardview?courseId=${c.courseId}">
                                                Flashcards
                                            </a>
                                            <a class="btn-outline" href="${pageContext.request.contextPath}/personalprogress?courseId=${c.courseId}">
                                                Progress
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </section>

            <!-- Recent Activity Section -->
            <section class="section-card">
                <div class="section-header">
                    <h2>🕘 Recent Activity</h2>
                </div>
                <div class="activity-list">
                    <div class="activity-item">
                        <div class="activity-icon">📖</div>
                        <div>
                            <b>Lesson Completed</b>
                            <p>Finished your latest lesson.</p>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon">🃏</div>
                        <div>
                            <b>Flashcards Practiced</b>
                            <p>Reviewed flashcards today.</p>
                        </div>
                    </div>
                    <div class="activity-item">
                        <div class="activity-icon">📝</div>
                        <div>
                            <b>Assignment Submitted</b>
                            <p>Your latest submission was uploaded.</p>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <!-- ================= RIGHT PANEL ================= -->
        <div class="right-panel">
            <section class="section-card">
                <div class="section-header">
                    <h2>🚀 Learning Hub</h2>
                </div>
                <div class="hub-menu">
                    <a href="${pageContext.request.contextPath}/courseview">📚 My Courses</a>
                    <c:if test="${not empty courseList}">
                        <a href="${pageContext.request.contextPath}/moduleview?courseId=${courseList[0].courseId}">📖 Lessons</a>
                        <a href="${pageContext.request.contextPath}/flashcardview?courseId=${courseList[0].courseId}">🃏 Flashcards</a>
                        <a href="${pageContext.request.contextPath}/personalprogress?courseId=${courseList[0].courseId}">📈 Progress</a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/assignmentlibrary">📝 Assignments</a>
                    <a href="${pageContext.request.contextPath}/assignmentlibrary">🏆 Results</a>
                </div>
            </section>

            <section class="section-card">
                <div class="section-header">
                    <h2>🏅 Achievements</h2>
                </div>
                <div class="achievement">
                    🔥
                    <div>
                        <b>7 Day Learning Streak</b>
                        <p>Keep learning every day!</p>
                    </div>
                </div>
                <div class="achievement">
                    ⭐
                    <div>
                        <b>Course Explorer</b>
                        <p>Enrolled in multiple courses.</p>
                    </div>
                </div>
                <div class="achievement">
                    🎯
                    <div>
                        <b>Active Learner</b>
                        <p>Completed several lessons.</p>
                    </div>
                </div>
            </section>
        </div>

    </div> <!-- Kết thúc .dashboard-grid -->
</div> <!-- Kết thúc .dashboard -->

<jsp:include page="/common/footer.jsp" />