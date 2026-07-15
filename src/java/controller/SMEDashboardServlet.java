package controller;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Course;
import model.User;

public class SMEDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ===== Kiểm tra session =====
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        // ===== Kiểm tra đăng nhập =====
        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // ===== Phân quyền truy cập SME (Mở ra khi database/model User đã có thuộc tính role) =====
        /*
        if (!"SME".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect("login"); // Hoặc redirect sang trang thông báo từ chối truy cập (access-denied)
            return;
        }
         */
        CourseDAO dao = new CourseDAO();
        int smeId = user.getUserId();

        // ===== Thống kê số liệu =====
        int totalCourse = dao.countCoursesBySME(smeId);
        int totalModule = dao.countModulesBySME(smeId);
        int totalLesson = dao.countLessonsBySME(smeId);
        int totalStudent = dao.countStudentsBySME(smeId);

        // ===== Danh sách khóa học thuộc quyền quản lý =====
        List<Course> courseList = dao.getCoursesBySME(smeId, null);

        // ===== Đẩy dữ liệu sang tầng View =====
        request.setAttribute("totalCourse", totalCourse);
        request.setAttribute("totalModule", totalModule);
        request.setAttribute("totalLesson", totalLesson);
        request.setAttribute("totalStudent", totalStudent);
        request.setAttribute("courseList", courseList);

        // ===== Chuyển hướng xử lý sang trang hiển thị =====
        request.getRequestDispatcher("/common/smedashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "SME Dashboard Servlet";
    }
}
