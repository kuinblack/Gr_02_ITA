package controller;

import dao.CourseDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.Course;
import model.User;

public class CourseListServlet extends HttpServlet {

    // ===================== GET =====================
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String keyword = request.getParameter("keyword");

        CourseDAO dao = new CourseDAO();

        List<Course> courseList
                = dao.getCoursesBySME(user.getUserId(), keyword);

        request.setAttribute("courseList", courseList);

        request.getRequestDispatcher("/course/courselist.jsp")
                .forward(request, response);
    }

    // ===================== POST (CRUD) =====================
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("account");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        CourseDAO dao = new CourseDAO();

        try {

            // CREATE
            if ("create".equals(action)) {

                Course c = new Course();

                c.setTitle(request.getParameter("title"));
                c.setDescription(request.getParameter("description"));
                c.setThumbnailUrl(request.getParameter("thumbnailUrl"));

                String priceStr = request.getParameter("price");

                c.setPrice(priceStr == null || priceStr.isBlank()
                        ? BigDecimal.ZERO
                        : new BigDecimal(priceStr));

                c.setCreatedBy(user.getUserId());
                c.setStatus(request.getParameter("status"));

                dao.insertCourse(c);
            } // UPDATE
            else if ("update".equals(action)) {

                Course c = new Course();

                c.setCourseId(
                        Integer.parseInt(request.getParameter("courseId")));

                c.setTitle(request.getParameter("title"));
                c.setDescription(request.getParameter("description"));
                c.setThumbnailUrl(request.getParameter("thumbnailUrl"));

                String priceStr = request.getParameter("price");

                c.setPrice(priceStr == null || priceStr.isBlank()
                        ? BigDecimal.ZERO
                        : new BigDecimal(priceStr));

                c.setStatus(request.getParameter("status"));

                dao.updateCourse(c);
            } // DELETE
            else if ("delete".equals(action)) {

                int courseId
                        = Integer.parseInt(request.getParameter("courseId"));

                dao.deleteCourse(courseId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/courselist");
    }
}
