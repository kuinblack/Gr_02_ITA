package controller;

import dao.CourseDAO;
import dao.StudentDashboardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import model.Course;
import model.Lesson;
import model.Module;
import model.User;

public class PersonalProgressServlet extends HttpServlet {

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

        if (user.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        String raw = request.getParameter("courseId");

        if (raw == null || raw.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/courseview");
            return;
        }

        try {
            int courseId = Integer.parseInt(raw);
            int studentId = user.getUserId();

            CourseDAO courseDAO = new CourseDAO();
            StudentDashboardDAO dashboardDAO = new StudentDashboardDAO();

            Course course = courseDAO.getCourseById(courseId);

            if (course == null) {
                response.sendRedirect(request.getContextPath() + "/courseview");
                return;
            }

            int completed = dashboardDAO.getCompletedLesson(studentId, courseId);
            int total = dashboardDAO.getTotalLesson(courseId);

            course.setCompletedLessons(completed);
            course.setTotalLessons(total);
            course.setProgressPercent(
                    total == 0 ? 0 : completed * 100.0f / total);

            ArrayList<Module> modules = courseDAO.getModules(courseId);

            HashMap<Integer, ArrayList<Lesson>> lessonMap = new HashMap<>();

            for (Module m : modules) {
                lessonMap.put(
                        m.getModuleId(),
                        courseDAO.getLessons(m.getModuleId())
                );
            }

            ArrayList<Integer> completedLessons
                    = dashboardDAO.getCompletedLessonIds(studentId, courseId);

            int currentLessonId = -1;

            outer:
            for (Module m : modules) {
                for (Lesson l : lessonMap.get(m.getModuleId())) {
                    if (!completedLessons.contains(l.getLessonId())) {
                        currentLessonId = l.getLessonId();
                        break outer;
                    }
                }
            }

            request.setAttribute("course", course);
            request.setAttribute("modules", modules);
            request.setAttribute("lessonMap", lessonMap);
            request.setAttribute("completedLessons", completedLessons);
            request.setAttribute("currentLessonId", currentLessonId);

            request.getRequestDispatcher("/common/personalprogress.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
