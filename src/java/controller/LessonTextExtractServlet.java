package controller;

import dao.AILessonDraftDAO;
import dao.LessonAttachmentDAO;
import dao.LessonDAO;
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
import model.AILessonDraft;
import model.LessonAttachment;
import model.User;
import service.AIService;
import service.YouTubeService;

@MultipartConfig
public class LessonTextExtractServlet extends HttpServlet {

    private final LessonAttachmentDAO attachmentDAO = new LessonAttachmentDAO();
    private final AILessonDraftDAO draftDAO = new AILessonDraftDAO();
    private final LessonDAO lessonDAO = new LessonDAO();

    private final AIService aiService = new AIService();
    private final YouTubeService youtubeService = new YouTubeService();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("lessonList", lessonDAO.getAllLessons());

        request.getRequestDispatcher("/lesson/lessontextextract.jsp")
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

        int lessonId = Integer.parseInt(request.getParameter("lessonId"));

        // =================================================
        // STEP 1: EXTRACT TEXT
        // =================================================
        if ("extract".equals(action)) {

            String youtubeUrl = request.getParameter("youtubeUrl");

            String extractedText = null;
            String sourceType = "YouTube";
            String sourceReference = youtubeUrl;

            if (youtubeUrl != null && !youtubeUrl.isBlank()) {

                extractedText = youtubeService.extractTranscript(youtubeUrl);

            } else {

                Part filePart = request.getPart("attachedFile");

                if (filePart != null && filePart.getSize() > 0) {

                    sourceType = "File";

                    String fileName = Paths.get(filePart.getSubmittedFileName())
                            .getFileName()
                            .toString();

                    String uploadPath = getServletContext()
                            .getRealPath("/uploads");

                    File dir = new File(uploadPath);

                    if (!dir.exists()) {
                        dir.mkdirs();
                    }

                    String filePath = uploadPath + File.separator + fileName;

                    filePart.write(filePath);

                    sourceReference = fileName;

                    // TODO: Extract real text from PDF/DOCX/PPTX
                    extractedText = "Extracted text from file: " + fileName;

                    LessonAttachment att = new LessonAttachment();
                    att.setLessonId(lessonId);
                    att.setFileName(fileName);
                    att.setFileUrl("uploads/" + fileName);
                    att.setFileType(filePart.getContentType());
                    att.setFileSize(filePart.getSize());
                    att.setExtractedText(extractedText);
                    att.setUploadedBy(user.getUserId());

                    attachmentDAO.insertAttachment(att);
                }
            }

            request.setAttribute("lessonList", lessonDAO.getAllLessons());
            request.setAttribute("selectedLessonId", lessonId);
            request.setAttribute("youtubeUrl", youtubeUrl);
            request.setAttribute("extractedText", extractedText);
            request.setAttribute("sourceType", sourceType);
            request.setAttribute("sourceReference", sourceReference);

            request.getRequestDispatcher("/lesson/lessontextextract.jsp")
                    .forward(request, response);
            return;
        }

        // =================================================
        // STEP 2: GENERATE SUMMARY -> SAVE DRAFT (Pending)
        // =================================================
        if ("generateSummary".equals(action)) {

            String extractedText = request.getParameter("extractedText");
            String sourceType = request.getParameter("sourceType");
            String sourceReference = request.getParameter("sourceReference");

            String summary = aiService.generateSummary(extractedText);

            AILessonDraft draft = new AILessonDraft();
            draft.setLessonId(lessonId);
            draft.setPrompt("Generate lesson summary from extracted text");
            draft.setGeneratedContent(summary);
            draft.setStatus("Pending");
            draft.setSourceType(sourceType);
            draft.setSourceReference(sourceReference);

            draftDAO.insertDraft(draft);

            request.setAttribute("lessonList", lessonDAO.getAllLessons());
            request.setAttribute("selectedLessonId", lessonId);
            request.setAttribute("extractedText", extractedText);
            request.setAttribute("sourceType", sourceType);
            request.setAttribute("sourceReference", sourceReference);
            request.setAttribute("aiGeneratedSummary", summary);

            request.getRequestDispatcher("/lesson/lessontextextract.jsp")
                    .forward(request, response);
            return;
        }

        // =================================================
        // STEP 3: SAVE EDITED DRAFT
        // =================================================
        if ("saveDraft".equals(action)) {

            String content = request.getParameter("draftContent");
            String sourceType = request.getParameter("sourceType");
            String sourceReference = request.getParameter("sourceReference");

            AILessonDraft draft = new AILessonDraft();
            draft.setLessonId(lessonId);
            draft.setGeneratedContent(content);
            draft.setStatus("Pending");
            draft.setSourceType(sourceType);
            draft.setSourceReference(sourceReference);

            draftDAO.insertDraft(draft);

            response.sendRedirect(request.getContextPath()
                    + "/aidrafts?lessonId=" + lessonId);
        }
    }
}
