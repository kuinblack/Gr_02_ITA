<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>
            <c:choose>
                <c:when test="${not empty lesson}">Edit Lesson</c:when>
                <c:otherwise>Create Lesson</c:otherwise>
            </c:choose>
        </title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f5f7fb;
                margin: 0;
                padding: 30px;
            }

            .editor-wrapper {
                max-width: 900px;
                margin: auto;
            }

            .topbar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }

            .back-link {
                text-decoration: none;
                color: #2563eb;
                font-weight: 600;
            }

            .card {
                background: white;
                border-radius: 18px;
                padding: 28px;
                box-shadow: 0 4px 20px rgba(0,0,0,.06);
            }

            h1 {
                margin-top: 0;
                margin-bottom: 8px;
            }

            .module-name {
                color: #6b7280;
                margin-bottom: 24px;
            }

            .form-group {
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #111827;
            }

            input[type=text],
            input[type=number],
            textarea,
            select {
                width: 100%;
                padding: 12px;
                border: 1px solid #d1d5db;
                border-radius: 10px;
                font-size: 14px;
                box-sizing: border-box;
            }

            textarea {
                resize: vertical;
            }

            .grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 16px;
            }

            .actions {
                display: flex;
                gap: 12px;
                margin-top: 30px;
            }

            .btn {
                padding: 12px 20px;
                border: none;
                border-radius: 10px;
                cursor: pointer;
                font-weight: 600;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
            }

            .btn-primary {
                background: #2563eb;
                color: white;
            }

            .btn-secondary {
                background: #e5e7eb;
                color: #111827;
            }

            .btn-danger {
                background: #dc2626;
                color: white;
            }

            .danger-zone {
                margin-top: 32px;
                padding-top: 24px;
                border-top: 1px solid #e5e7eb;
            }

            @media(max-width:768px) {
                .grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>

    <body>

        <div class="editor-wrapper">

            <div class="topbar">
                <a class="back-link" href="javascript:history.back()">
                    ← Back
                </a>
            </div>

            <div class="card">

                <h1>
                    <c:choose>
                        <c:when test="${not empty lesson}">
                            ✏️ Edit Lesson
                        </c:when>
                        <c:otherwise>
                            ➕ Create Lesson
                        </c:otherwise>
                    </c:choose>
                </h1>

                <c:if test="${not empty module}">
                    <div class="module-name">
                        Module: <b><c:out value="${module.moduleTitle}"/></b>
                    </div>
                </c:if>

                <form method="post" action="${pageContext.request.contextPath}/lessoneditor">

                    <!-- Hidden Fields -->
                    <c:if test="${not empty lesson}">
                        <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                    </c:if>
                    <input type="hidden" name="moduleId" value="${module.moduleId}">

                    <div class="form-group">
                        <label>Lesson Title</label>
                        <input type="text" name="title" value="<c:out value='${lesson.lessonTitle}'/>" placeholder="Enter lesson title" required>
                    </div>

                    <div class="form-group">
                        <label>Summary</label>
                        <textarea name="summary" rows="4" placeholder="Brief description of the lesson"><c:out value="${lesson.summary}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label>Content</label>
                        <textarea name="content" rows="14" placeholder="Write the lesson content here..." required><c:out value="${lesson.content}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label>YouTube URL</label>
                        <input type="text" name="youtubeUrl" value="<c:out value='${lesson.youtubeUrl}'/>" placeholder="https://www.youtube.com/watch?v=...">
                    </div>

                    <div class="grid">
                        <div class="form-group">
                            <label>Duration (minutes)</label>
                            <input type="number" name="duration" value="${not empty lesson ? lesson.duration : 0}" min="0" required>
                        </div>

                        <div class="form-group">
                            <label>Display Order</label>
                            <input type="number" name="displayOrder" value="${not empty lesson ? lesson.displayOrder : 1}" min="1" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Status</label>
                        <select name="status">
                            <option value="Draft" ${lesson.status == 'Draft' ? 'selected' : ''}>Draft</option>
                            <option value="Published" ${lesson.status == 'Published' ? 'selected' : ''}>Published</option>
                            <option value="Archived" ${lesson.status == 'Archived' ? 'selected' : ''}>Archived</option>
                        </select>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">
                            💾 Save Lesson
                        </button>
                        <a href="javascript:history.back()" class="btn btn-secondary">
                            Cancel
                        </a>
                    </div>

                </form>

                <!-- Danger Zone chỉ hiển thị khi sửa bài học cũ -->
                <c:if test="${not empty lesson}">
                    <div class="danger-zone">
                        <h3>Danger Zone</h3>
                        <form method="post" action="${pageContext.request.contextPath}/lessoneditor">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="lessonId" value="${lesson.lessonId}">
                            <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this lesson?')">
                                🗑 Delete Lesson
                            </button>
                        </form>
                    </div>
                </c:if>

            </div>
        </div>

    </body>
</html>