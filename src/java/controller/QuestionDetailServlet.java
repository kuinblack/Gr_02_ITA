package controller;

import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Question;
import model.User;

public class QuestionDetailServlet extends HttpServlet {

    private final QuestionDAO dao = new QuestionDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idRaw = request.getParameter("id");

        if (idRaw != null && !idRaw.isBlank()) {

            Question q = dao.getQuestionById(Integer.parseInt(idRaw));
            request.setAttribute("question", q);
        }

        request.getRequestDispatcher("/question/questiondetail.jsp")
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

        User sme = (User) session.getAttribute("account");

        String action = request.getParameter("action");

        try {

            if ("save".equals(action)) {

                String idRaw = request.getParameter("questionId");

                Question q = new Question();

                q.setModuleId(Integer.parseInt(request.getParameter("moduleId")));
                q.setContent(request.getParameter("content"));
                q.setQuestionType(request.getParameter("questionType"));
                q.setCreatedBy(sme.getUserId());

                if (idRaw == null || idRaw.isBlank()) {
                    dao.insertQuestion(q);
                } else {
                    q.setQuestionId(Integer.parseInt(idRaw));
                    dao.updateQuestion(q);
                }

            } else if ("delete".equals(action)) {

                int questionId = Integer.parseInt(request.getParameter("questionId"));
                dao.deleteQuestion(questionId);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/questionbank");
    }
}

