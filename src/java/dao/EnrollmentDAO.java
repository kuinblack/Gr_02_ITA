package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class EnrollmentDAO extends DBContext {

    public boolean isEnrolled(int studentId, int courseId) {

        String sql = """
            SELECT 1
            FROM Enrollment e
            JOIN Class c ON e.class_id = c.class_id
            WHERE e.student_id = ?
              AND c.course_id = ?
              AND e.status = 'Enrolled'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
