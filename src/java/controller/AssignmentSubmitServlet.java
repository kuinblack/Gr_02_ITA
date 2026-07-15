package controller;

import dao.AssignmentDAO;
import dao.SubmissionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import model.Assignment;
import model.Submission;
import model.User;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class AssignmentSubmitServlet extends HttpServlet {

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

        User student = (User) session.getAttribute("account");
        if (student.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        String assignmentIdParam = request.getParameter("assignmentId");
        if (assignmentIdParam == null || assignmentIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing assignmentId parameter.");
            return;
        }

        try {
            int assignmentId = Integer.parseInt(assignmentIdParam);
            Assignment assignment = assignmentDAO.getById(assignmentId);
            Submission submission = submissionDAO.getSubmission(assignmentId, student.getUserId());

            boolean isOverdue = false;
            if (assignment != null && assignment.getDeadline() != null) {
                if (System.currentTimeMillis() > assignment.getDeadline().getTime()) {
                    isOverdue = true;
                }
            }

            request.setAttribute("assignment", assignment);
            request.setAttribute("submission", submission);
            request.setAttribute("isOverdue", isOverdue);

            request.getRequestDispatcher("/student/assignmentsubmit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid assignmentId format.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        // 1. Kiểm tra xác thực & phân quyền bảo mật đầu POST
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User student = (User) session.getAttribute("account");
        if (student.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        String assignmentIdParam = request.getParameter("assignmentId");
        if (assignmentIdParam == null || assignmentIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing assignmentId parameter on submission.");
            return;
        }

        int assignmentId = Integer.parseInt(assignmentIdParam);

        try {
            Assignment assignment = assignmentDAO.getById(assignmentId);

            // 2. Kiểm tra hạn nộp bài tập chặn gửi bài quá hạn
            if (assignment != null && assignment.getDeadline() != null) {
                if (System.currentTimeMillis() > assignment.getDeadline().getTime()) {
                    session.setAttribute("toastError", "Không thể nộp bài! Bài tập này đã quá hạn nộp.");
                    response.sendRedirect(request.getContextPath() + "/assignmentsubmit?assignmentId=" + assignmentId);
                    return;
                }
            }

            // 3. Đọc dữ liệu mô tả (comments) từ form
            String comments = request.getParameter("comments");
            Submission oldSubmission = submissionDAO.getSubmission(assignmentId, student.getUserId());
            String fileUrl = (oldSubmission != null) ? oldSubmission.getFileUrl() : null;

            // 4. Xử lý tải lên file bài làm
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // Tạo đầy đủ cây thư mục nếu cần thiết
                }

                // Đặt tên file không trùng lặp tránh ghi đè bài của sinh viên khác
                String uniqueFileName = student.getUserId() + "_" + assignmentId + "_" + System.currentTimeMillis() + "_" + fileName;
                String fullPath = uploadPath + File.separator + uniqueFileName;

                filePart.write(fullPath);
                fileUrl = "uploads/" + uniqueFileName;
            }

            // 5. Lưu thông tin nộp bài xuống database
            submissionDAO.saveOrUpdateSubmission(assignmentId, student.getUserId(), comments, fileUrl);

            // Gửi thông báo thành công và chuyển hướng về trang chi tiết nộp bài
            session.setAttribute("toastMessage", "Nộp bài thành công! Bạn có thể xem hoặc cập nhật bài làm bên dưới.");
            response.sendRedirect(request.getContextPath() + "/assignmentsubmit?assignmentId=" + assignmentId);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi, thiết lập thông báo lỗi và quay trở lại màn hình gửi bài thay vì để trắng màn hình
            session.setAttribute("toastError", "Đã xảy ra lỗi trong quá trình nộp bài: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/assignmentsubmit?assignmentId=" + assignmentId);
        }
    }
}
