<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>SME Dashboard</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/style.css">

        <style>
            body{
                margin:0;
                font-family:Arial,sans-serif;
                background:#f6f8f6;
            }

            .dashboard{
                display:flex;
                min-height:100vh;
            }

            .main{
                flex:1;
                padding:32px;
            }

            .topbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:28px;
            }

            .welcome h1{
                margin:0 0 8px;
                font-size:32px;
                color:#111827;
            }

            .welcome p{
                margin:0;
                color:#6b7280;
            }

            .stats{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
                gap:20px;
                margin-bottom:28px;
            }

            .stat-card{
                background:white;
                border-radius:18px;
                padding:24px;
                box-shadow:0 4px 16px rgba(0,0,0,.05);
            }

            .stat-icon{
                font-size:28px;
                margin-bottom:10px;
            }

            .stat-card h2{
                margin:0;
                font-size:34px;
                color:#166534;
            }

            .stat-card span{
                color:#6b7280;
                font-size:14px;
            }

            .section{
                background:white;
                border-radius:18px;
                padding:24px;
                box-shadow:0 4px 16px rgba(0,0,0,.05);
                margin-bottom:24px;
            }

            .section-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .section-header h2{
                margin:0;
            }

            .btn-view-all{
                text-decoration:none;
                color:#16a34a;
                font-weight:700;
            }

            .quick-actions{
                display:grid;
                grid-template-columns:repeat(auto-fit,minmax(220px,1fr));
                gap:18px;
            }

            .action-card{
                background:#f0fdf4;
                border:1px solid #dcfce7;
                border-radius:16px;
                padding:20px;
                text-decoration:none;
                color:#111827;
                transition:.2s;
            }

            .action-card:hover{
                transform:translateY(-2px);
                box-shadow:0 8px 20px rgba(0,0,0,.08);
            }

            .action-icon{
                font-size:30px;
                margin-bottom:10px;
            }

            .action-card h3{
                margin:0 0 10px;
                color:#166534;
            }

            .action-card p{
                margin:0;
                color:#6b7280;
                font-size:14px;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th,td{
                padding:14px;
                border-bottom:1px solid #e5e7eb;
                text-align:left;
            }

            th{
                background:#f9fafb;
                color:#374151;
            }

            .course-title{
                font-weight:700;
                color:#111827;
            }

            .status-badge{
                padding:6px 12px;
                border-radius:999px;
                font-size:13px;
                font-weight:700;
                display:inline-block;
            }

            .status-badge.draft{
                background:#fef3c7;
                color:#92400e;
            }

            .status-badge.published{
                background:#dcfce7;
                color:#166534;
            }

            .status-badge.archived{
                background:#e5e7eb;
                color:#374151;
            }

            .btn-open{
                background:#16a34a;
                color:white;
                text-decoration:none;
                padding:8px 14px;
                border-radius:10px;
                font-weight:600;
                display:inline-block;
            }

            .btn-open:hover{
                background:#15803d;
            }

            .empty{
                text-align:center;
                padding:40px;
                color:#6b7280;
            }
        </style>
    </head>

    <body>

        <div class="dashboard">

            <!-- Sidebar dùng chung -->
            <c:set var="active" value="dashboard"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <!-- Main content -->
            <main class="main">

                <div class="topbar">
                    <div class="welcome">
                        <h1>SME Dashboard</h1>
                        <p>
                            Welcome back,
                            <b><c:out value="${sessionScope.account.fullName}"/></b>
                        </p>
                    </div>
                </div>

                <!-- Statistics -->
                <section class="stats">

                    <div class="stat-card">
                        <div class="stat-icon">📚</div>
                        <h2>${not empty totalCourse ? totalCourse : 0}</h2>
                        <span>Total Courses</span>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon">🗂️</div>
                        <h2>${not empty totalModule ? totalModule : 0}</h2>
                        <span>Total Modules</span>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon">📝</div>
                        <h2>${not empty totalLesson ? totalLesson : 0}</h2>
                        <span>Total Lessons</span>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon">🎓</div>
                        <h2>${not empty totalStudent ? totalStudent : 0}</h2>
                        <span>Total Students</span>
                    </div>

                </section>

                <!-- Quick actions -->
                <section class="section">

                    <div class="section-header">
                        <h2>Quick Actions</h2>
                    </div>

                    <div class="quick-actions">

                        <a class="action-card"
                           href="${pageContext.request.contextPath}/courselist">
                            <div class="action-icon">📚</div>
                            <h3>Manage Courses</h3>
                            <p>Create and organize your courses.</p>
                        </a>

                        <a class="action-card"
                           href="${pageContext.request.contextPath}/lessonlist">
                            <div class="action-icon">📝</div>
                            <h3>Manage Lessons</h3>
                            <p>Create and edit lesson content.</p>
                        </a>

                        <a class="action-card"
                           href="${pageContext.request.contextPath}/ailesson">
                            <div class="action-icon">✨</div>
                            <h3>AI Lesson Staging</h3>
                            <p>Generate lesson drafts with AI.</p>
                        </a>

                        <a class="action-card"
                           href="${pageContext.request.contextPath}/aidrafts">
                            <div class="action-icon">🕘</div>
                            <h3>AI Draft Queue</h3>
                            <p>Review and approve AI drafts.</p>
                        </a>

                    </div>

                </section>

                <!-- Recent courses -->
                <section class="section">

                    <div class="section-header">
                        <h2>Recent Courses</h2>

                        <a class="btn-view-all"
                           href="${pageContext.request.contextPath}/courselist">
                            View All
                        </a>
                    </div>

                    <c:choose>

                        <c:when test="${not empty courseList}">

                            <table>

                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Course</th>
                                        <th>Status</th>
                                        <th>Created</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach items="${courseList}" var="c">

                                        <tr>

                                            <td>#${c.courseId}</td>

                                            <td class="course-title">
                                                <c:out value="${c.title}"/>
                                            </td>

                                            <td>
                                                <span class="status-badge ${c.status.toLowerCase()}">
                                                    <c:out value="${c.status}"/>
                                                </span>
                                            </td>

                                            <td>
                                                <fmt:formatDate value="${c.createdAt}"
                                                                pattern="dd/MM/yyyy"/>
                                            </td>

                                            <td>
                                                <a class="btn-open"
                                                   href="${pageContext.request.contextPath}/coursestructure?id=${c.courseId}">
                                                    Open
                                                </a>
                                            </td>

                                        </tr>

                                    </c:forEach>

                                </tbody>

                            </table>

                        </c:when>

                        <c:otherwise>

                            <div class="empty">
                                No courses available.
                            </div>

                        </c:otherwise>

                    </c:choose>

                </section>

            </main>

        </div>

    </body>
</html>