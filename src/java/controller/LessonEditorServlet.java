package controller;

import dao.LessonDAO;
import dao.ModuleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Lesson;
import model.Module;
import model.User;

public class LessonEditorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        LessonDAO lessonDAO = new LessonDAO();
        ModuleDAO moduleDAO = new ModuleDAO();

        String lessonIdRaw = request.getParameter("lessonId");
        String moduleIdRaw = request.getParameter("moduleId");

        try {

            if (lessonIdRaw != null && !lessonIdRaw.isBlank()) {

                int lessonId = Integer.parseInt(lessonIdRaw);

                Lesson lesson = lessonDAO.getLessonById(lessonId);

                if (lesson != null) {

                    request.setAttribute("lesson", lesson);

                    Module module = moduleDAO.getModuleById(lesson.getModuleId());

                    request.setAttribute("module", module);
                }

            } else if (moduleIdRaw != null && !moduleIdRaw.isBlank()) {

                int moduleId = Integer.parseInt(moduleIdRaw);

                Module module = moduleDAO.getModuleById(moduleId);

                request.setAttribute("module", module);
            }

        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/courselist");
            return;
        }

        request.getRequestDispatcher("/lesson/lessoneditor.jsp")
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

        LessonDAO lessonDAO = new LessonDAO();

        String action = request.getParameter("action");

        try {

            // DELETE
            if ("delete".equals(action)) {

                int lessonId = Integer.parseInt(request.getParameter("lessonId"));

                Lesson old = lessonDAO.getLessonById(lessonId);

                if (old != null) {

                    int moduleId = old.getModuleId();

                    lessonDAO.deleteLesson(lessonId);

                    response.sendRedirect(request.getContextPath()
                            + "/lessonlist?moduleId=" + moduleId);
                    return;
                }
            }

            // INSERT / UPDATE
            int moduleId = Integer.parseInt(request.getParameter("moduleId"));

            Lesson lesson = new Lesson();

            lesson.setModuleId(moduleId);
            lesson.setLessonTitle(request.getParameter("title"));
            lesson.setSummary(request.getParameter("summary"));
            lesson.setContent(request.getParameter("content"));
            lesson.setYoutubeUrl(request.getParameter("youtubeUrl"));

            String durationRaw = request.getParameter("duration");
            lesson.setDuration(durationRaw == null || durationRaw.isBlank()
                    ? 0 : Integer.parseInt(durationRaw));

            String orderRaw = request.getParameter("displayOrder");
            lesson.setDisplayOrder(orderRaw == null || orderRaw.isBlank()
                    ? 1 : Integer.parseInt(orderRaw));

            lesson.setStatus(request.getParameter("status"));

            String lessonIdRaw = request.getParameter("lessonId");

            if (lessonIdRaw == null || lessonIdRaw.isBlank()) {

                lesson.setCreatedBy(user.getUserId());

                lessonDAO.insertLesson(lesson);

            } else {

                int lessonId = Integer.parseInt(lessonIdRaw);

                Lesson old = lessonDAO.getLessonById(lessonId);

                lesson.setLessonId(lessonId);
                lesson.setCreatedBy(old.getCreatedBy());
                lesson.setUpdatedBy(user.getUserId());

                lessonDAO.updateLesson(lesson);
            }

            response.sendRedirect(request.getContextPath()
                    + "/lessonlist?moduleId=" + moduleId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/courselist");
        }
    }
}
