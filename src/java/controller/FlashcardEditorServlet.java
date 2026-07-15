package controller;

import dao.FlashcardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Flashcard;
import model.User;

public class FlashcardEditorServlet extends HttpServlet {

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

        String idRaw = request.getParameter("id");

        if (idRaw != null && !idRaw.isBlank()) {

            try {
                Flashcard f = dao.getFlashcardById(Integer.parseInt(idRaw));
                request.setAttribute("flashcard", f);
            } catch (NumberFormatException ignored) {
            }
        }

        request.getRequestDispatcher("/flashcard/flashcardeditor.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        Flashcard card = new Flashcard();

        card.setModuleId(Integer.parseInt(request.getParameter("moduleId")));
        card.setQuestion(request.getParameter("frontContent"));
        card.setAnswer(request.getParameter("backContent"));
        card.setCreatedBy(user.getUserId());

        String idRaw = request.getParameter("flashcardId");

        if (idRaw == null || idRaw.isBlank()) {

            dao.addFlashcard(card);

        } else {

            card.setFlashcardId(Integer.parseInt(idRaw));
            dao.updateFlashcard(card);
        }

        response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
    }
}
