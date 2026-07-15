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

public class AILessonStagingServlet extends HttpServlet {

    private final LessonDAO lessonDAO = new LessonDAO();
    private final AILessonDraftDAO draftDAO = new AILessonDraftDAO();
    private final AIService aiService = new AIService();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Lesson> lessons = lessonDAO.getAllLessons();
        request.setAttribute("lessons", lessons);

        request.getRequestDispatcher("/lesson/ailessonstaging.jsp")
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

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));
        String prompt = request.getParameter("prompt");

        String generated = aiService.generateLesson(prompt);

        AILessonDraft draft = new AILessonDraft();
        draft.setLessonId(lessonId);
        draft.setPrompt(prompt);
        draft.setGeneratedContent(generated);
        draft.setStatus("Pending");
        draft.setSourceType("Prompt");

        draftDAO.insertDraft(draft);

        List<Lesson> lessons = lessonDAO.getAllLessons();

        request.setAttribute("lessons", lessons);
        request.setAttribute("aiLessonDraft", draft);

        request.getRequestDispatcher("/lesson/ailessonstaging.jsp")
                .forward(request, response);
    }
}
