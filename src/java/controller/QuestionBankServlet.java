package controller;

import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class QuestionBankServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        QuestionDAO dao = new QuestionDAO();

        request.setAttribute("questionList", dao.getAllQuestions());

        request.getRequestDispatcher("/question/questionbank.jsp")
                .forward(request, response);
    }
}
