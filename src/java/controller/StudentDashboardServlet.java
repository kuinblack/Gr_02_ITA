package controller;

import dao.StudentDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import model.Course;
import model.User;

public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("account");
        StudentDashboardDAO dao = new StudentDashboardDAO();

        ArrayList<Course> courseList = dao.getMyCourses(user.getUserId());

        int totalAllLessonsCompleted = 0;
        float sumProgressPercent = 0;

        for (Course c : courseList) {
            int total = dao.getTotalLesson(c.getCourseId());
            int completed = dao.getCompletedLesson(user.getUserId(), c.getCourseId());
            float percent = dao.getProgressPercent(user.getUserId(), c.getCourseId());

            c.setTotalLessons(total);
            c.setCompletedLessons(completed);
            c.setLessonCompleted(completed);
            c.setProgressPercent(percent);

            // Cộng dồn để tính toán tổng quan
            totalAllLessonsCompleted += completed;
            sumProgressPercent += percent;
        }

        // 1. Tính % tiến độ trung bình của tất cả các khóa học
        int overallProgress = 0;
        if (!courseList.isEmpty()) {
            overallProgress = Math.round(sumProgressPercent / courseList.size());
        }

        // 2. Lấy số lượng Assignment (Giả định bạn bổ sung hàm này vào DAO để đếm số bài tập của Student)
        // Nếu chưa có hàm, tạm thời tạo hoặc truyền giá trị giả lập từ DB
        int totalAssignments = 5; // dao.getTotalAssignmentsByUserId(user.getUserId());

        // 3. Lấy chuỗi ngày học liên tiếp (Streak)
        int dayStreak = 7; // dao.getUserDayStreak(user.getUserId());

        // Đẩy các giá trị tổng hợp này sang request attribute
        request.setAttribute("courseList", courseList);
        request.setAttribute("overallProgress", overallProgress);
        request.setAttribute("totalAllLessonsCompleted", totalAllLessonsCompleted);
        request.setAttribute("totalAssignments", totalAssignments);
        request.setAttribute("dayStreak", dayStreak);

        // Lưu ý: Đang forward tới thư mục /common/ theo cấu trúc cũ của bạn.
        request.getRequestDispatcher("/common/studentdashboard.jsp")
                .forward(request, response);
    }
}
