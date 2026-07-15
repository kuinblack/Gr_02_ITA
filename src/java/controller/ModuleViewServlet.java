package controller;

import dao.CourseDAO;
import dao.LessonDAO;
import dao.LessonProgressDAO; // Thêm import này
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Course;
import model.Lesson;
import model.Module;
import model.User;

public class ModuleViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa đăng nhập
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        // Chỉ Student
        if (user.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        String rawCourseId = request.getParameter("courseId");

        if (rawCourseId == null || rawCourseId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/courseview");
            return;
        }

        try {
            int courseId = Integer.parseInt(rawCourseId);

            CourseDAO courseDAO = new CourseDAO();
            ModuleDAO moduleDAO = new ModuleDAO();
            LessonDAO lessonDAO = new LessonDAO();
            LessonProgressDAO progressDAO = new LessonProgressDAO(); // Khởi tạo progressDAO

            // Lấy course
            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/courseview");
                return;
            }

            // Lấy modules
            List<Module> moduleList = moduleDAO.getModulesByCourse(courseId);

            // Gắn lessons và kiểm tra trạng thái hoàn thành của từng bài học
            for (Module module : moduleList) {
                List<Lesson> lessons = lessonDAO.getLessonsByModule(module.getModuleId());

                for (Lesson lesson : lessons) {
                    // Gọi hàm kiểm tra trạng thái từ database dựa trên userId và lessonId
                    boolean isDone = progressDAO.isCompleted(user.getUserId(), lesson.getLessonId());
                    lesson.setIsCompleted(isDone);
                }

                module.setLessons(lessons);
            }

            request.setAttribute("course", course);
            request.setAttribute("moduleList", moduleList);

            request.getRequestDispatcher("/course/moduleview.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseview");
        }
    }
}
