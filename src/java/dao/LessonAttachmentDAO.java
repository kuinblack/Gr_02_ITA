package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.LessonAttachment;

public class LessonAttachmentDAO extends DBContext {

    // ====================== GET BY ID ======================
    public LessonAttachment getAttachmentById(int attachmentId) {

        String sql = """
            SELECT *
            FROM LessonAttachment
            WHERE attachment_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, attachmentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapAttachment(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ====================== GET BY LESSON ======================
    public List<LessonAttachment> getAttachmentsByLesson(int lessonId) {

        List<LessonAttachment> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM LessonAttachment
            WHERE lesson_id = ?
            ORDER BY uploaded_at DESC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapAttachment(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ====================== INSERT ======================
    public boolean insertAttachment(LessonAttachment a) {

        String sql = """
            INSERT INTO LessonAttachment
            (lesson_id, file_name, file_url, file_type,
             file_size, extracted_text, uploaded_by)
            VALUES (?, ?, ?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, a.getLessonId());
            ps.setNString(2, a.getFileName());
            ps.setString(3, a.getFileUrl());
            ps.setNString(4, a.getFileType());

            if (a.getFileSize() == null) {
                ps.setNull(5, java.sql.Types.BIGINT);
            } else {
                ps.setLong(5, a.getFileSize());
            }

            ps.setNString(6, a.getExtractedText());
            ps.setInt(7, a.getUploadedBy());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ====================== UPDATE EXTRACTED TEXT ======================
    public boolean updateExtractedText(int attachmentId, String text) {

        String sql = """
            UPDATE LessonAttachment
            SET extracted_text = ?
            WHERE attachment_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, text);
            ps.setInt(2, attachmentId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ====================== UPDATE ======================
    public boolean updateAttachment(LessonAttachment a) {

        String sql = """
            UPDATE LessonAttachment
            SET file_name = ?,
                file_url = ?,
                file_type = ?,
                file_size = ?,
                extracted_text = ?
            WHERE attachment_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, a.getFileName());
            ps.setString(2, a.getFileUrl());
            ps.setNString(3, a.getFileType());

            if (a.getFileSize() == null) {
                ps.setNull(4, java.sql.Types.BIGINT);
            } else {
                ps.setLong(4, a.getFileSize());
            }

            ps.setNString(5, a.getExtractedText());
            ps.setInt(6, a.getAttachmentId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ====================== DELETE ======================
    public boolean deleteAttachment(int attachmentId) {

        String sql = "DELETE FROM LessonAttachment WHERE attachment_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, attachmentId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ====================== MAPPING ======================
    private LessonAttachment mapAttachment(ResultSet rs) throws Exception {

        LessonAttachment a = new LessonAttachment();

        a.setAttachmentId(rs.getInt("attachment_id"));
        a.setLessonId(rs.getInt("lesson_id"));
        a.setFileName(rs.getNString("file_name"));
        a.setFileUrl(rs.getString("file_url"));
        a.setFileType(rs.getNString("file_type"));

        Long size = (Long) rs.getObject("file_size");
        a.setFileSize(size);

        a.setExtractedText(rs.getNString("extracted_text"));
        a.setUploadedBy(rs.getInt("uploaded_by"));

        java.sql.Timestamp ts = rs.getTimestamp("uploaded_at");
        if (ts != null) {
            a.setUploadedAt(ts.toLocalDateTime());
        }

        return a;
    }
}
