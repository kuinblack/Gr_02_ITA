package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import model.LessonProgress;

public class LessonProgressDAO extends DBContext {

    // ================= MAP =================
    private LessonProgress map(ResultSet rs) throws Exception {

        LessonProgress lp = new LessonProgress();

        lp.setProgressId(rs.getInt("progress_id"));
        lp.setStudentId(rs.getInt("student_id"));
        lp.setLessonId(rs.getInt("lesson_id"));
        lp.setStatus(rs.getString("status"));
        lp.setCompletedAt(rs.getTimestamp("completed_at"));

        return lp;
    }

    // ================= GET ALL PROGRESS =================
    public ArrayList<LessonProgress> getProgressByStudent(int studentId) {

        ArrayList<LessonProgress> list = new ArrayList<>();

        String sql = "SELECT * FROM LessonProgress WHERE student_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);

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

    // Alias
    public ArrayList<LessonProgress> getLessonProgressByStudent(int studentId) {
        return getProgressByStudent(studentId);
    }

    // ================= CHECK COMPLETED =================
    public boolean isCompleted(int studentId, int lessonId) {

        String sql = """
            SELECT 1
            FROM LessonProgress
            WHERE student_id = ?
              AND lesson_id = ?
              AND status = 'Completed'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, lessonId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= MARK COMPLETED =================
    public void markLessonCompleted(int studentId, int lessonId) {

        String checkSql = """
            SELECT 1
            FROM LessonProgress
            WHERE student_id = ?
              AND lesson_id = ?
        """;

        String insertSql = """
            INSERT INTO LessonProgress(student_id, lesson_id, status, completed_at)
            VALUES (?, ?, 'Completed', GETDATE())
        """;

        String updateSql = """
            UPDATE LessonProgress
            SET status = 'Completed',
                completed_at = GETDATE()
            WHERE student_id = ?
              AND lesson_id = ?
        """;

        try (PreparedStatement check = connection.prepareStatement(checkSql)) {

            check.setInt(1, studentId);
            check.setInt(2, lessonId);

            try (ResultSet rs = check.executeQuery()) {

                if (rs.next()) {

                    try (PreparedStatement update = connection.prepareStatement(updateSql)) {

                        update.setInt(1, studentId);
                        update.setInt(2, lessonId);
                        update.executeUpdate();
                    }

                } else {

                    try (PreparedStatement insert = connection.prepareStatement(insertSql)) {

                        insert.setInt(1, studentId);
                        insert.setInt(2, lessonId);
                        insert.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= COMPLETED IDS BY COURSE =================
    public ArrayList<Integer> getCompletedLessonIds(int studentId, int courseId) {

        ArrayList<Integer> list = new ArrayList<>();

        String sql = """
            SELECT lp.lesson_id
            FROM LessonProgress lp
            JOIN Lesson l ON lp.lesson_id = l.lesson_id
            JOIN Module m ON l.module_id = m.module_id
            WHERE lp.student_id = ?
              AND lp.status = 'Completed'
              AND m.course_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(rs.getInt(1));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= COUNT COMPLETED =================
    public int getCompletedLesson(int studentId, int courseId) {

        String sql = """
            SELECT COUNT(*)
            FROM LessonProgress lp
            JOIN Lesson l ON lp.lesson_id = l.lesson_id
            JOIN Module m ON l.module_id = m.module_id
            WHERE lp.student_id = ?
              AND lp.status = 'Completed'
              AND m.course_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ================= TOTAL LESSONS =================
    public int getTotalLesson(int courseId) {

        String sql = """
            SELECT COUNT(*)
            FROM Lesson l
            JOIN Module m ON l.module_id = m.module_id
            WHERE m.course_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
