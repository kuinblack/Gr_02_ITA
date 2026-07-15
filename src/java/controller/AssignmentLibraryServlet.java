package controller;

import dao.AssignmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AssignmentDTO;
import model.User;

public class AssignmentLibraryServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Kiểm tra đăng nhập
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("account");

        // Chỉ cho phép sinh viên (RoleId = 3) truy cập
        if (user.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/smedashboard");
            return;
        }

        try {
            // Lấy danh sách bài tập kèm trạng thái nộp/chấm điểm dựa theo userId của sinh viên
            List<AssignmentDTO> studentLibrary = assignmentDAO.getAssignmentLibraryForStudent(user.getUserId());
            request.setAttribute("assignmentList", studentLibrary);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách bài tập: " + e.getMessage());
        }

        request.getRequestDispatcher("/student/assignmentlibrary.jsp")
                .forward(request, response);
    }
}
