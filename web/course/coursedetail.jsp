<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Course Detail"/>
</jsp:include>

<style>
.page{
    max-width:1200px;
    margin:40px auto;
    padding:0 24px;
}

.hero{
    background:#1C3A27;
    color:white;
    border-radius:28px;
    padding:48px;
    margin-bottom:28px;
}

.hero h1{
    margin:0;
    font-size:40px;
}

.hero p{
    color:#D1D5DB;
    line-height:1.7;
}

.module-card{
    background:white;
    border:1px solid #E5E7EB;
    border-radius:22px;
    padding:28px;
    margin-bottom:20px;
}

.module-top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:16px;
    margin-bottom:18px;
}

.module-title{
    margin:0;
    color:#1C3A27;
    font-size:24px;
}

.status{
    padding:8px 14px;
    border-radius:999px;
    font-weight:700;
    font-size:13px;
}

.status.done{
    background:#DCFCE7;
    color:#166534;
}

.status.learning{
    background:#FEF3C7;
    color:#B45309;
}

.action-grid{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(180px,1fr));
    gap:12px;
}

.action{
    display:flex;
    align-items:center;
    gap:10px;
    padding:14px 16px;
    border-radius:14px;
    border:1px solid #E5E7EB;
    text-decoration:none;
    color:#1F2937;
    font-weight:700;
    background:white;
    transition:.2s;
}

.action:hover{
    border-color:#1C3A27;
    background:#F8FAF8;
}

.primary{
    background:#1C3A27;
    color:white;
    border-color:#1C3A27;
}

.primary:hover{
    background:#264D35;
}
</style>

<div class="page">

    <div class="hero">
        <h1>📘 ${course.title}</h1>
        <p>${course.description}</p>
    </div>

    <c:forEach items="${moduleList}" var="m" varStatus="s">

        <div class="module-card">

            <div class="module-top">

                <div>
                    <h2 class="module-title">
                        Module ${s.index + 1}: ${m.moduleTitle}
                    </h2>
                </div>

                <c:choose>
                    <c:when test="${m.completed}">
                        <span class="status done">✔ DONE</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status learning">IN PROGRESS</span>
                    </c:otherwise>
                </c:choose>

            </div>

            <div class="action-grid">

                <a class="action primary"
                   href="${pageContext.request.contextPath}/lessonview?courseId=${course.courseId}&moduleId=${m.moduleId}">
                    📝 Lessons
                </a>

                <a class="action"
                   href="${pageContext.request.contextPath}/flashcardview?courseId=${course.courseId}">
                    🃏 Flashcards
                </a>

                <a class="action"
                   href="${pageContext.request.contextPath}/assignmentsubmissions?moduleId=${m.moduleId}">
                    📄 Assignments
                </a>

                <a class="action"
                   href="${pageContext.request.contextPath}/questionbank?moduleId=${m.moduleId}">
                    ❓ Question Bank
                </a>

            </div>

        </div>

    </c:forEach>

</div>

<jsp:include page="/common/footer.jsp"/>