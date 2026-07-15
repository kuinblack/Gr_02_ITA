package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Result;
import model.Submission;

public class SubmissionDAO extends DBContext {

    private Submission mapSubmission(ResultSet rs) throws Exception {
        Submission s = new Submission();
        s.setSubmissionId(rs.getInt("submission_id"));
        s.setAssignmentId(rs.getInt("assignment_id"));
        s.setStudentId(rs.getInt("student_id"));
        s.setContent(rs.getNString("content"));
        s.setSubmittedAt(rs.getTimestamp("submitted_at"));
        s.setFileUrl(rs.getNString("file_url"));
        return s;
    }

    private Result mapResult(ResultSet rs) throws Exception {
        Result r = new Result();
        r.setResultId(rs.getInt("result_id"));
        r.setSubmissionId(rs.getInt("submission_id"));
        r.setScore(rs.getBigDecimal("score"));
        r.setFeedback(rs.getNString("feedback"));
        r.setGradedBy(rs.getString("graded_by"));
        r.setGradedAt(rs.getTimestamp("graded_at"));
        return r;
    }

    public Submission getSubmission(int assignmentId, int studentId) {
        String sql = """
            SELECT submission_id, assignment_id, student_id, content, submitted_at, file_url
            FROM Submission
            WHERE assignment_id = ? AND student_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapSubmission(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Result getResultBySubmission(int submissionId) {
        String sql = """
            SELECT result_id, submission_id, score, feedback, graded_by, graded_at 
            FROM Result 
            WHERE submission_id = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResult(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveOrUpdateSubmission(int assignmentId, int studentId, String content, String fileUrl) {
        Submission old = getSubmission(assignmentId, studentId);

        if (old == null) {
            String sql = """
                INSERT INTO Submission (assignment_id, student_id, content, file_url, submitted_at)
                VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
                """;
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, assignmentId);
                ps.setInt(2, studentId);
                ps.setNString(3, content);
                ps.setNString(4, fileUrl);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = """
                UPDATE Submission
                SET content = ?, file_url = ?, submitted_at = CURRENT_TIMESTAMP
                WHERE submission_id = ?
                """;
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setNString(1, content);
                ps.setNString(2, fileUrl);
                ps.setInt(3, old.getSubmissionId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}