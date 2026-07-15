package controller;

import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Question;
import model.User;

public class AIQuestionStagingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/question/aiquestionstaging.jsp")
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
        int moduleId = Integer.parseInt(request.getParameter("moduleId"));

        QuestionDAO dao = new QuestionDAO();

        if ("generate".equals(action)) {

            String input = request.getParameter("inputText");

            List<Question> staged = generateQuestions(moduleId, input);

            request.setAttribute("moduleId", moduleId);
            request.setAttribute("inputText", input);
            request.setAttribute("stagedQuestions", staged);

            request.getRequestDispatcher("/question/aiquestionstaging.jsp")
                    .forward(request, response);

            return;
        }

        if ("approve".equals(action)) {

            String[] contents = request.getParameterValues("content");
            String[] types = request.getParameterValues("questionType");
            String[] selected = request.getParameterValues("selectedQuestion");

            if (contents != null && types != null && selected != null) {

                for (String idxStr : selected) {

                    int idx = Integer.parseInt(idxStr);

                    if (idx >= contents.length || idx >= types.length) {
                        continue;
                    }

                    Question q = new Question();
                    q.setModuleId(moduleId);
                    q.setContent(contents[idx]);
                    q.setQuestionType(types[idx]);
                    q.setCreatedBy(user.getUserId());

                    dao.insertQuestion(q);
                }
            }

            response.sendRedirect(request.getContextPath() + "/questionbank");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/questionbank");
    }

    private List<Question> generateQuestions(int moduleId, String text) {

        List<Question> list = new ArrayList<>();

        if (text == null || text.isBlank()) {
            return list;
        }

        String[] lines = text.split("\\r?\\n");

        for (String line : lines) {

            line = line.trim();

            if (line.isBlank()) {
                continue;
            }

            Question q = new Question();
            q.setModuleId(moduleId);
            q.setContent("Explain: " + line);
            q.setQuestionType("Essay");

            list.add(q);
        }

        return list;
    }
}
