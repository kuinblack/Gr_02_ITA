package controller;

import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Question;
import model.User;

public class QuestionImportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/question/questionimport.jsp")
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

        int moduleId = Integer.parseInt(request.getParameter("moduleId"));

        String bulk = request.getParameter("bulkContent");

        QuestionDAO dao = new QuestionDAO();

        if (bulk != null && !bulk.isBlank()) {

            String[] lines = bulk.split("\\r?\\n");

            List<Question> questions = new ArrayList<>();

            for (String line : lines) {

                if (line.isBlank()) {
                    continue;
                }

                Question q = new Question();

                q.setModuleId(moduleId);
                q.setContent(line.trim());
                q.setQuestionType("MCQ");
                q.setCreatedBy(sme.getUserId());

                questions.add(q);
            }

            dao.importQuestions(questions);
        }

        response.sendRedirect(request.getContextPath() + "/questionbank");
    }
}
