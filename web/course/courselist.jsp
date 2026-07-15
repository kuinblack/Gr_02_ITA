<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>SME - My Courses</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

        <style>
            .modal{
                display:none;
                position:fixed;
                inset:0;
                background:rgba(0,0,0,.45);
                z-index:999;
                justify-content:center;
                align-items:center;
            }

            .modal.show{
                display:flex;
            }

            .modal-content{
                width:90%;
                max-width:560px;
                background:white;
                border-radius:18px;
                padding:24px;
                box-shadow:0 20px 40px rgba(0,0,0,.2);
            }

            .modal-header{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .close{
                cursor:pointer;
                font-size:28px;
            }

            .form-group{
                margin-bottom:16px;
            }

            .form-group label{
                display:block;
                margin-bottom:6px;
                font-weight:600;
            }

            .form-group input,
            .form-group textarea,
            .form-group select{
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
                margin-top:20px;
            }

            .btn-danger{
                background:#dc2626;
                color:white;
                border:none;
                padding:8px 14px;
                border-radius:8px;
                cursor:pointer;
            }

            .btn-secondary{
                background:white;
                border:1px solid #d1d5db;
                padding:8px 14px;
                border-radius:8px;
                cursor:pointer;
            }

            .action-buttons{
                display:flex;
                justify-content:center;
                align-items:center;
                gap:8px;
                flex-wrap:wrap;
            }

            .btn-edit{
                background:#2563eb;
                color:white;
                padding:8px 14px;
                border-radius:8px;
                text-decoration:none;
                border:none;
                cursor:pointer;
                font-weight:600;
            }

            .btn-open{
                background:#16a34a;
                color:white;
                padding:8px 14px;
                border-radius:8px;
                text-decoration:none;
                font-weight:600;
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

                        <h1>My Courses</h1>

                        <p>Manage your courses and learning structure.</p>

                    </div>

                </div>

                <!-- TOOLBAR -->

                <div class="toolbar">

                    <div class="search-box">

                        <form action="${pageContext.request.contextPath}/courselist"
                              method="get"
                              style="display:flex;gap:8px;width:100%;">

                            <input type="text"
                                   name="keyword"
                                   value="${param.keyword}"
                                   placeholder="Search courses..."
                                   style="flex:1;padding:12px 15px;border:1px solid #d1d5db;border-radius:10px;">

                            <button type="submit" class="btn-create">
                                Search
                            </button>

                        </form>

                    </div>

                    <button class="btn-create"
                            type="button"
                            onclick="openCreateModal()">

                        + New Course

                    </button>

                </div>

                <!-- TABLE -->

                <div class="content-card">

                    <table>

                        <thead>

                            <tr>
                                <th>ID</th>
                                <th>Thumbnail</th>
                                <th>Course</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>

                        </thead>

                        <tbody>

                            <c:choose>

                                <c:when test="${not empty courseList}">

                                    <c:forEach items="${courseList}" var="c">

                                        <tr>

                                            <td>${c.courseId}</td>

                                            <td>

                                                <img src="${not empty c.thumbnailUrl ? c.thumbnailUrl : 'https://via.placeholder.com/100x60?text=No+Image'}"
                                                     width="90"
                                                     height="55"
                                                     style="border-radius:8px;object-fit:cover;">

                                            </td>

                                            <td>

                                                <div style="font-weight:700;">${c.title}</div>

                                                <div style="font-size:13px;color:#6b7280;">
                                                    ${c.description}
                                                </div>

                                            </td>

                                            <td>
                                                <fmt:formatNumber value="${c.price}" pattern="#,##0"/> VND
                                            </td>

                                            <td>

                                                <span class="status-badge ${c.status.toLowerCase()}">
                                                    ${c.status}
                                                </span>

                                            </td>

                                            <td>

                                                <div class="action-buttons">

                                                    <a href="${pageContext.request.contextPath}/coursestructure?id=${c.courseId}"
                                                       class="btn-open">
                                                        Open
                                                    </a>

                                                    <button class="btn-edit"
                                                            type="button"
                                                            onclick="openEditModal(
                                                                            '${c.courseId}',
                                                                            '${c.title}',
                                                                            '${c.description}',
                                                                            '${c.thumbnailUrl}',
                                                                            '${c.price}',
                                                                            '${c.status}'
                                                                            )">
                                                        Edit
                                                    </button>

                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/courselist"
                                                          onsubmit="return confirm('Bạn có chắc muốn xóa khóa học này?')">

                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="courseId" value="${c.courseId}">

                                                        <button type="submit" class="btn-danger">
                                                            Delete
                                                        </button>

                                                    </form>

                                                </div>

                                            </td>

                                        </tr>

                                    </c:forEach>

                                </c:when>

                                <c:otherwise>

                                    <tr>

                                        <td colspan="6" style="text-align:center;padding:40px;color:#6b7280;">
                                            No courses found.
                                        </td>

                                    </tr>

                                </c:otherwise>

                            </c:choose>

                        </tbody>

                    </table>

                </div>

            </main>

        </div>

        <!-- CREATE MODAL -->

        <div id="createModal" class="modal">

            <div class="modal-content">

                <div class="modal-header">

                    <h2>Create Course</h2>

                    <span class="close" onclick="closeCreateModal()">&times;</span>

                </div>

                <form method="post" action="${pageContext.request.contextPath}/courselist">

                    <input type="hidden" name="action" value="create">

                    <div class="form-group">

                        <label>Title</label>

                        <input type="text" name="title" required>

                    </div>

                    <div class="form-group">

                        <label>Description</label>

                        <textarea name="description" rows="4"></textarea>

                    </div>

                    <div class="form-group">

                        <label>Thumbnail URL</label>

                        <input type="text" name="thumbnailUrl">

                    </div>

                    <div class="form-group">

                        <label>Price</label>

                        <input type="number" step="0.01" name="price" value="0">

                    </div>

                    <div class="form-group">

                        <label>Status</label>

                        <select name="status">
                            <option value="Draft">Draft</option>
                            <option value="Published">Published</option>
                            <option value="Archived">Archived</option>
                        </select>

                    </div>

                    <div class="modal-footer">

                        <button type="button"
                                class="btn-secondary"
                                onclick="closeCreateModal()">
                            Cancel
                        </button>

                        <button type="submit" class="btn-create">
                            Create
                        </button>

                    </div>

                </form>

            </div>

        </div>

        <!-- EDIT MODAL -->

        <div id="editModal" class="modal">

            <div class="modal-content">

                <div class="modal-header">

                    <h2>Edit Course</h2>

                    <span class="close" onclick="closeEditModal()">&times;</span>

                </div>

                <form method="post" action="${pageContext.request.contextPath}/courselist">

                    <input type="hidden" name="action" value="update">

                    <input type="hidden" id="editCourseId" name="courseId">

                    <div class="form-group">

                        <label>Title</label>

                        <input type="text" id="editTitle" name="title" required>

                    </div>

                    <div class="form-group">

                        <label>Description</label>

                        <textarea id="editDescription" name="description" rows="4"></textarea>

                    </div>

                    <div class="form-group">

                        <label>Thumbnail URL</label>

                        <input type="text" id="editThumbnail" name="thumbnailUrl">

                    </div>

                    <div class="form-group">

                        <label>Price</label>

                        <input type="number" step="0.01" id="editPrice" name="price">

                    </div>

                    <div class="form-group">

                        <label>Status</label>

                        <select id="editStatus" name="status">
                            <option value="Draft">Draft</option>
                            <option value="Published">Published</option>
                            <option value="Archived">Archived</option>
                        </select>

                    </div>

                    <div class="modal-footer">

                        <button type="button"
                                class="btn-secondary"
                                onclick="closeEditModal()">
                            Cancel
                        </button>

                        <button type="submit" class="btn-create">
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

            function openEditModal(id, title, description, thumbnail, price, status) {

                document.getElementById('editCourseId').value = id;
                document.getElementById('editTitle').value = title;
                document.getElementById('editDescription').value = description;
                document.getElementById('editThumbnail').value = thumbnail;
                document.getElementById('editPrice').value = price;
                document.getElementById('editStatus').value = status;

                document.getElementById('editModal').classList.add('show');
            }

            function closeEditModal() {
                document.getElementById('editModal').classList.remove('show');
            }
        </script>

    </body>
</html>