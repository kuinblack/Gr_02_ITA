package controller;

import dao.AssignmentDAO;
import dao.ClassDAO;
import dao.RubricDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.List;
import model.Assignment;
import model.Rubric;
import model.User;

public class AssignmentDetailServlet extends HttpServlet {

    private final AssignmentDAO assignmentDAO = new AssignmentDAO();
    private final RubricDAO rubricDAO = new RubricDAO();
    private final ClassDAO classDAO = new ClassDAO();

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

        if (user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        request.setAttribute("classList", classDAO.getAllClasses());

        String idRaw = request.getParameter("id");

        Assignment assignment = null;
        List<Rubric> rubricList = null;
        String deadlineValue = null;

        if (idRaw != null && !idRaw.isBlank()) {

            int id = Integer.parseInt(idRaw);

            assignment = assignmentDAO.getById(id);
            rubricList = rubricDAO.getRubricsByAssignment(id);

            if (assignment != null && assignment.getDeadline() != null) {
                deadlineValue = assignment.getDeadline()
                        .toLocalDateTime()
                        .toString();
            }
        }

        request.setAttribute("assignment", assignment);
        request.setAttribute("rubricList", rubricList);
        request.setAttribute("deadlineValue", deadlineValue);

        request.getRequestDispatcher("/assignment/assignmentdetail.jsp")
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

        if (sme.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/studentdashboard");
            return;
        }

        String action = request.getParameter("action");

        try {

            switch (action) {

                case "saveAssignment" -> {

                    String idRaw = request.getParameter("assignmentId");

                    Assignment a = new Assignment();

                    a.setClassId(
                            Integer.parseInt(request.getParameter("classId"))
                    );

                    a.setTitle(request.getParameter("title"));
                    a.setDescription(request.getParameter("description"));

                    String deadline = request.getParameter("deadline");

                    if (deadline != null && !deadline.isBlank()) {
                        a.setDeadline(
                                Timestamp.valueOf(
                                        deadline.replace("T", " ") + ":00"
                                )
                        );
                    }

                    BigDecimal totalScore
                            = new BigDecimal(request.getParameter("totalScore"));

                    if (totalScore.compareTo(BigDecimal.ZERO) < 0) {
                        throw new IllegalArgumentException("Invalid total score");
                    }

                    a.setTotalScore(totalScore);
                    a.setCreatedBy(sme.getUserId());

                    // CREATE
                    if (idRaw == null || idRaw.isBlank()) {
                        assignmentDAO.insert(a);
                    } else {
                        // UPDATE
                        a.setAssignmentId(Integer.parseInt(idRaw));
                        assignmentDAO.update(a);
                    }

                    response.sendRedirect(
                            request.getContextPath() + "/assignmentlist"
                    );
                    return;
                }

                case "deleteAssignment" -> {

                    int id = Integer.parseInt(
                            request.getParameter("assignmentId")
                    );

                    assignmentDAO.delete(id);

                    response.sendRedirect(
                            request.getContextPath() + "/assignmentlist"
                    );
                    return;
                }

                case "addRubric" -> {

                    Rubric r = new Rubric();

                    r.setAssignmentId(
                            Integer.parseInt(request.getParameter("assignmentId"))
                    );

                    r.setCriteria(request.getParameter("criteria"));

                    r.setWeight(
                            new BigDecimal(request.getParameter("weight"))
                    );

                    r.setDescription(
                            request.getParameter("rubricDescription")
                    );

                    rubricDAO.insertRubric(r);

                    response.sendRedirect(
                            request.getContextPath()
                            + "/assignmentdetail?id="
                            + r.getAssignmentId()
                    );
                    return;
                }

                case "deleteRubric" -> {

                    int rubricId = Integer.parseInt(
                            request.getParameter("rubricId")
                    );

                    int assignmentId = Integer.parseInt(
                            request.getParameter("assignmentId")
                    );

                    rubricDAO.deleteRubric(rubricId);

                    response.sendRedirect(
                            request.getContextPath()
                            + "/assignmentdetail?id="
                            + assignmentId
                    );
                    return;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/assignmentlist");
    }
}
