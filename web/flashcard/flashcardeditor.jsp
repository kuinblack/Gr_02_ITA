<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Flashcard Editor</title>

        <style>
            .dashboard{
                display:flex;
                min-height:100vh;
            }
            .main{
                flex:1;
                padding:32px;
                background:#f5f5f5;
            }

            .card{
                background:#fff;
                border-radius:16px;
                padding:28px;
                max-width:900px;
            }

            .form-group{
                margin-bottom:18px;
            }

            label{
                display:block;
                margin-bottom:8px;
                font-weight:600;
            }

            .form-control{
                width:100%;
                padding:12px;
                border:1px solid #ddd;
                border-radius:10px;
                box-sizing:border-box;
            }

            textarea{
                min-height:120px;
                resize:vertical;
            }

            .actions{
                display:flex;
                gap:12px;
                margin-top:20px;
            }

            .btn{
                padding:10px 18px;
                border:none;
                border-radius:10px;
                text-decoration:none;
                cursor:pointer;
                font-weight:600;
            }

            .btn-primary{
                background:#1C3A27;
                color:#fff;
            }
            .btn-secondary{
                background:#E5E7EB;
                color:#111827;
            }
        </style>
    </head>

    <body>

        <div class="dashboard">

            <c:set var="active" value="flashcards"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <h1>🃏 Flashcard Editor</h1>

                <div class="card">

                    <form method="post"
                          action="${pageContext.request.contextPath}/flashcardeditor">

                        <input type="hidden"
                               name="flashcardId"
                               value="${flashcard.flashcardId}">

                        <div class="form-group">
                            <label>Module ID</label>

                            <input class="form-control"
                                   type="number"
                                   name="moduleId"
                                   value="${flashcard.moduleId}"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Front Content</label>

                            <textarea class="form-control"
                                      name="frontContent"
                                      required>${flashcard.frontContent}</textarea>
                        </div>

                        <div class="form-group">
                            <label>Back Content</label>

                            <textarea class="form-control"
                                      name="backContent"
                                      required>${flashcard.backContent}</textarea>
                        </div>

                        <div class="actions">

                            <button class="btn btn-primary" type="submit">
                                Save
                            </button>

                            <a class="btn btn-secondary"
                               href="${pageContext.request.contextPath}/flashcardlibrary">
                                Cancel
                            </a>

                        </div>

                    </form>

                </div>

            </main>
        </div>

    </body>
</html>