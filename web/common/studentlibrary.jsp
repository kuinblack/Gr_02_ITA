<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>s

<!DOCTYPE html>

<html>

    <head>

        <title>Student Library</title>

        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/style.css">

    </head>

    <body>

        <div class="container">

            <h1 class="page-title">

                Student Library

            </h1>

            <table class="table">

                <tr>

                    <th>Course</th>

                    <th>Description</th>

                    <th>Level</th>

                    <th>Action</th>

                </tr>

                <c:forEach items="${courseList}" var="c">

                    <tr>

                        <td>${c.title}</td>

                        <td>${c.description}</td>

                        <td>${c.level}</td>

                        <td>

                            <a href="${pageContext.request.contextPath}/lessonview?courseId=${c.courseId}">
                                Open Course
                            </a>

                        </td>

                    </tr>

                </c:forEach>

            </table>

            <div class="button-group">

                <a href="${pageContext.request.contextPath}/studentdashboard"
                   class="btn-cancel">

                    Back

                </a>

            </div>

        </div>

    </body>

</html>