package controller;

import dao.FlashcardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Flashcard;
import model.User;

public class AIFlashcardStagingServlet extends HttpServlet {

    private final FlashcardDAO flashcardDAO = new FlashcardDAO();

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

        int moduleId = getModuleId(request);

        if (moduleId <= 0) {
            response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
            return;
        }

        request.setAttribute("moduleId", moduleId);
        request.setAttribute("moduleName", flashcardDAO.getModuleName(moduleId));

        request.getRequestDispatcher("/flashcard/aiflashcardstaging.jsp")
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

        int moduleId = getModuleId(request);

        if (moduleId <= 0) {
            response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
            return;
        }

        String action = request.getParameter("action");

        // ===== GENERATE =====
        if ("generate".equals(action)) {

            String input = request.getParameter("inputText");

            List<Flashcard> staged = generateFlashcards(moduleId, input);

            request.setAttribute("moduleId", moduleId);
            request.setAttribute("moduleName", flashcardDAO.getModuleName(moduleId));
            request.setAttribute("inputText", input);
            request.setAttribute("stagedCards", staged);

            request.getRequestDispatcher("/flashcard/aiflashcardstaging.jsp")
                    .forward(request, response);
            return;
        }

        // ===== IMPORT =====
        if ("import".equals(action)) {

            String[] fronts = request.getParameterValues("stagedFront");
            String[] backs = request.getParameterValues("stagedBack");
            String[] selected = request.getParameterValues("selectedCard");

            if (fronts != null && backs != null && selected != null) {

                for (String idxStr : selected) {

                    int idx;

                    try {
                        idx = Integer.parseInt(idxStr);
                    } catch (NumberFormatException e) {
                        continue;
                    }

                    if (idx < 0 || idx >= fronts.length || idx >= backs.length) {
                        continue;
                    }

                    String front = fronts[idx] == null ? "" : fronts[idx].trim();
                    String back = backs[idx] == null ? "" : backs[idx].trim();

                    if (front.isBlank() || back.isBlank()) {
                        continue;
                    }

                    Flashcard card = new Flashcard();
                    card.setModuleId(moduleId);
                    card.setQuestion(front);
                    card.setAnswer(back);
                    card.setCreatedBy(user.getUserId());

                    flashcardDAO.addFlashcard(card);
                }
            }

            response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/flashcardlibrary");
    }

    // ================= SAFE MODULE ID =================
    private int getModuleId(HttpServletRequest request) {

        String raw = request.getParameter("moduleId");

        if (raw == null || raw.isBlank()) {
            return -1;
        }

        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return -1;
        }
    }

    // ================= SIMPLE AI GENERATOR =================
    private List<Flashcard> generateFlashcards(int moduleId, String text) {

        List<Flashcard> list = new ArrayList<>();

        if (text == null || text.isBlank()) {
            return list;
        }

        String[] lines = text.split("\\r?\\n");

        for (String line : lines) {

            line = line.trim();

            if (line.isBlank()) {
                continue;
            }

            Flashcard card = new Flashcard();
            card.setModuleId(moduleId);

            if (line.contains(":")) {

                String[] parts = line.split(":", 2);

                card.setQuestion(parts[0].trim());
                card.setAnswer(parts[1].trim());

            } else {

                card.setQuestion(line);
                card.setAnswer("Definition of " + line);
            }

            list.add(card);
        }

        return list;
    }
}
