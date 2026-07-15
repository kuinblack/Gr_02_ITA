package controller;

import dao.AILessonDraftDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AILessonDraft;
import model.User;

public class AIDraftQueueServlet extends HttpServlet {

    private final AILessonDraftDAO draftDAO = new AILessonDraftDAO();

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

        // role_id = 2 là SME (sửa theo DB của bạn nếu khác)
        if (user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        List<AILessonDraft> drafts = draftDAO.getAllDrafts();

        request.setAttribute("drafts", drafts);

        request.getRequestDispatcher("/lesson/aidraftqueue.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}
