package controller;

import dao.FlashcardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Flashcard;
import model.User;

public class FlashcardPracticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String moduleParam = request.getParameter("moduleId");
        String courseParam = request.getParameter("courseId"); // Nhận thêm courseId để phục vụ việc Back về

        if (moduleParam == null || moduleParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        try {
            int moduleId = Integer.parseInt(moduleParam.trim());

            // Giữ lại courseId, nếu đường dẫn trước quên truyền thì mặc định xử lý tránh lỗi (ví dụ bằng 1)
            int courseId = (courseParam != null && !courseParam.trim().isEmpty())
                    ? Integer.parseInt(courseParam.trim()) : 1;

            FlashcardDAO dao = new FlashcardDAO();
            ArrayList<Flashcard> cards = dao.getFlashcardsByModule(moduleId);

            // Gửi dữ liệu sang JSP scope
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("courseId", courseId);
            request.setAttribute("cards", cards);

            request.getRequestDispatcher("/flashcard/flashcardpractice.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
        }
    }
}
