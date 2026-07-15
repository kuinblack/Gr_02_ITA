package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Assignment;
import model.AssignmentDTO;

public class AssignmentDAO extends DBContext {

    private Assignment map(ResultSet rs) throws Exception {
        Assignment a = new Assignment();
        a.setAssignmentId(rs.getInt("assignment_id"));
        a.setClassId(rs.getInt("class_id"));
        a.setTitle(rs.getNString("title"));
        a.setDescription(rs.getNString("description"));
        a.setDeadline(rs.getTimestamp("deadline"));
        a.setTotalScore(rs.getBigDecimal("total_score"));
        a.setCreatedBy(rs.getInt("created_by"));

        // Chỉ map class_name nếu câu SQL thực hiện JOIN và có trả về cột này
        try {
            a.setClassName(rs.getNString("class_name"));
        } catch (Exception e) {
            // Bỏ qua nếu ResultSet không chứa cột class_name
        }
        return a;
    }

    // Lấy tất cả thư viện bài tập cho một Student cụ thể (Sử dụng DTO)
    public List<AssignmentDTO> getAssignmentLibraryForStudent(int studentId) {
        List<AssignmentDTO> list = new ArrayList<>();
        String sql = """
            SELECT 
                a.assignment_id,
                a.class_id,
                c.class_name,
                a.title,
                a.description,
                a.deadline,
                a.total_score,
                (CASE WHEN s.submission_id IS NOT NULL THEN 1 ELSE 0 END) AS is_submitted,
                (CASE WHEN r.result_id IS NOT NULL THEN 1 ELSE 0 END) AS is_graded,
                r.score AS student_score,
                r.feedback AS result_feedback
            FROM Assignment a
            JOIN Class c ON a.class_id = c.class_id
            LEFT JOIN Submission s ON a.assignment_id = s.assignment_id AND s.student_id = ?
            LEFT JOIN Result r ON s.submission_id = r.submission_id
            ORDER BY a.assignment_id ASC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AssignmentDTO dto = new AssignmentDTO();
                    dto.setAssignmentId(rs.getInt("assignment_id"));
                    dto.setClassId(rs.getInt("class_id"));
                    dto.setClassName(rs.getNString("class_name"));
                    dto.setTitle(rs.getNString("title"));
                    dto.setDescription(rs.getNString("description"));
                    dto.setDeadline(rs.getTimestamp("deadline"));
                    dto.setTotalScore(rs.getBigDecimal("total_score"));

                    dto.setSubmitted(rs.getInt("is_submitted") == 1);
                    dto.setGraded(rs.getInt("is_graded") == 1);
                    dto.setStudentScore(rs.getBigDecimal("student_score"));
                    dto.setFeedback(rs.getNString("result_feedback"));

                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả assignment (Đã tránh viết a.* để không bị ambiguous class_id)
    public List<Assignment> getAll() {
        List<Assignment> list = new ArrayList<>();
        String sql = """
            SELECT 
                a.assignment_id,
                a.class_id,
                a.title,
                a.description,
                a.deadline,
                a.total_score,
                a.created_by,
                c.class_name
            FROM Assignment a
            JOIN Class c ON a.class_id = c.class_id
            ORDER BY a.assignment_id ASC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy theo ID
    public Assignment getById(int id) {
        String sql = """
            SELECT 
                a.assignment_id,
                a.class_id,
                a.title,
                a.description,
                a.deadline,
                a.total_score,
                a.created_by,
                c.class_name
            FROM Assignment a
            JOIN Class c ON a.class_id = c.class_id
            WHERE a.assignment_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
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

    // Assignment theo lớp
    public List<Assignment> getAssignmentsByClass(int classId) {
        List<Assignment> list = new ArrayList<>();
        String sql = """
            SELECT 
                a.assignment_id,
                a.class_id,
                a.title,
                a.description,
                a.deadline,
                a.total_score,
                a.created_by,
                c.class_name
            FROM Assignment a
            JOIN Class c ON a.class_id = c.class_id
            WHERE a.class_id = ?
            ORDER BY a.deadline ASC
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, classId);
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

    // Insert
    public boolean insert(Assignment a) {
        String sql = """
            INSERT INTO Assignment
            (class_id, title, description, deadline, total_score, created_by)
            VALUES (?, ?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, a.getClassId());
            ps.setNString(2, a.getTitle());
            ps.setNString(3, a.getDescription());
            ps.setTimestamp(4, a.getDeadline());
            ps.setBigDecimal(5, a.getTotalScore());
            ps.setInt(6, a.getCreatedBy());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Update
    public boolean update(Assignment a) {
        String sql = """
            UPDATE Assignment
            SET class_id = ?,
                title = ?,
                description = ?,
                deadline = ?,
                total_score = ?
            WHERE assignment_id = ?
            """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, a.getClassId());
            ps.setNString(2, a.getTitle());
            ps.setNString(3, a.getDescription());
            ps.setTimestamp(4, a.getDeadline());
            ps.setBigDecimal(5, a.getTotalScore());
            ps.setInt(6, a.getAssignmentId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Delete
    public boolean delete(int id) {
        String sql = "DELETE FROM Assignment WHERE assignment_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
