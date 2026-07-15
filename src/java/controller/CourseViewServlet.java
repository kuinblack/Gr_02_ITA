package controller;

import dao.CourseDAO;
import dao.StudentDashboardDAO; // Nhúng thêm DAO này để lấy tiến độ học tập
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Course;
import model.User;

public class CourseViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        // Chỉ cho phép Student (RoleId = 3) truy cập trang này
        if (user.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        // 1. Sử dụng StudentDashboardDAO để lấy chuẩn danh sách khóa học đã đăng ký của riêng User đó
        StudentDashboardDAO dashboardDao = new StudentDashboardDAO();
        ArrayList<Course> courseList = dashboardDao.getMyCourses(user.getUserId());

        // 2. Chạy vòng lặp tính toán tiến độ học tập cho từng khóa học đã đăng ký
        for (Course c : courseList) {
            int total = dashboardDao.getTotalLesson(c.getCourseId());
            int completed = dashboardDao.getCompletedLesson(user.getUserId(), c.getCourseId());
            float percent = dashboardDao.getProgressPercent(user.getUserId(), c.getCourseId());

            c.setTotalLessons(total);
            c.setCompletedLessons(completed);
            c.setLessonCompleted(completed);
            c.setProgressPercent(percent);

            // Lưu ý: Đảm bảo thuộc tính className (nếu có trong DB) đã được nạp sẵn 
            // thông qua hàm getMyCourses() trong DAO của bạn.
        }

        // 3. Xử lý bộ lọc tìm kiếm (Search) dựa trên danh sách khóa học đã đăng ký (nếu cần)
        String keyword = request.getParameter("keyword");
        if (keyword != null && !keyword.isBlank()) {
            String cleanKeyword = keyword.trim().toLowerCase();
            ArrayList<Course> filteredList = new ArrayList<>();
            for (Course c : courseList) {
                if (c.getTitle().toLowerCase().contains(cleanKeyword)
                        || (c.getDescription() != null && c.getDescription().toLowerCase().contains(cleanKeyword))) {
                    filteredList.add(c);
                }
            }
            courseList = filteredList;
        }

        request.setAttribute("courseList", courseList);

        // Lưu ý: Đường dẫn hướng tới file jsp cần khớp chính xác 
        // Thay đổi thành "/course/courseview.jsp" hoặc "/common/courseview.jsp" tùy cấu trúc thư mục thực tế của bạn
        request.getRequestDispatcher("/course/courseview.jsp")
                .forward(request, response);
    }
}
