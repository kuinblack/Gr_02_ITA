<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lesson Text Extract</title>

        <style>
            body{
                margin:0;
                font-family:Arial,sans-serif;
                background:#f5f7fb;
            }

            .layout{
                display:flex;
                min-height:100vh;
            }

            .main{
                flex:1;
                padding:32px;
            }

            .container{
                max-width:1200px;
                margin:auto;
            }

            .header{
                margin-bottom:28px;
            }

            .header h1{
                margin:0;
                color:#14532d;
            }

            .header p{
                color:#6b7280;
            }

            .workspace{
                display:grid;
                grid-template-columns:420px 1fr;
                gap:24px;
            }

            .card{
                background:#fff;
                border-radius:18px;
                padding:24px;
                box-shadow:0 4px 16px rgba(0,0,0,.05);
            }

            label{
                display:block;
                margin-bottom:8px;
                font-weight:600;
            }

            input[type=text],
            input[type=url],
            select{
                width:100%;
                box-sizing:border-box;
                padding:12px;
                border:1px solid #d1d5db;
                border-radius:10px;
                margin-bottom:16px;
            }

            .upload-box{
                border:2px dashed #d1d5db;
                border-radius:14px;
                padding:32px;
                text-align:center;
                margin-bottom:20px;
            }

            .btn{
                border:none;
                border-radius:10px;
                padding:12px 18px;
                cursor:pointer;
                font-weight:600;
            }

            .btn-primary{
                background:#166534;
                color:#fff;
            }

            .btn-secondary{
                background:#fff;
                color:#14532d;
                border:1px solid #14532d;
            }

            .preview{
                min-height:220px;
                border:1px solid #d1d5db;
                border-radius:12px;
                padding:16px;
                background:#fafafa;
                white-space:pre-wrap;
                line-height:1.6;
                overflow:auto;
            }

            .editor{
                min-height:420px;
                border:1px solid #d1d5db;
                border-radius:12px;
                padding:18px;
                line-height:1.7;
            }

            .actions{
                display:flex;
                justify-content:flex-end;
                gap:12px;
                margin-top:20px;
            }

            .back-link{
                text-decoration:none;
                color:#166534;
                font-weight:600;
            }

            @media(max-width:900px){
                .workspace{
                    grid-template-columns:1fr;
                }
            }
        </style>
    </head>
    <body>

        <div class="layout">

            <c:set var="active" value="ai_extract"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <div class="container">

                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px">
                        <a class="back-link"
                           href="${pageContext.request.contextPath}/smedashboard">
                            ← Back to Dashboard
                        </a>
                    </div>

                    <div class="header">
                        <h1>Lesson Text Extract</h1>
                        <p>Extract transcript from YouTube or text from uploaded files, then generate an AI lesson draft.</p>
                    </div>

                    <div class="workspace">

                        <!-- LEFT -->
                        <div class="card">

                            <!-- STEP 1: EXTRACT TEXT -->
                            <form action="${pageContext.request.contextPath}/lessontextextract"
                                  method="post"
                                  enctype="multipart/form-data">

                                <input type="hidden" name="action" value="extract">

                                <label>Select Lesson</label>
                                <select name="lessonId" required>
                                    <option value="">-- Choose Lesson --</option>

                                    <c:forEach items="${lessonList}" var="l">
                                        <option value="${l.lessonId}"
                                                ${selectedLessonId == l.lessonId ? 'selected' : ''}>
                                            ${l.lessonTitle}
                                        </option>
                                    </c:forEach>
                                </select>

                                <label>YouTube URL</label>
                                <input type="url"
                                       name="youtubeUrl"
                                       value="${youtubeUrl}"
                                       placeholder="https://www.youtube.com/watch?v=...">

                                <div class="upload-box">
                                    <div style="font-size:40px;margin-bottom:10px">📄</div>
                                    <div><b>Upload PDF / DOCX / PPTX</b></div>
                                    <div style="color:#6b7280;font-size:13px;margin-top:6px">
                                        Choose a document to extract text from.
                                    </div>

                                    <input type="file" name="attachedFile">
                                </div>

                                <button class="btn btn-primary" type="submit">
                                    ⚙ Extract Text
                                </button>

                            </form>

                            <hr style="margin:28px 0">

                            <h3>Extracted Text</h3>

                            <div class="preview">
                                <c:choose>
                                    <c:when test="${not empty extractedText}">
                                        ${extractedText}
                                    </c:when>

                                    <c:otherwise>
                                        <span style="color:#9ca3af">
                                            Extracted transcript or document text will appear here...
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <!-- STEP 2: GENERATE AI SUMMARY -->
                            <form action="${pageContext.request.contextPath}/lessontextextract"
                                  method="post"
                                  style="margin-top:20px">

                                <input type="hidden" name="action" value="generateSummary">
                                <input type="hidden" name="lessonId" value="${selectedLessonId}">
                                <input type="hidden" name="extractedText" value="${extractedText}">
                                <input type="hidden" name="sourceType" value="${sourceType}">
                                <input type="hidden" name="sourceReference" value="${sourceReference}">

                                <button class="btn btn-primary" type="submit">
                                    🚀 Generate Lesson Summary
                                </button>

                            </form>

                        </div>

                        <!-- RIGHT -->
                        <div class="card">

                            <h2 style="margin-top:0">AI Draft Preview</h2>

                            <!-- STEP 3: SAVE DRAFT -->
                            <form id="saveDraftForm"
                                  action="${pageContext.request.contextPath}/lessontextextract"
                                  method="post">

                                <input type="hidden" name="action" value="saveDraft">
                                <input type="hidden" name="lessonId" value="${selectedLessonId}">
                                <input type="hidden" id="draftContent" name="draftContent">
                                <input type="hidden" name="sourceType" value="${sourceType}">
                                <input type="hidden" name="sourceReference" value="${sourceReference}">

                                <div id="summaryEditor"
                                     class="editor"
                                     contenteditable="true">

                                    <c:choose>
                                        <c:when test="${not empty aiGeneratedSummary}">
                                            ${aiGeneratedSummary}
                                        </c:when>

                                        <c:otherwise>
                                            <div style="color:#9ca3af">
                                                AI formatted lesson summary will appear here...
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                </div>

                                <div class="actions">

                                    <button class="btn btn-secondary"
                                            type="submit">
                                        💾 Save as AI Draft
                                    </button>

                                </div>

                            </form>

                        </div>

                    </div>
                </div>

            </main>
        </div>

        <script>
            document.getElementById('saveDraftForm').addEventListener('submit', function () {
                document.getElementById('draftContent').value =
                        document.getElementById('summaryEditor').innerHTML;
            });
        </script>

    </body>
</html>