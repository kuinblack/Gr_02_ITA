package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Result;

public class ResultDAO extends DBContext {

    private Result map(ResultSet rs) throws Exception {
        Result r = new Result();
        r.setResultId(rs.getInt("result_id"));
        r.setSubmissionId(rs.getInt("submission_id"));
        r.setScore(rs.getBigDecimal("score"));
        r.setFeedback(rs.getNString("feedback")); // Hỗ trợ tiếng Việt có dấu
        r.setGradedBy(rs.getString("graded_by"));
        r.setGradedAt(rs.getTimestamp("graded_at"));
        return r;
    }

    public List<Result> getResultsByAssignment(int assignmentId) {
        List<Result> list = new ArrayList<>();
        String sql = """
            SELECT r.result_id,
                   r.submission_id,
                   r.score,
                   r.feedback,
                   r.graded_by,
                   r.graded_at
            FROM Result r
            JOIN Submission s ON r.submission_id = s.submission_id
            WHERE s.assignment_id = ?
            ORDER BY r.graded_at DESC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Result getBySubmissionId(int submissionId) {
        String sql = """
            SELECT r.result_id,
                   r.submission_id,
                   r.score,
                   r.feedback,
                   r.graded_by,
                   r.graded_at
            FROM Result r
            WHERE r.submission_id = ?
            """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, submissionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean saveOrUpdateResult(Result r) {
        Result old = getBySubmissionId(r.getSubmissionId());

        if (old == null) {
            String sql = """
                INSERT INTO Result (submission_id, score, feedback, graded_by, graded_at)
                VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
                """;
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, r.getSubmissionId());
                ps.setBigDecimal(2, r.getScore());
                ps.setNString(3, r.getFeedback());
                ps.setString(4, r.getGradedBy());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            String sql = """
                UPDATE Result
                SET score = ?, feedback = ?, graded_by = ?, graded_at = CURRENT_TIMESTAMP
                WHERE submission_id = ?
                """;
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setBigDecimal(1, r.getScore());
                ps.setNString(2, r.getFeedback());
                ps.setString(3, r.getGradedBy());
                ps.setInt(4, r.getSubmissionId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
