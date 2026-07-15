<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lesson Management</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    </head>
    <body>

              <div class="dashboard">

            <!-- Sidebar dùng chung -->
            <c:set var="active" value="lessons"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>


            <div class="main">

                <div class="topbar">
                    <h1>Lesson Management</h1>
                </div>

                <div class="content-card" style="margin-bottom:24px">

                    <h2>Choose Course</h2>

                    <div style="display:grid;
                         grid-template-columns:repeat(auto-fit,minmax(300px,1fr));
                         gap:20px;
                         margin-top:20px;">

                        <c:forEach items="${courseList}" var="c">

                            <div style="border:1px solid #e5e7eb;
                                 border-radius:18px;
                                 overflow:hidden;
                                 background:white;
                                 box-shadow:0 4px 12px rgba(0,0,0,.04)">

                                <img src="${not empty c.thumbnailUrl ? c.thumbnailUrl : 'https://via.placeholder.com/600x240?text=Course'}"
                                     style="width:100%;
                                     height:180px;
                                     object-fit:cover">

                                <div style="padding:20px">

                                    <h3 style="margin:0 0 10px">
                                        ${c.title}
                                    </h3>

                                    <p style="color:#6b7280;
                                       min-height:48px">
                                        ${c.description}
                                    </p>

                                    <a class="btn-open"
                                       href="${pageContext.request.contextPath}/lessonlist?courseId=${c.courseId}">
                                        View Lessons
                                    </a>

                                </div>
                            </div>

                        </c:forEach>

                    </div>
                </div>

                <c:if test="${not empty course}">

                    <div class="content-card">

                        <div style="display:flex;
                             justify-content:space-between;
                             align-items:center;
                             margin-bottom:20px">

                            <div>
                                <h2 style="margin:0">${course.title}</h2>
                                <p style="color:#6b7280;margin-top:6px">
                                    Manage lessons inside each module
                                </p>
                            </div>

                            <a href="${pageContext.request.contextPath}/coursestructure?id=${course.courseId}"
                               class="btn-open">
                                Back to Structure
                            </a>

                        </div>

                        <c:forEach items="${moduleList}" var="m">

                            <div style="border:1px solid #e5e7eb;
                                 border-radius:16px;
                                 padding:20px;
                                 margin-bottom:20px">

                                <div style="display:flex;
                                     justify-content:space-between;
                                     align-items:center;
                                     margin-bottom:18px">

                                    <h3 style="margin:0">
                                        Module ${m.displayOrder}: ${m.moduleTitle}
                                    </h3>

                                    <a class="btn-create"
                                       href="${pageContext.request.contextPath}/lessoneditor?moduleId=${m.moduleId}">
                                        + New Lesson
                                    </a>

                                </div>

                                <table>
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Title</th>
                                            <th>Duration</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <c:choose>

                                            <c:when test="${not empty lessonMap[m.moduleId]}">

                                                <c:forEach items="${lessonMap[m.moduleId]}" var="l">

                                                    <tr>
                                                        <td>${l.displayOrder}</td>

                                                        <td>
                                                            <strong>${l.lessonTitle}</strong>
                                                        </td>

                                                        <td>${l.duration} min</td>

                                                        <td>
                                                            <span class="status-badge ${l.status.toLowerCase()}">
                                                                ${l.status}
                                                            </span>
                                                        </td>

                                                        <td>

                                                            <a class="btn-open"
                                                               href="${pageContext.request.contextPath}/lessonview?lessonId=${l.lessonId}">
                                                                View
                                                            </a>

                                                            <a class="btn-open"
                                                               style="background:#2563eb;margin-left:8px"
                                                               href="${pageContext.request.contextPath}/lessoneditor?lessonId=${l.lessonId}">
                                                                Edit
                                                            </a>

                                                        </td>
                                                    </tr>

                                                </c:forEach>

                                            </c:when>

                                            <c:otherwise>

                                                <tr>
                                                    <td colspan="5"
                                                        style="text-align:center;color:#6b7280;padding:20px">
                                                        No lessons yet
                                                    </td>
                                                </tr>

                                            </c:otherwise>

                                        </c:choose>

                                    </tbody>
                                </table>

                            </div>

                        </c:forEach>

                    </div>

                </c:if>

            </div>
        </div>

    </body>
</html>