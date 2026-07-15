package controller;

import dao.ModuleDAO;
import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;
import model.Module;
import model.Question;
import model.User;

public class StudentQuestionListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User student = (User) session.getAttribute("account");

        if (student.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        String rawModuleId = request.getParameter("moduleId");
        String filterType = request.getParameter("type"); // Lấy bộ lọc loại câu hỏi

        if (rawModuleId == null || rawModuleId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/courseview");
            return;
        }

        try {
            int moduleId = Integer.parseInt(rawModuleId);

            ModuleDAO moduleDAO = new ModuleDAO();
            QuestionDAO questionDAO = new QuestionDAO();

            Module module = moduleDAO.getModuleById(moduleId);

            if (module == null) {
                response.sendRedirect(request.getContextPath() + "/courseview");
                return;
            }

            // Lấy toàn bộ câu hỏi của module
            List<Question> allQuestions = questionDAO.getQuestionsByModule(moduleId);

            // Xử lý lọc dữ liệu theo loại nếu người dùng có yêu cầu
            List<Question> filteredList = allQuestions;
            if (filterType != null && !filterType.isBlank() && !filterType.equals("All")) {
                filteredList = allQuestions.stream()
                        .filter(q -> q.getQuestionType().equalsIgnoreCase(filterType))
                        .collect(Collectors.toList());
            }

            // Đếm số lượng của từng loại câu hỏi để hiển thị trên các thẻ thống kê
            long mcqCount = allQuestions.stream().filter(q -> q.getQuestionType().equalsIgnoreCase("MCQ")).count();
            long tfCount = allQuestions.stream().filter(q -> q.getQuestionType().equalsIgnoreCase("True/False") || q.getQuestionType().equalsIgnoreCase("TF")).count();
            long essayCount = allQuestions.stream().filter(q -> q.getQuestionType().equalsIgnoreCase("Essay")).count();

            // Đẩy dữ liệu ra ngoài JSP
            request.setAttribute("module", module);
            request.setAttribute("questionList", filteredList);
            request.setAttribute("selectedType", filterType != null ? filterType : "All");

            request.setAttribute("totalCount", allQuestions.size());
            request.setAttribute("mcqCount", mcqCount);
            request.setAttribute("tfCount", tfCount);
            request.setAttribute("essayCount", essayCount);

            request.getRequestDispatcher("/student/questionlist.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
