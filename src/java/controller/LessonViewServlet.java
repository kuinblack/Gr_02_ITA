package controller;

import dao.CourseDAO;
import dao.LessonDAO;
import dao.LessonProgressDAO;
import dao.ModuleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Lesson;
import model.LessonProgress;
import model.User;

public class LessonViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User student = (User) session.getAttribute("account");

        String lessonParam = request.getParameter("lessonId");

        if (lessonParam == null) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        int lessonId;

        try {
            lessonId = Integer.parseInt(lessonParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        LessonDAO lessonDAO = new LessonDAO();
        ModuleDAO moduleDAO = new ModuleDAO();
        LessonProgressDAO progressDAO = new LessonProgressDAO();
        CourseDAO courseDAO = new CourseDAO();

        Lesson lesson = lessonDAO.getLessonById(lessonId);

        if (lesson == null) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        model.Module module = moduleDAO.getModuleById(lesson.getModuleId());

        if (module == null) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        model.Course course = courseDAO.getCourseById(module.getCourseId());

        List<Lesson> lessonList = lessonDAO.getLessonsByModule(module.getModuleId());

        ArrayList<LessonProgress> progressList
                = progressDAO.getProgressByStudent(student.getUserId());

        Lesson nextLesson = lessonDAO.getNextLesson(lessonId);

        boolean completed = progressDAO.isCompleted(student.getUserId(), lessonId);

        request.setAttribute("course", course);
        request.setAttribute("module", module);
        request.setAttribute("lesson", lesson);
        request.setAttribute("lessonList", lessonList);
        request.setAttribute("progressList", progressList);
        request.setAttribute("nextLesson", nextLesson);
        request.setAttribute("completed", completed);

        request.getRequestDispatcher("/lesson/lessonview.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User student = (User) session.getAttribute("account");
        String lessonParam = request.getParameter("lessonId");

        if (lessonParam == null) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        try {
            int lessonId = Integer.parseInt(lessonParam);
            LessonProgressDAO progressDAO = new LessonProgressDAO();

            // Nếu hệ thống kiểm tra bài học này chưa được hoàn thành, tiến hành đánh dấu hoàn thành
            if (!progressDAO.isCompleted(student.getUserId(), lessonId)) {
                // Hãy đảm bảo LessonProgressDAO của bạn có phương thức insert/markAsCompleted
                // Ví dụ: progressDAO.markAsCompleted(student.getUserId(), lessonId);
            }

            // Kiểm tra xem giao diện có yêu cầu chuyển đến bài tiếp theo không
            String nextLessonParam = request.getParameter("nextLessonId");
            if (nextLessonParam != null && !nextLessonParam.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/lessonview?lessonId=" + nextLessonParam);
            } else {
                // Nếu không có bài tiếp theo, tự động quay về trang danh sách module của khóa học hiện tại
                LessonDAO lessonDAO = new LessonDAO();
                int courseId = lessonDAO.getCourseByLesson(lessonId);
                response.sendRedirect(request.getContextPath() + "/moduleview?courseId=" + courseId);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
        }
    }

    @Override
    public String getServletInfo() {
        return "Lesson View and Progress Handler Servlet";
    }
}