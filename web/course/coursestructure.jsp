<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Course Structure</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

        <style>
            body{
                margin:0;
                font-family:Arial,sans-serif;
                background:#f5f7fb;
            }

            .dashboard{
                display:flex;
                min-height:100vh;
            }

            .sidebar{
                width:250px;
                background:#14532d;
                color:white;
                padding:20px;
            }

            .sidebar a{
                display:block;
                color:white;
                text-decoration:none;
                padding:10px;
                border-radius:8px;
                margin-bottom:6px;
            }

            .sidebar a:hover,
            .sidebar a.active{
                background:#22c55e;
                color:#052e16;
            }

            .main{
                flex:1;
                padding:32px;
            }

            .topbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:24px;
            }

            .course-card{
                background:white;
                border-radius:16px;
                padding:24px;
                margin-bottom:24px;
                box-shadow:0 4px 16px rgba(0,0,0,.05);
            }

            .module-card{
                background:white;
                border-radius:16px;
                padding:24px;
                margin-bottom:20px;
                box-shadow:0 4px 16px rgba(0,0,0,.05);
            }

            .module-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                gap:16px;
                margin-bottom:16px;
            }

            .module-title{
                margin:0;
                color:#166534;
            }

            .module-actions{
                display:flex;
                gap:10px;
                flex-wrap:wrap;
            }

            .module-links{
                display:flex;
                gap:12px;
                flex-wrap:wrap;
            }

            .module-links a{
                background:#f0fdf4;
                border:1px solid #dcfce7;
                color:#166534;
                text-decoration:none;
                padding:10px 14px;
                border-radius:10px;
                font-weight:600;
            }

            .btn{
                border:none;
                padding:10px 16px;
                border-radius:10px;
                cursor:pointer;
                font-weight:600;
            }

            .btn-green{
                background:#16a34a;
                color:white;
            }

            .btn-blue{
                background:#2563eb;
                color:white;
            }

            .btn-red{
                background:#dc2626;
                color:white;
            }

            .btn-outline{
                background:white;
                border:1px solid #d1d5db;
            }

            /* ===== MODAL ===== */

            .modal{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.45);
                z-index:1000;
                justify-content:center;
                align-items:center;
            }

            .modal.show{
                display:flex;
            }

            .modal-content{
                width:90%;
                max-width:500px;
                background:white;
                border-radius:16px;
                padding:24px;
                box-shadow:0 20px 40px rgba(0,0,0,.2);
            }

            .modal-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .modal-header h3{
                margin:0;
            }

            .close{
                cursor:pointer;
                font-size:24px;
                color:#6b7280;
            }

            .form-group{
                margin-bottom:16px;
            }

            .form-group label{
                display:block;
                margin-bottom:8px;
                font-weight:600;
            }

            .form-group input{
                width:100%;
                padding:12px;
                border:1px solid #d1d5db;
                border-radius:10px;
                box-sizing:border-box;
            }

            .modal-footer{
                display:flex;
                justify-content:flex-end;
                gap:10px;
                margin-top:24px;
            }
        </style>
    </head>

    <body>

         <div class="dashboard">

            <!-- Sidebar dùng chung -->
            <c:set var="active" value="courses"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <!-- MAIN -->

            <main class="main">

                <div class="topbar">

                    <div>

                        <a href="${pageContext.request.contextPath}/courselist">
                            ← Back to Courses
                        </a>

                        <h1>${course.title}</h1>

                        <p>${course.description}</p>

                    </div>

                    <button class="btn btn-green"
                            onclick="openCreateModal()">
                        + Add Module
                    </button>

                </div>

                <!-- MODULE LIST -->

                <c:choose>

                    <c:when test="${not empty moduleList}">

                        <c:forEach items="${moduleList}" var="m">

                            <div class="module-card">

                                <div class="module-header">

                                    <div>

                                        <h2 class="module-title">
                                            Module ${m.displayOrder}: ${m.moduleTitle}
                                        </h2>

                                    </div>

                                    <div class="module-actions">

                                        <button class="btn btn-blue"
                                                onclick="openEditModal('${m.moduleId}', '${m.moduleTitle}', '${m.displayOrder}')">
                                            Edit
                                        </button>

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/coursestructure"
                                              onsubmit="return confirm('Bạn có chắc muốn xóa module này?')">

                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="courseId" value="${course.courseId}">
                                            <input type="hidden" name="moduleId" value="${m.moduleId}">

                                            <button class="btn btn-red" type="submit">
                                                Delete
                                            </button>

                                        </form>

                                    </div>

                                </div>

                                <div class="module-links">

                                    <a href="${pageContext.request.contextPath}/lessonlist?moduleId=${m.moduleId}">
                                        📝 Lessons
                                    </a>

                                    <a href="${pageContext.request.contextPath}/flashcardlibrary?moduleId=${m.moduleId}">
                                        🃏 Flashcards
                                    </a>

                                    <a href="${pageContext.request.contextPath}/assignmentlist?moduleId=${m.moduleId}">
                                        📄 Assignments
                                    </a>

                                    <a href="${pageContext.request.contextPath}/questionbank?moduleId=${m.moduleId}">
                                        ❓ Question Bank
                                    </a>

                                </div>

                            </div>

                        </c:forEach>

                    </c:when>

                    <c:otherwise>

                        <div class="course-card">

                            <h3>No modules yet</h3>

                            <p>Click "Add Module" to create your first module.</p>

                        </div>

                    </c:otherwise>

                </c:choose>

            </main>

        </div>

        <!-- ===== CREATE MODAL ===== -->

        <div id="createModal" class="modal">

            <div class="modal-content">

                <div class="modal-header">

                    <h3>Create Module</h3>

                    <span class="close" onclick="closeCreateModal()">&times;</span>

                </div>

                <form method="post" action="${pageContext.request.contextPath}/coursestructure">

                    <input type="hidden" name="action" value="create">
                    <input type="hidden" name="courseId" value="${course.courseId}">

                    <div class="form-group">

                        <label>Module Title</label>

                        <input type="text" name="moduleTitle" required>

                    </div>

                    <div class="form-group">

                        <label>Display Order</label>

                        <input type="number"
                               name="displayOrder"
                               value="1"
                               min="1"
                               required>

                    </div>

                    <div class="modal-footer">

                        <button type="button"
                                class="btn btn-outline"
                                onclick="closeCreateModal()">
                            Cancel
                        </button>

                        <button type="submit"
                                class="btn btn-green">
                            Create
                        </button>

                    </div>

                </form>

            </div>

        </div>

        <!-- ===== EDIT MODAL ===== -->

        <div id="editModal" class="modal">

            <div class="modal-content">

                <div class="modal-header">

                    <h3>Edit Module</h3>

                    <span class="close" onclick="closeEditModal()">&times;</span>

                </div>

                <form method="post" action="${pageContext.request.contextPath}/coursestructure">

                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="courseId" value="${course.courseId}">
                    <input type="hidden" id="editModuleId" name="moduleId">

                    <div class="form-group">

                        <label>Module Title</label>

                        <input type="text"
                               id="editModuleTitle"
                               name="moduleTitle"
                               required>

                    </div>

                    <div class="form-group">

                        <label>Display Order</label>

                        <input type="number"
                               id="editDisplayOrder"
                               name="displayOrder"
                               min="1"
                               required>

                    </div>

                    <div class="modal-footer">

                        <button type="button"
                                class="btn btn-outline"
                                onclick="closeEditModal()">
                            Cancel
                        </button>

                        <button type="submit"
                                class="btn btn-green">
                            Update
                        </button>

                    </div>

                </form>

            </div>

        </div>

        <script>
            function openCreateModal() {
                document.getElementById('createModal').classList.add('show');
            }

            function closeCreateModal() {
                document.getElementById('createModal').classList.remove('show');
            }

            function openEditModal(id, title, order) {

                document.getElementById('editModuleId').value = id;
                document.getElementById('editModuleTitle').value = title;
                document.getElementById('editDisplayOrder').value = order;

                document.getElementById('editModal').classList.add('show');
            }

            function closeEditModal() {
                document.getElementById('editModal').classList.remove('show');
            }

            window.onclick = function (e) {

                if (e.target.id === 'createModal') {
                    closeCreateModal();
                }

                if (e.target.id === 'editModal') {
                    closeEditModal();
                }
            }
        </script>

    </body>
</html>