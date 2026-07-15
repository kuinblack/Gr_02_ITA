
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Draft Queue</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>

<div class="dashboard">

    <c:set var="active" value="ai_drafts"/>
    <jsp:include page="/common/sme_sidebar.jsp"/>

    <main class="main">

        <div class="topbar">
            <h1>AI Draft Queue</h1>
            <p>Review all AI generated lesson drafts before publishing.</p>
        </div>

        <div class="content-card">

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Lesson ID</th>
                        <th>Source</th>
                        <th>Status</th>
                        <th>Generated At</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>

                <c:choose>

                    <c:when test="${not empty drafts}">

                        <c:forEach items="${drafts}" var="d">

                            <tr>
                                <td>#${d.draftId}</td>
                                <td>${d.lessonId}</td>
                                <td>${d.sourceType}</td>

                                <td>
                                    <span class="status-badge ${d.status.toLowerCase()}">
                                        ${d.status}
                                    </span>
                                </td>

                                <td>${d.generatedAt}</td>

                                <td>
                                    <a class="btn-open"
                                       href="${pageContext.request.contextPath}/ailesson?draftId=${d.draftId}">
                                        Review
                                    </a>
                                </td>
                            </tr>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <tr>
                            <td colspan="6"
                                style="text-align:center;padding:40px;color:#6b7280;">

                                No AI drafts found.

                            </td>
                        </tr>

                    </c:otherwise>

                </c:choose>

                </tbody>

            </table>

        </div>

    </main>

</div>

</body>
</html>