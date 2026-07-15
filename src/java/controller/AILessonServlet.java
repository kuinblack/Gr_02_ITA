package controller;

import dao.AILessonDraftDAO;
import dao.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AILessonDraft;
import model.Lesson;
import model.User;
import service.AIService;

public class AILessonServlet extends HttpServlet {

    private final LessonDAO lessonDAO = new LessonDAO();
    private final AILessonDraftDAO draftDAO = new AILessonDraftDAO();
    private final AIService aiService = new AIService();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load all lessons for dropdown
        List<Lesson> lessons = lessonDAO.getAllLessons();
        request.setAttribute("lessonList", lessons);

        // If opening from AI Draft Queue
        String draftIdRaw = request.getParameter("draftId");

        if (draftIdRaw != null && !draftIdRaw.isBlank()) {

            try {

                int draftId = Integer.parseInt(draftIdRaw);

                AILessonDraft draft = draftDAO.getDraftById(draftId);

                if (draft != null) {
                    request.setAttribute("draft", draft);
                    request.setAttribute("selectedLessonId", draft.getLessonId());
                    request.setAttribute("prompt", draft.getPrompt());
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // IMPORTANT: forward to ailesson.jsp
        request.getRequestDispatcher("/lesson/ailesson.jsp")
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

        String action = request.getParameter("action");

        // =====================================================
        // GENERATE AI DRAFT
        // =====================================================
        if ("generate".equals(action)) {

            int lessonId = Integer.parseInt(request.getParameter("lessonId"));
            String prompt = request.getParameter("prompt");

            String generated = aiService.generateLesson(prompt);

            AILessonDraft draft = new AILessonDraft();
            draft.setLessonId(lessonId);
            draft.setPrompt(prompt);
            draft.setGeneratedContent(generated);
            draft.setStatus("Pending");
            draft.setSourceType("Prompt");

            int draftId = draftDAO.insertDraft(draft);

            response.sendRedirect(request.getContextPath()
                    + "/ailesson?draftId=" + draftId);

            return;
        }

        // =====================================================
        // APPLY / APPROVE / REJECT
        // =====================================================
        int draftId = Integer.parseInt(request.getParameter("draftId"));
        String finalContent = request.getParameter("finalContent");

        AILessonDraft draft = draftDAO.getDraftById(draftId);

        if (draft == null) {
            response.sendRedirect(request.getContextPath() + "/aidrafts");
            return;
        }

        Lesson lesson = lessonDAO.getLessonById(draft.getLessonId());

        switch (action) {

            case "apply":

                // Save edited content to draft only
                draftDAO.updateGeneratedContent(draftId, finalContent);

                response.sendRedirect(request.getContextPath()
                        + "/ailesson?draftId=" + draftId);
                return;

            case "approve":

                // Publish to lesson
                lesson.setContent(finalContent);
                lessonDAO.updateLesson(lesson);

                // Mark draft approved
                draftDAO.approveDraft(draftId, finalContent, user.getUserId());

                response.sendRedirect(request.getContextPath() + "/aidrafts");
                return;

            case "reject":

                draftDAO.rejectDraft(draftId, user.getUserId());

                response.sendRedirect(request.getContextPath() + "/aidrafts");
                return;

            default:
                response.sendRedirect(request.getContextPath() + "/ailesson");
        }
    }
}
