package controller;

import dao.AILessonDraftDAO;
import dao.LessonDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.AILessonDraft;
import model.User;

public class AILessonActionServlet extends HttpServlet {

    private final AILessonDraftDAO draftDAO = new AILessonDraftDAO();
    private final LessonDAO lessonDAO = new LessonDAO();

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
        int draftId = Integer.parseInt(request.getParameter("draftId"));
        String finalContent = request.getParameter("finalContent");

        AILessonDraft draft = draftDAO.getDraftById(draftId);

        if (draft == null) {
            response.sendRedirect(request.getContextPath() + "/aidrafts");
            return;
        }

        switch (action) {

            case "apply":

                // Chỉ cập nhật nội dung draft
                draftDAO.updateGeneratedContent(draftId, finalContent);
                break;

            case "approve":

                // Cập nhật nội dung cuối cùng của draft
                draftDAO.approveDraft(draftId, finalContent, user.getUserId());

                // Publish sang Lesson
                lessonDAO.publishContent(
                        draft.getLessonId(),
                        finalContent,
                        user.getUserId()
                );
                break;

            case "reject":

                draftDAO.rejectDraft(draftId, user.getUserId());
                break;
        }

        response.sendRedirect(
                request.getContextPath()
                + "/ailesson?draftId=" + draftId
        );
    }
}
