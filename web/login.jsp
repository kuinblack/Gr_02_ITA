<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>EduNexus - Login</title>
        <!-- Khuyến khích đưa đoạn CSS thô lúc nãy vào file này -->
        <link rel="stylesheet" href="<c:url value='/style.css'/>">
    </head>

    <body>
        <div class="login-container">

            <div class="login-card">

                <h1>EduNexus Learning System</h1>

                <p class="subtitle">
                    Welcome Back
                </p>

                <!-- Hiển thị thông báo lỗi hệ thống từ Servlet gửi sang -->
                <c:if test="${not empty error}">
                    <div class="error-box" style="color: #721c24; background-color: #f8d7da; padding: 10px; border-radius: 4px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                        ${error}
                    </div>
                </c:if>

                <!-- Bắt lỗi phân quyền từ AuthFilter đẩy về qua URL (?error=LoiPhanQuyen) -->
                <c:if test="${param.error eq 'LoiPhanQuyen'}">
                    <div class="error-box" style="color: #721c24; background-color: #f8d7da; padding: 10px; border-radius: 4px; margin-bottom: 15px; border: 1px solid #f5c6cb;">
                        Bạn không có quyền truy cập vào khu vực chức năng này! Vui lòng đăng nhập đúng tài khoản.
                    </div>
                </c:if>

                <!-- Login Form -->
                <form action="<c:url value='/login'/>" method="post">

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input
                            id="email"
                            type="email"
                            name="email"
                            placeholder="Enter your email"
                            value="${param.email}"
                            required>
                    </div>

                    <div class="form-group">
                        <label for="password">Password</label>
                        <div class="password-wrapper">
                            <input
                                id="password"
                                type="password"
                                name="password"
                                placeholder="Enter your password"
                                required>

                            <button type="button"
                                    class="toggle-password"
                                    onclick="togglePassword()">
                                Show
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="btn-login">
                        Login
                    </button>

                </form>

                <div class="divider">
                    <span>OR</span>
                </div>

                <!-- Google Login -->
                <form action="<c:url value='/googlelogin'/>" method="get">
                    <button type="submit" class="btn-google">
                        Continue with Google
                    </button>
                </form>

                <div class="demo-account">
                    <p><b>Demo Accounts</b></p>
                    <p>Admin: admin@edunexus.com / 123456</p>
                    <p>SME: sme@edunexus.com / 123456</p>
                    <p>Student: student1@edunexus.com / 123456</p>
                </div>

            </div>

        </div>

        <script>
            function togglePassword() {
                const input = document.getElementById("password");
                const btn = document.querySelector(".toggle-password");

                if (input.type === "password") {
                    input.type = "text";
                    btn.textContent = "Hide";
                } else {
                    input.type = "password";
                    btn.textContent = "Show";
                }
            }
        </script>
    </body>
</html>