package controller;

import dao.AssignmentDAO;
import dao.SubmissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Assignment;
import model.Submission;
import model.Result; // Đảm bảo bạn đã import model Result của project
import model.User;

@WebServlet(name = "AssignmentResultServlet", urlPatterns = {"/assignmentresult"})
public class AssignmentResultServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final SubmissionDAO submissionDAO = new SubmissionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");
        
        try {
            String assignmentIdRaw = request.getParameter("assignmentId");
            if (assignmentIdRaw == null || assignmentIdRaw.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã bài tập (assignmentId).");
                return;
            }

            int assignmentId = Integer.parseInt(assignmentIdRaw);

            // 1. Lấy thông tin chi tiết bài tập được giao
            Assignment assignment = assignmentDAO.getById(assignmentId);
            if (assignment == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy bài tập yêu cầu.");
                return;
            }
            request.setAttribute("assignment", assignment);

            // 2. Lấy thông tin bài nộp của sinh viên hiện tại
            Submission submission = submissionDAO.getSubmission(assignmentId, user.getUserId());
            request.setAttribute("submission", submission);

            // 3. Nếu sinh viên đã nộp bài, truy vấn bảng Result để lấy điểm số và nhận xét
            if (submission != null) {
                // Hãy đảm bảo trong SubmissionDAO của bạn có hàm getResultBySubmissionId hoặc tương đương
                Result result = submissionDAO.getResultBySubmission(submission.getSubmissionId());
                request.setAttribute("result", result);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã bài tập không đúng định dạng số.");
            return;
        } catch (Exception e) {
            e.printStackTrace(); 
            throw new ServletException("Đã xảy ra lỗi hệ thống khi tải kết quả.", e);
        }

        // Điều hướng đến trang kết quả
        request.getRequestDispatcher("/student/assignmentresult.jsp").forward(request, response);
    }
}