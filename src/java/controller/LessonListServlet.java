package controller;

import dao.CourseDAO;
import dao.LessonDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import model.Course;
import model.Lesson;
import model.Module;
import model.User;

public class LessonListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User sme = (User) session.getAttribute("account");

        CourseDAO courseDAO = new CourseDAO();
        ModuleDAO moduleDAO = new ModuleDAO();
        LessonDAO lessonDAO = new LessonDAO();

        List<Course> courses = courseDAO.getCoursesBySME(sme.getUserId(), null);

        String moduleIdRaw = request.getParameter("moduleId");
        String courseIdRaw = request.getParameter("courseId");

        int courseId;

        try {

            if (moduleIdRaw != null && !moduleIdRaw.isBlank()) {

                int moduleId = Integer.parseInt(moduleIdRaw);

                Module m = moduleDAO.getModuleById(moduleId);

                if (m == null) {
                    response.sendRedirect(request.getContextPath() + "/courselist");
                    return;
                }

                courseId = m.getCourseId();

            } else {

                if (courseIdRaw == null || courseIdRaw.isBlank()) {

                    if (courses.isEmpty()) {
                        request.setAttribute("courseList", courses);
                        request.getRequestDispatcher("/lesson/lessonlist.jsp")
                                .forward(request, response);
                        return;
                    }

                    courseId = courses.get(0).getCourseId();

                } else {
                    courseId = Integer.parseInt(courseIdRaw);
                }
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/courselist");
            return;
        }

        Course course = courseDAO.getCourseById(courseId);

        if (course == null) {
            response.sendRedirect(request.getContextPath() + "/courselist");
            return;
        }

        List<Module> modules = moduleDAO.getModulesByCourse(courseId);

        HashMap<Integer, List<Lesson>> lessonMap = new HashMap<>();

        for (Module m : modules) {
            lessonMap.put(m.getModuleId(),
                    lessonDAO.getLessonsByModule(m.getModuleId()));
        }

        request.setAttribute("courseList", courses);
        request.setAttribute("course", course);
        request.setAttribute("moduleList", modules);
        request.setAttribute("lessonMap", lessonMap);

        request.getRequestDispatcher("/lesson/lessonlist.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
