<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>AI Flashcard Staging</title>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">

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
                background:white;
                border-radius:12px;
                padding:24px;
                margin-bottom:24px;
                box-shadow:0 2px 10px rgba(0,0,0,0.05);
            }

            textarea{
                width:100%;
                min-height:100px;
                padding:12px;
                border:1px solid #ddd;
                border-radius:8px;
                resize:vertical;
                font-family:inherit;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th,td{
                padding:12px;
                border-bottom:1px solid #eee;
                vertical-align:top;
            }

            th{
                background:#fafafa;
                text-align:left;
            }

            .input{
                width:100%;
                min-height:60px;
                padding:10px;
                border:1px solid #ddd;
                border-radius:8px;
                resize:vertical;
            }

            .actions{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-top:20px;
                gap:12px;
                flex-wrap:wrap;
            }

            .btn{
                padding:10px 18px;
                border:none;
                border-radius:8px;
                cursor:pointer;
                font-weight:600;
            }

            .btn-primary{
                background:#14281d;
                color:white;
            }

            .btn-secondary{
                background:#e5e7eb;
            }

            .btn-danger{
                background:#ef4444;
                color:white;
            }

            .toolbar{
                display:flex;
                gap:10px;
                align-items:center;
                margin-bottom:16px;
                flex-wrap:wrap;
            }

            .count{
                margin-left:auto;
                font-weight:600;
            }
        </style>
    </head>

    <body>

        <div class="dashboard">

            <c:set var="active" value="flashcards"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <h1>🤖 AI Flashcard Staging</h1>
                <p>Module: <strong>${moduleName}</strong></p>

                <div class="card">
                    <h3>Generate Flashcards</h3>

                    <form method="post" action="${pageContext.request.contextPath}/aiflashcardstaging">
                        <input type="hidden" name="action" value="generate">
                        <input type="hidden" name="moduleId" value="${moduleId}">

                        <textarea name="inputText" placeholder="Paste lesson content here..." required>${inputText}</textarea>

                        <div style="margin-top:12px">
                            <button class="btn btn-primary" type="submit">
                                Generate
                            </button>
                        </div>
                    </form>
                </div>

                <c:if test="${not empty stagedCards}">
                    <div class="card">

                        <form method="post" action="${pageContext.request.contextPath}/aiflashcardstaging" id="importForm">

                            <input type="hidden" name="action" value="import">
                            <input type="hidden" name="moduleId" value="${moduleId}">

                            <div class="toolbar">
                                <button type="button" class="btn btn-secondary" onclick="toggleAll(true)">
                                    Select All
                                </button>

                                <button type="button" class="btn btn-secondary" onclick="toggleAll(false)">
                                    Unselect All
                                </button>

                                <button type="button" class="btn btn-secondary" onclick="addRow()">
                                    + Add Custom Card
                                </button>

                                <span class="count" id="counter"></span>
                            </div>

                            <table>
                                <thead>
                                    <tr>
                                        <th style="width:60px">✓</th>
                                        <th>Front</th>
                                        <th>Back</th>
                                        <th style="width:90px">Action</th>
                                    </tr>
                                </thead>

                                <tbody id="tbody">

                                    <c:forEach items="${stagedCards}" var="card" varStatus="loop">
                                        <tr class="row">
                                            <td>
                                                <input type="checkbox"
                                                       class="cb"
                                                       name="selectedCard"
                                                       value="${loop.index}"
                                                       checked
                                                       onchange="updateCounter()">
                                            </td>

                                            <td>
                                                <textarea class="input"
                                                          name="stagedFront"
                                                          required><c:out value='${card.frontContent}'/></textarea>
                                            </td>

                                            <td>
                                                <textarea class="input"
                                                          name="stagedBack"
                                                          required><c:out value='${card.backContent}'/></textarea>
                                            </td>

                                            <td>
                                                <button type="button"
                                                        class="btn btn-danger"
                                                        onclick="removeRow(this)">
                                                    Remove
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                </tbody>
                            </table>

                            <div class="actions">
                                <a class="btn btn-secondary"
                                   href="${pageContext.request.contextPath}/flashcardlibrary">
                                    Cancel
                                </a>

                                <button type="submit" class="btn btn-primary">
                                    Approve & Save
                                </button>
                            </div>

                        </form>
                    </div>
                </c:if>

            </main>
        </div>

        <script>
            function updateCounter() {
                const total = document.querySelectorAll('.row').length;
                const checked = document.querySelectorAll('.cb:checked').length;

                const counter = document.getElementById('counter');
                if (counter) {
                    counter.innerText = checked + ' / ' + total + ' selected';
                }
            }

            function toggleAll(state) {
                document.querySelectorAll('.cb').forEach(cb => cb.checked = state);
                updateCounter();
            }

            function removeRow(btn) {
                btn.closest('tr').remove();
                reindex();
                updateCounter();
            }

            function addRow() {
                const tbody = document.getElementById('tbody');
                const index = document.querySelectorAll('.row').length;

                const tr = document.createElement('tr');
                tr.className = 'row';

                tr.innerHTML = `
                    <td>
                        <input type="checkbox"
                               class="cb"
                               name="selectedCard"
                               value="${index}"
                               checked
                               onchange="updateCounter()">
                    </td>

                    <td>
                        <textarea class="input"
                                  name="stagedFront"
                                  placeholder="Front side"
                                  required></textarea>
                    </td>

                    <td>
                        <textarea class="input"
                                  name="stagedBack"
                                  placeholder="Back side"
                                  required></textarea>
                    </td>

                    <td>
                        <button type="button"
                                class="btn btn-danger"
                                onclick="removeRow(this)">
                            Remove
                        </button>
                    </td>
                `;

                tbody.appendChild(tr);
                reindex();
                updateCounter();
            }

            function reindex() {
                document.querySelectorAll('.cb').forEach((cb, i) => {
                    cb.value = i;
                });
            }

            document.addEventListener('DOMContentLoaded', updateCounter);
        </script>

    </body>
</html>