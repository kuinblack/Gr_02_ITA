<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Assignment Detail</title>

    <style>
        body{
            font-family:Arial,sans-serif;
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

        .card{
            background:white;
            border-radius:10px;
            padding:24px;
            margin-bottom:20px;
        }

        .form-group{
            margin-bottom:16px;
        }

        label{
            display:block;
            margin-bottom:6px;
            font-weight:bold;
        }

        input,textarea,select{
            width:100%;
            padding:10px;
            border:1px solid #ccc;
            border-radius:6px;
            box-sizing:border-box;
        }

        table{
            width:100%;
            border-collapse:collapse;
        }

        th,td{
            padding:12px;
            border-bottom:1px solid #eee;
        }

        th{
            background:#fafafa;
        }

        .btn{
            padding:10px 16px;
            border:none;
            border-radius:6px;
            cursor:pointer;
            text-decoration:none;
            font-weight:bold;
        }

        .btn-primary{
            background:#1C3A27;
            color:white;
        }

        .btn-secondary{
            background:#ddd;
            color:black;
        }

        .btn-danger{
            background:#dc3545;
            color:white;
        }

        .actions{
            display:flex;
            gap:10px;
            justify-content:flex-end;
        }
    </style>
</head>
<body>

<div class="dashboard">

    <c:set var="active" value="assignments"/>
    <jsp:include page="/common/sme_sidebar.jsp"/>

    <main class="main">

        <div class="card">

            <h1>
                <c:choose>
                    <c:when test="${not empty assignment}">
                        Edit Assignment
                    </c:when>
                    <c:otherwise>
                        New Assignment
                    </c:otherwise>
                </c:choose>
            </h1>

            <form method="post"
                  action="${pageContext.request.contextPath}/assignmentdetail">

                <input type="hidden" name="action" value="saveAssignment">
                <input type="hidden" name="assignmentId"
                       value="${assignment.assignmentId}">

                <div class="form-group">

                    <label>Class</label>

                    <select name="classId" required>

                        <option value="">-- Select Class --</option>

                        <c:forEach items="${classList}" var="c">

                            <option value="${c.classId}"
                                ${assignment.classId == c.classId ? 'selected' : ''}>

                                ${c.className}

                            </option>

                        </c:forEach>

                    </select>

                </div>

                <div class="form-group">

                    <label>Title</label>

                    <input type="text"
                           name="title"
                           value="${assignment.title}"
                           required>

                </div>

                <div class="form-group">

                    <label>Description</label>

                    <textarea name="description"
                              rows="5">${assignment.description}</textarea>

                </div>

                <div class="form-group">

                    <label>Deadline</label>

                    <input type="datetime-local"
                           name="deadline"
                           value="${deadlineValue}">

                </div>

                <div class="form-group">

                    <label>Total Score</label>

                    <input type="number"
                           step="0.01"
                           min="0"
                           max="100"
                           name="totalScore"
                           value="${assignment.totalScore}"
                           required>

                </div>

                <div class="actions">

                    <a class="btn btn-secondary"
                       href="${pageContext.request.contextPath}/assignmentlist">
                        Cancel
                    </a>

                    <button class="btn btn-primary" type="submit">
                        Save Assignment
                    </button>

                </div>

            </form>

        </div>

        <c:if test="${not empty assignment}">

            <div class="card">

                <h2>Rubrics</h2>

                <table>

                    <thead>
                        <tr>
                            <th>Criteria</th>
                            <th>Weight</th>
                            <th>Description</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>

                        <c:forEach items="${rubricList}" var="r">

                            <tr>

                                <td>${r.criteria}</td>

                                <td>${r.weight}%</td>

                                <td>${r.description}</td>

                                <td>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/assignmentdetail">

                                        <input type="hidden" name="action" value="deleteRubric">
                                        <input type="hidden" name="rubricId" value="${r.rubricId}">
                                        <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">

                                        <button class="btn btn-danger"
                                                type="submit"
                                                onclick="return confirm('Delete this rubric?')">
                                            Delete
                                        </button>

                                    </form>

                                </td>

                            </tr>

                        </c:forEach>

                    </tbody>

                </table>

            </div>

            <div class="card">

                <h2>Add Rubric</h2>

                <form method="post"
                      action="${pageContext.request.contextPath}/assignmentdetail">

                    <input type="hidden" name="action" value="addRubric">
                    <input type="hidden" name="assignmentId" value="${assignment.assignmentId}">

                    <div class="form-group">

                        <label>Criteria</label>

                        <input type="text" name="criteria" required>

                    </div>

                    <div class="form-group">

                        <label>Weight (%)</label>

                        <input type="number"
                               step="0.01"
                               min="0"
                               max="100"
                               name="weight"
                               required>

                    </div>

                    <div class="form-group">

                        <label>Description</label>

                        <textarea name="rubricDescription" rows="3"></textarea>

                    </div>

                    <div class="actions">

                        <button class="btn btn-primary" type="submit">
                            Add Rubric
                        </button>

                    </div>

                </form>

            </div>

        </c:if>

    </main>

</div>

</body>
</html>
