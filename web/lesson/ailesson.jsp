<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>AI Lesson Staging</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    </head>

    <body>

        <div class="dashboard">

            <c:set var="active" value="ai-lessons"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <div class="topbar">
                    <h1>✨ AI Lesson Staging</h1>
                    <p>Generate lesson drafts with AI, review them, then publish to the lesson.</p>
                </div>

                <div class="content-card"
                     style="display:grid;grid-template-columns:350px 1fr;gap:24px;">

                    <!-- LEFT PANEL -->
                    <div>

                        <form action="${pageContext.request.contextPath}/ailesson"
                              method="post">

                            <input type="hidden" name="action" value="generate">

                            <div class="form-group">
                                <label>Select Lesson</label>

                                <select name="lessonId" class="form-control" required>

                                    <option value="">-- Choose Lesson --</option>

                                    <c:forEach items="${lessonList}" var="l">

                                        <option value="${l.lessonId}"
                                                ${selectedLessonId == l.lessonId ? 'selected' : ''}>

                                            ${l.lessonTitle}

                                        </option>

                                    </c:forEach>

                                </select>
                            </div>

                            <div class="form-group">

                                <label>Prompt</label>

                                <textarea class="form-control"
                                          name="prompt"
                                          rows="10"
                                          placeholder="Write a detailed lesson about Servlet Lifecycle with examples...">${prompt}</textarea>
                            </div>

                            <button class="btn-create" type="submit">
                                ✨ Generate with AI
                            </button>

                        </form>

                    </div>

                    <!-- RIGHT PANEL -->
                    <div>

                        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;">

                            <h2>AI Draft Preview</h2>

                            <c:if test="${not empty draft}">

                                <span class="status-badge ${draft.status.toLowerCase()}">
                                    ${draft.status}
                                </span>

                            </c:if>

                        </div>

                        <form action="${pageContext.request.contextPath}/ailesson"
                              method="post">

                            <input type="hidden" name="draftId"
                                   value="${draft.draftId}">

                            <input type="hidden" id="finalContent"
                                   name="finalContent">

                            <div id="editor"
                                 contenteditable="true"
                                 style="border:1px solid #d1d5db;border-radius:12px;padding:18px;min-height:420px;background:white;overflow:auto;">

                                <c:choose>

                                    <c:when test="${not empty draft}">
                                        ${draft.generatedContent}
                                    </c:when>

                                    <c:otherwise>

                                        <span style="color:#9ca3af">
                                            AI generated content will appear here...
                                        </span>

                                    </c:otherwise>

                                </c:choose>

                            </div>

                            <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:20px;">

                                <c:if test="${not empty draft}">

                                    <button class="btn btn-danger"
                                            type="submit"
                                            name="action"
                                            value="reject">
                                        Reject
                                    </button>

                                    <button class="btn btn-secondary"
                                            type="submit"
                                            name="action"
                                            value="apply">
                                        Apply
                                    </button>

                                    <button class="btn-create"
                                            type="submit"
                                            name="action"
                                            value="approve">
                                        ✓ Approve & Publish
                                    </button>

                                </c:if>

                            </div>

                        </form>

                    </div>

                </div>

            </main>

        </div>

        <script>
            document.querySelectorAll('button[type=submit]').forEach(btn => {
                btn.addEventListener('click', function () {
                    const editor = document.getElementById('editor');
                    if (editor) {
                        document.getElementById('finalContent').value = editor.innerHTML;
                    }
                });
            });
        </script>

    </body>
</html>