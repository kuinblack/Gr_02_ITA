package controller;

import dao.CourseDAO;
import dao.StudentDashboardDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Course;
import model.Lesson;
import model.Module;
import model.User;

public class LessonProgressServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");
        String courseIdParam = request.getParameter("courseId");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdParam.trim());
            int studentId = user.getUserId();

            CourseDAO courseDAO = new CourseDAO();
            StudentDashboardDAO dashboardDAO = new StudentDashboardDAO();

            Course course = courseDAO.getCourseWithProgress(courseId, studentId);
            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/studentdashboard");
                return;
            }

            ArrayList<Module> moduleList = courseDAO.getModules(courseId);
            HashMap<Integer, ArrayList<Lesson>> lessonMap = new HashMap<>();
            
            // Khởi tạo biến đếm tổng số bài học dựa trên bộ nhớ (In-memory) thay vì SELECT COUNT độc lập
            int totalLessons = 0; 

            for (Module module : moduleList) {
                ArrayList<Lesson> lessons = courseDAO.getLessons(module.getModuleId());
                lessonMap.put(module.getModuleId(), lessons);
                
                // Tự động tích lũy số lượng bài học thực tế lấy ra được
                if (lessons != null) {
                    totalLessons += lessons.size();
                }
            }

            ArrayList<Integer> completedLessonIds = dashboardDAO.getCompletedLessonIds(studentId, courseId);

            // Dự phòng trường hợp DB lỗi trả về tổng số bài học bằng 0 nhưng danh sách hoàn thành có dữ liệu
            if (totalLessons == 0 && !completedLessonIds.isEmpty()) {
                totalLessons = completedLessonIds.size();
            }

            int currentLessonId = -1;
            outer:
            for (Module module : moduleList) {
                ArrayList<Lesson> lessons = lessonMap.get(module.getModuleId());
                if (lessons != null) {
                    for (Lesson lesson : lessons) {
                        if (!completedLessonIds.contains(lesson.getLessonId())) {
                            currentLessonId = lesson.getLessonId();
                            break outer;
                        }
                    }
                }
            }

            request.setAttribute("course", course);
            request.setAttribute("modules", moduleList);
            request.setAttribute("lessonMap", lessonMap);
            request.setAttribute("completedLessons", completedLessonIds);
            request.setAttribute("currentLessonId", currentLessonId);
            request.setAttribute("totalLessons", totalLessons);

            request.getRequestDispatcher("/common/personalprogress.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");
        String lessonIdParam = request.getParameter("lessonId");

        if (lessonIdParam != null && !lessonIdParam.trim().isEmpty()) {
            try {
                int lessonId = Integer.parseInt(lessonIdParam.trim());
                int studentId = user.getUserId();

                StudentDashboardDAO dashboardDAO = new StudentDashboardDAO();
                
                // Thực hiện ghi nhận trạng thái hoàn thành bài học
                dashboardDAO.insertOrUpdateLessonProgress(studentId, lessonId, "Completed");

                // Lấy ra mã khóa học để chuyển hướng quay lại đúng URL mong muốn
                int courseId = dashboardDAO.getCourseIdByLessonId(lessonId);
                if (courseId != -1) {
                    response.sendRedirect(request.getContextPath() + "/personalprogress?courseId=" + courseId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/studentdashboard");
                }
                return;

            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect(request.getContextPath() + "/studentdashboard");
    }
}