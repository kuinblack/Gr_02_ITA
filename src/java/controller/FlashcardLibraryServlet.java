package controller;

import dao.FlashcardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;

public class FlashcardLibraryServlet extends HttpServlet {

    private final FlashcardDAO dao = new FlashcardDAO();

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

        // Chỉ SME
        if (user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        request.setAttribute("flashcardList", dao.getAll());

        request.getRequestDispatcher("/flashcard/flashcardlibrary.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        if (user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        String action = request.getParameter("action");

        if ("delete".equals(action)) {

            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteFlashcard(id);
            } catch (Exception ignored) {
            }
        }

        response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
    }
}
