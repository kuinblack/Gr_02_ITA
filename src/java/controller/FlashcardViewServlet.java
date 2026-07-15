package controller;

import dao.FlashcardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class FlashcardViewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra quyền đăng nhập
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        // Phân quyền: Chỉ cho phép Student (RoleId = 3) truy cập học tập
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
            int courseId = Integer.parseInt(rawCourseId.trim());

            FlashcardDAO dao = new FlashcardDAO();

            // Đẩy ngược lại courseId sang JSP để phục vụ tính năng điều hướng quay lại
            request.setAttribute("courseId", courseId);
            request.setAttribute("moduleList", dao.getModulesByCourse(courseId));

            request.getRequestDispatcher("/flashcard/flashcardview.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseview");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
