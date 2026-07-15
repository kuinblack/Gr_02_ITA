package dao;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.sql.Statement;

import java.util.ArrayList;

import java.util.List;

import model.AILessonDraft;

public class AILessonDraftDAO extends DBContext {

    // ====================== MAP ======================

    private AILessonDraft mapDraft(ResultSet rs) throws Exception {

        AILessonDraft d = new AILessonDraft();

        d.setDraftId(rs.getInt("draft_id"));

        d.setLessonId(rs.getInt("lesson_id"));

        d.setPrompt(rs.getNString("prompt"));

        d.setGeneratedContent(rs.getNString("generated_content"));

        d.setStatus(rs.getString("status"));

        d.setGeneratedAt(rs.getTimestamp("generated_at"));

        d.setReviewedBy((Integer) rs.getObject("reviewed_by"));

        d.setReviewedAt(rs.getTimestamp("reviewed_at"));

        d.setSourceType(rs.getString("source_type"));

        d.setSourceReference(rs.getString("source_reference"));

        return d;

    }

    // =================================================

    // INSERT DRAFT

    // Trả về draft_id vừa tạo

    // =================================================

    public int insertDraft(AILessonDraft draft) {

        String sql = """

            INSERT INTO AI_Lesson_Draft

            (lesson_id, prompt, generated_content, status,

             source_type, source_reference)

            VALUES (?, ?, ?, ?, ?, ?)

            """;

        try (PreparedStatement ps = connection.prepareStatement(

                sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, draft.getLessonId());

            ps.setNString(2, draft.getPrompt());

            ps.setNString(3, draft.getGeneratedContent());

            ps.setString(4,

                    draft.getStatus() == null ? "Pending" : draft.getStatus());

            ps.setString(5,

                    draft.getSourceType() == null ? "Prompt" : draft.getSourceType());

            ps.setString(6, draft.getSourceReference());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {

                    return rs.getInt(1);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return -1;

    }

    // ====================== GET BY ID ======================

    public AILessonDraft getDraftById(int draftId) {

        String sql = "SELECT * FROM AI_Lesson_Draft WHERE draft_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, draftId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return mapDraft(rs);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

    // ====================== GET LATEST DRAFT ======================

    public AILessonDraft getLatestDraftByLesson(int lessonId) {

        String sql = """

            SELECT TOP 1 *

            FROM AI_Lesson_Draft

            WHERE lesson_id = ?

            ORDER BY generated_at DESC

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return mapDraft(rs);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

    // ====================== GET LATEST PENDING ======================

    public AILessonDraft getLatestPendingDraftByLesson(int lessonId) {

        String sql = """

            SELECT TOP 1 *

            FROM AI_Lesson_Draft

            WHERE lesson_id = ?

              AND status = 'Pending'

            ORDER BY generated_at DESC

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return mapDraft(rs);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

    // ====================== GET DRAFTS OF LESSON ======================

    public List<AILessonDraft> getDraftsByLesson(int lessonId) {

        List<AILessonDraft> list = new ArrayList<>();

        String sql = """

            SELECT *

            FROM AI_Lesson_Draft

            WHERE lesson_id = ?

            ORDER BY generated_at DESC

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    list.add(mapDraft(rs));

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

    // ====================== GET ALL DRAFTS ======================

    public List<AILessonDraft> getAllDrafts() {

        List<AILessonDraft> list = new ArrayList<>();

        String sql = """

            SELECT *

            FROM AI_Lesson_Draft

            ORDER BY generated_at DESC

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql);

             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                list.add(mapDraft(rs));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

    // ====================== UPDATE CONTENT ======================

    public boolean updateGeneratedContent(int draftId, String content) {

        String sql = """

            UPDATE AI_Lesson_Draft

            SET generated_content = ?

            WHERE draft_id = ?

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, content);

            ps.setInt(2, draftId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

    // ====================== UPDATE STATUS ======================

    public boolean updateStatus(int draftId,

                                String status,

                                int reviewedBy) {

        String sql = """

            UPDATE AI_Lesson_Draft

            SET status = ?,

                reviewed_by = ?,

                reviewed_at = GETDATE()

            WHERE draft_id = ?

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, status);

            ps.setInt(2, reviewedBy);

            ps.setInt(3, draftId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

    // ====================== APPROVE DRAFT ======================

    public boolean approveDraft(int draftId,

                                String finalContent,

                                int reviewedBy) {

        String sql = """

            UPDATE AI_Lesson_Draft

            SET generated_content = ?,

                status = 'Approved',

                reviewed_by = ?,

                reviewed_at = GETDATE()

            WHERE draft_id = ?

            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, finalContent);

            ps.setInt(2, reviewedBy);

            ps.setInt(3, draftId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

    // ====================== REJECT ======================

    public boolean rejectDraft(int draftId, int reviewedBy) {

        return updateStatus(draftId, "Rejected", reviewedBy);

    }

    // ====================== DELETE ======================

    public boolean deleteDraft(int draftId) {

        String sql = "DELETE FROM AI_Lesson_Draft WHERE draft_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, draftId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

}

