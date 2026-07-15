package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Question;
import model.QuestionOption;

public class QuestionDAO extends DBContext {

    // ===================== MAP QUESTION =====================
    private Question mapQuestion(ResultSet rs) throws Exception {
        Question q = new Question();
        q.setQuestionId(rs.getInt("question_id"));
        q.setModuleId(rs.getInt("module_id"));
        q.setContent(rs.getNString("content"));
        q.setQuestionType(rs.getString("question_type"));
        q.setCreatedBy(rs.getInt("created_by"));
        return q;
    }

    // ===================== GET OPTIONS =====================
    public List<QuestionOption> getOptionsByQuestionId(int questionId) {
        List<QuestionOption> list = new ArrayList<>();
        String sql = """
            SELECT option_id,
                   question_id,
                   option_label,
                   option_content,
                   is_correct
            FROM QuestionOption
            WHERE question_id = ?
            ORDER BY option_label
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, questionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuestionOption o = new QuestionOption();
                    o.setOptionId(rs.getInt("option_id"));
                    o.setQuestionId(rs.getInt("question_id"));
                    o.setOptionLabel(rs.getString("option_label"));
                    o.setOptionContent(rs.getNString("option_content"));
                    o.setCorrect(rs.getBoolean("is_correct"));
                    list.add(o);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== GET ALL =====================
    public List<Question> getAllQuestions() {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM Question
            ORDER BY question_id DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Question q = mapQuestion(rs);
                q.setOptions(getOptionsByQuestionId(q.getQuestionId()));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== GET BY MODULE =====================
    public List<Question> getQuestionsByModule(int moduleId) {
        List<Question> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM Question
            WHERE module_id = ?
            ORDER BY question_id DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Question q = mapQuestion(rs);
                    q.setOptions(getOptionsByQuestionId(q.getQuestionId()));
                    list.add(q);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== GET BY ID =====================
    public Question getQuestionById(int id) {
        String sql = "SELECT * FROM Question WHERE question_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Question q = mapQuestion(rs);
                    q.setOptions(getOptionsByQuestionId(q.getQuestionId()));
                    return q;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===================== INSERT QUESTION =====================
    public int insertQuestion(Question q) {
        String sql = """
            INSERT INTO Question(module_id, content, question_type, created_by)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, q.getModuleId());
            ps.setNString(2, q.getContent());
            ps.setString(3, q.getQuestionType());
            ps.setInt(4, q.getCreatedBy());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===================== INSERT OPTIONS =====================
    public boolean insertOptions(int questionId, List<QuestionOption> options) {
        if (options == null || options.isEmpty()) {
            return true;
        }

        String sql = """
            INSERT INTO QuestionOption (question_id, option_label, option_content, is_correct)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            for (QuestionOption o : options) {
                ps.setInt(1, questionId);
                ps.setString(2, o.getOptionLabel());
                ps.setNString(3, o.getOptionContent());
                ps.setBoolean(4, o.isCorrect());
                ps.addBatch();
            }
            ps.executeBatch();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===================== INSERT FULL QUESTION =====================
    public boolean insertFullQuestion(Question q) {
        try {
            connection.setAutoCommit(false);

            int questionId = insertQuestion(q);
            if (questionId == -1) {
                connection.rollback();
                return false;
            }

            if (!insertOptions(questionId, q.getOptions())) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    // ===================== UPDATE FULL QUESTION =====================
    // Cập nhật thông tin câu hỏi và đồng bộ lại danh sách options cũ/mới bằng Transaction
    public boolean updateQuestion(Question q) {
        String updateQuestionSql = """
            UPDATE Question
            SET module_id = ?,
                content = ?,
                question_type = ?
            WHERE question_id = ?
        """;

        String deleteOldOptionsSql = "DELETE FROM QuestionOption WHERE question_id = ?";

        try {
            connection.setAutoCommit(false);

            // 1. Cập nhật thông tin chung của câu hỏi
            try (PreparedStatement psQ = connection.prepareStatement(updateQuestionSql)) {
                psQ.setInt(1, q.getModuleId());
                psQ.setNString(2, q.getContent());
                psQ.setString(3, q.getQuestionType());
                psQ.setInt(4, q.getQuestionId());

                int affected = psQ.executeUpdate();
                if (affected == 0) {
                    connection.rollback();
                    return false;
                }
            }

            // 2. Xóa toàn bộ các options cũ thuộc câu hỏi này
            try (PreparedStatement psDelOpt = connection.prepareStatement(deleteOldOptionsSql)) {
                psDelOpt.setInt(1, q.getQuestionId());
                psDelOpt.executeUpdate();
            }

            // 3. Thêm mới lại danh sách options mới (nếu có)
            if (q.getOptions() != null && !q.getOptions().isEmpty()) {
                if (!insertOptions(q.getQuestionId(), q.getOptions())) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }

    // ===================== DELETE (SỬ DỤNG CASCADE) =====================
    // Nhờ ON DELETE CASCADE ở DB, ta chỉ cần gọi duy nhất một lệnh xóa câu hỏi
    public boolean deleteQuestion(int id) {
        String deleteQuestion = "DELETE FROM Question WHERE question_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(deleteQuestion)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===================== IMPORT =====================
    public boolean importQuestions(List<Question> questions) {
        try {
            connection.setAutoCommit(false);

            for (Question q : questions) {
                int questionId = insertQuestion(q);
                if (questionId == -1) {
                    connection.rollback();
                    return false;
                }

                if (!insertOptions(questionId, q.getOptions())) {
                    connection.rollback();
                    return false;
                }
            }

            connection.commit();
            return true;
        } catch (Exception e) {
            try {
                connection.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return false;
    }
}
