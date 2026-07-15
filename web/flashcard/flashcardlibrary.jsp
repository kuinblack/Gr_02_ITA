<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Flashcard Library</title>

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
            .topbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:24px;
            }

            .btn{
                padding:10px 18px;
                border:none;
                border-radius:10px;
                cursor:pointer;
                text-decoration:none;
                font-weight:600;
            }

            .btn-primary{
                background:#1C3A27;
                color:#fff;
            }
            .btn-danger{
                background:#DC2626;
                color:#fff;
            }
            .btn-secondary{
                background:#E5E7EB;
                color:#111827;
            }

            .table-card{
                background:#fff;
                border-radius:16px;
                padding:24px;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th,td{
                padding:14px;
                border-bottom:1px solid #eee;
            }

            th{
                background:#fafafa;
                text-align:left;
            }

            .actions{
                display:flex;
                gap:10px;
            }
        </style>
    </head>

    <body>

        <div class="dashboard">

            <c:set var="active" value="flashcards"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <div class="topbar">
                    <h1>🃏 Flashcard Library</h1>

                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/flashcardeditor">
                        + New Flashcard
                    </a>
                </div>

                <div class="table-card">

                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Module</th>
                                <th>Front</th>
                                <th>Back</th>
                                <th width="180">Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach items="${flashcardList}" var="f">

                                <tr>
                                    <td>${f.flashcardId}</td>
                                    <td>${f.moduleId}</td>
                                    <td>${f.frontContent}</td>
                                    <td>${f.backContent}</td>

                                    <td>
                                        <div class="actions">

                                            <a class="btn btn-secondary"
                                               href="${pageContext.request.contextPath}/flashcardeditor?id=${f.flashcardId}">
                                                Edit
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/flashcardlibrary"
                                                  onsubmit="return confirm('Delete this flashcard?')">

                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${f.flashcardId}">

                                                <button class="btn btn-danger" type="submit">
                                                    Delete
                                                </button>
                                            </form>

                                        </div>
                                    </td>
                                </tr>

                            </c:forEach>

                        </tbody>
                    </table>

                </div>

            </main>
        </div>

    </body>
</html>