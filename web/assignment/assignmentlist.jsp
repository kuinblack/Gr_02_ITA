<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Assignment Management</title>

        <style>
            body{
                font-family: Arial, sans-serif;
                background:#f6f7fb;
                margin:0;
            }

            .dashboard{
                display:flex;
                min-height:100vh;
            }

            .main{
                flex:1;
                padding:30px;
            }

            .topbar{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:20px;
            }

            .btn{
                padding:10px 16px;
                border-radius:6px;
                text-decoration:none;
                border:none;
                cursor:pointer;
                font-weight:bold;
            }

            .btn-primary{
                background:#1C3A27;
                color:white;
            }

            .btn-danger{
                background:#dc3545;
                color:white;
            }

            .card{
                background:white;
                border-radius:10px;
                padding:20px;
            }

            table{
                width:100%;
                border-collapse:collapse;
            }

            th,td{
                padding:12px;
                border-bottom:1px solid #eee;
                text-align:left;
            }

            th{
                background:#fafafa;
            }

            .actions{
                display:flex;
                gap:8px;
            }

            .search{
                margin-bottom:15px;
            }

            .search input{
                width:300px;
                padding:10px;
                border:1px solid #ccc;
                border-radius:6px;
            }
        </style>
    </head>
    <body>

        <div class="dashboard">

            <c:set var="active" value="assignments"/>
            <jsp:include page="/common/sme_sidebar.jsp"/>

            <main class="main">

                <div class="topbar">
                    <div>
                        <h1>Assignment Management</h1>
                        <p>Total: ${assignmentList.size()} assignments</p>
                    </div>

                    <a class="btn btn-primary"
                       href="${pageContext.request.contextPath}/assignmentdetail">
                        + New Assignment
                    </a>
                </div>

                <div class="card">

                    <div class="search">
                        <input type="text"
                               id="searchInput"
                               placeholder="Search assignment..."
                               onkeyup="filterTable()">
                    </div>

                    <table id="assignmentTable">

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Class</th>
                                <th>Deadline</th>
                                <th>Total Score</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach items="${assignmentList}" var="a">

                                <tr>

                                    <td>#${a.assignmentId}</td>

                                    <td>${a.title}</td>

                                    <td>${a.className}</td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty a.deadline}">
                                                <fmt:formatDate value="${a.deadline}"
                                                                pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>
                                                No deadline
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>${a.totalScore}</td>

                                    <td>
                                        <div class="actions">

                                            <a class="btn btn-primary"
                                               href="${pageContext.request.contextPath}/assignmentdetail?id=${a.assignmentId}">
                                                Edit
                                            </a>

                                            <form action="${pageContext.request.contextPath}/assignmentlist"
                                                  method="post"
                                                  style="display:inline">

                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${a.assignmentId}">

                                                <button class="btn btn-danger"
                                                        type="submit"
                                                        onclick="return confirm('Delete this assignment?')">
                                                    Delete
                                                </button>
                                            </form>

                                        </div>
                                    </td>

                                </tr>

                            </c:forEach>

                            <c:if test="${empty assignmentList}">
                                <tr>
                                    <td colspan="6" style="text-align:center">
                                        No assignments found.
                                    </td>
                                </tr>
                            </c:if>

                        </tbody>

                    </table>

                </div>

            </main>

        </div>

        <script>
            function filterTable() {

                const input = document.getElementById("searchInput").value.toLowerCase();

                const rows = document.querySelectorAll("#assignmentTable tbody tr");

                rows.forEach(r => {

                    const text = r.innerText.toLowerCase();

                    r.style.display = text.includes(input) ? "" : "none";
                });
            }
        </script>

    </body>
</html>