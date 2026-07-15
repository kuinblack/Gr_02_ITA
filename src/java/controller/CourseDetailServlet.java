package controller;

import dao.CourseDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Course;
import model.User;

public class CourseDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        String raw = request.getParameter("id");

        if (raw == null || raw.isBlank()) {
            response.sendRedirect("courseview");
            return;
        }

        int courseId = Integer.parseInt(raw);

        CourseDAO courseDAO = new CourseDAO();
        ModuleDAO moduleDAO = new ModuleDAO();

        Course course = courseDAO.getCourseById(courseId);

        if (course == null) {
            response.sendRedirect("courseview");
            return;
        }

        request.setAttribute("course", course);
        request.setAttribute("moduleList",
                moduleDAO.getModulesByCourse(courseId));

        request.getRequestDispatcher("/course/coursedetail.jsp")
                .forward(request, response);
    }
}