<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>

<jsp:include page="/common/header.jsp">
    <jsp:param name="title" value="Flashcards"/>
</jsp:include>

<style>
    .page{
        max-width:1200px;
        margin:40px auto;
        padding:0 24px;
    }

    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 30px;
    }

    .grid{
        display:grid;
        grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
        gap:24px;
    }

    .card{
        background:#fff;
        border:1px solid #E3E5E0;
        border-radius:20px;
        padding:24px;
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .btn{
        display:inline-block;
        margin-top:18px;
        background:#1C3A27;
        color:#fff;
        text-decoration:none;
        padding:10px 16px;
        border-radius:10px;
        font-weight:600;
        text-align: center;
        transition: background 0.2s;
    }

    .btn:hover {
        background: #13271a;
    }

    .link-back {
        text-decoration: none;
        color: #1C3A27;
        font-weight: 600;
    }
</style>

<div class="page">

    <div class="page-header">
        <h1>🃏 Flashcards Modules</h1>
        <!-- Nút quay lại chi tiết khóa học hiện tại dựa trên courseId nhận từ Servlet -->
        <a class="link-back" href="${pageContext.request.contextPath}/personalprogress?courseId=${courseId}">
            ← Back to Course Progress
        </a>
    </div>

    <div class="grid">

        <c:forEach items="${moduleList}" var="m">

            <div class="card">
                <div>
                    <h3><c:out value="${m.moduleName}"/></h3>
                    <p><c:out value="${m.totalFlashcards}"/> cards</p>
                </div>

                <!-- Truyền thêm courseId sang trang practice để khi học xong hoặc nhấn back ở trang practice, hệ thống biết đường quay về đúng danh sách module này -->
                <a class="btn"
                   href="${pageContext.request.contextPath}/flashcard/practice?moduleId=${m.moduleId}&courseId=${courseId}">
                    Practice
                </a>
            </div>

        </c:forEach>

    </div>

</div>

<jsp:include page="/common/footer.jsp"/>