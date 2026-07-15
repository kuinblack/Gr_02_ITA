package controller;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input đầu vào tránh khoảng trắng thừa
        if (email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("email", email);
            request.setAttribute("error", "Vui lòng nhập đầy đủ email và mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(email, password);

            if (user == null) {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng, hoặc tài khoản đã bị khóa!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Thiết lập Session mới hoàn toàn
            HttpSession session = request.getSession();
            session.setAttribute("account", user);

            // Điều hướng chuẩn xác dựa trên Role ID của bạn trong Database
            switch (user.getRoleId()) {
                case 1: // Admin
                    response.sendRedirect("admindashboard");
                    break;

                case 2: // SME
                    response.sendRedirect("smedashboard");
                    break;

                case 3: // Student
                    response.sendRedirect("studentdashboard");
                    break;

                default:
                    session.invalidate(); // Hủy session nếu quyền lạ không hợp lệ
                    request.setAttribute("error", "Tài khoản của bạn không có quyền truy cập vào hệ thống!");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();

            // Đồng bộ xử lý dọn dẹp chuỗi lỗi giống phần Lesson để giao diện JSP đọc an toàn
            String errorMsg = e.getMessage();
            if (errorMsg != null) {
                errorMsg = errorMsg.replace("\n", " ").replace("\r", " ").replace("\"", "'");
            } else {
                errorMsg = "Lỗi hệ thống không xác định.";
            }

            request.setAttribute("error", "Hệ thống gặp sự cố: " + errorMsg);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet";
    }
}
