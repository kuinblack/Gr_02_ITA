package controller;

import dao.QuestionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Question;
import model.QuestionOption;
import model.User;

public class StudentQuestionPracticeServlet extends HttpServlet {

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

        // 1. Kiểm tra tham số moduleId bắt buộc
        String rawModuleId = request.getParameter("moduleId");
        if (rawModuleId == null || rawModuleId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/courseview");
            return;
        }

        try {
            int moduleId = Integer.parseInt(rawModuleId);
            QuestionDAO dao = new QuestionDAO();
            List<Question> questions = dao.getQuestionsByModule(moduleId);

            if (questions == null || questions.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/courseview");
                return;
            }

            // 2. Xác định chỉ mục câu hỏi bắt đầu (currentIndex)
            int currentIndex = 0; // Mặc định là câu đầu tiên (index = 0)
            String rawStartFrom = request.getParameter("startFrom");

            if (rawStartFrom != null && !rawStartFrom.isBlank()) {
                try {
                    int startQuestionId = Integer.parseInt(rawStartFrom);
                    // Duyệt danh sách để tìm vị trí trùng khớp với questionId được chọn
                    for (int i = 0; i < questions.size(); i++) {
                        if (questions.get(i).getQuestionId() == startQuestionId) {
                            currentIndex = i;
                            break;
                        }
                    }
                } catch (NumberFormatException e) {
                    // Bỏ qua nếu startFrom không hợp lệ, giữ currentIndex = 0
                }
            }

            // 3. Đẩy thông tin sang JSP
            request.setAttribute("moduleId", moduleId);
            request.setAttribute("questionList", questions);
            request.setAttribute("currentIndex", currentIndex); // Đẩy vị trí câu hỏi cần active lên giao diện

            request.getRequestDispatcher("/student/questionpractice.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseview");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String rawModuleId = request.getParameter("moduleId");
        if (rawModuleId == null || rawModuleId.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/courseview");
            return;
        }

        try {
            int moduleId = Integer.parseInt(rawModuleId);
            QuestionDAO dao = new QuestionDAO();
            List<Question> questions = dao.getQuestionsByModule(moduleId);

            int score = 0;

            for (Question q : questions) {
                String answer = request.getParameter("q" + q.getQuestionId());

                if (answer == null || answer.trim().isEmpty()) {
                    continue;
                }

                // 1. Xử lý MCQ (Trắc nghiệm) & TrueFalse (Đúng / Sai) dựa trên Option ID
                if ("MCQ".equals(q.getQuestionType()) || "TrueFalse".equals(q.getQuestionType())) {
                    try {
                        int submittedOptionId = Integer.parseInt(answer.trim());

                        for (QuestionOption o : q.getOptions()) {
                            // So khớp xem Option ID được sinh viên chọn có phải là đáp án đúng (isCorrect) không
                            if (o.getOptionId() == submittedOptionId && o.isCorrect()) {
                                score++;
                                break;
                            }
                        }
                    } catch (NumberFormatException e) {
                        // Tránh crash nếu dữ liệu gửi lên không đúng định dạng số
                    }
                } // 2. Xử lý Essay (Tự luận)
                else if ("Essay".equals(q.getQuestionType())) {
                    if (answer.trim().length() > 0) {
                        score++; // Tạm tính điểm nếu học sinh đã nhập câu trả lời
                    }
                }
            }

            request.setAttribute("moduleId", moduleId);
            request.setAttribute("questionList", questions);
            request.setAttribute("score", score);
            request.setAttribute("total", questions.size());
            request.setAttribute("submitted", true);
            request.setAttribute("currentIndex", 0); // Reset về câu đầu tiên sau khi submit để hiển thị kết quả tổng quan

            request.getRequestDispatcher("/student/questionpractice.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/courseview");
        }
    }
}
