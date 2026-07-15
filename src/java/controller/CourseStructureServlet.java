package controller;

import dao.CourseDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Course;
import model.Module;

public class CourseStructureServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null || idRaw.isBlank()) {
            response.sendRedirect("courselist");
            return;
        }

        int courseId = Integer.parseInt(idRaw);

        CourseDAO courseDAO = new CourseDAO();
        ModuleDAO moduleDAO = new ModuleDAO();

        Course course = courseDAO.getCourseById(courseId);

        if (course == null) {
            response.sendRedirect("courselist");
            return;
        }

        List<Module> moduleList = moduleDAO.getModulesByCourse(courseId);

        request.setAttribute("course", course);
        request.setAttribute("moduleList", moduleList);

        request.getRequestDispatcher("/course/coursestructure.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        int courseId = Integer.parseInt(request.getParameter("courseId"));

        ModuleDAO dao = new ModuleDAO();

        try {

            switch (action) {

                case "create" -> {

                    Module m = new Module();
                    m.setCourseId(courseId);
                    m.setModuleTitle(request.getParameter("moduleTitle"));
                    m.setDisplayOrder(Integer.parseInt(
                            request.getParameter("displayOrder")));

                    dao.insertModule(m);
                }

                case "update" -> {

                    Module m = new Module();
                    m.setModuleId(Integer.parseInt(
                            request.getParameter("moduleId")));
                    m.setModuleTitle(request.getParameter("moduleTitle"));
                    m.setDisplayOrder(Integer.parseInt(
                            request.getParameter("displayOrder")));

                    dao.updateModule(m);
                }

                case "delete" -> {

                    int moduleId = Integer.parseInt(
                            request.getParameter("moduleId"));

                    dao.deleteModule(moduleId);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("coursestructure?id=" + courseId);
    }
}
