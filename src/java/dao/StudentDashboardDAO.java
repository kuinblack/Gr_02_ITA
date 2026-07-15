package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Course;

public class StudentDashboardDAO extends DBContext {

    public ArrayList<Course> getMyCourses(int studentId) {
        ArrayList<Course> list = new ArrayList<>();
        String sql = """
            SELECT DISTINCT
                   c.course_id,
                   c.title,
                   c.description,
                   cl.class_id,
                   cl.class_name,
                   c.created_at
            FROM Enrollment e
            JOIN Class cl ON e.class_id = cl.class_id
            JOIN Course c ON cl.course_id = c.course_id
            WHERE e.student_id = ?
              AND e.status = 'Enrolled'
            ORDER BY c.course_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course c = new Course();
                    c.setCourseId(rs.getInt("course_id"));
                    c.setTitle(rs.getString("title"));
                    c.setDescription(rs.getString("description"));
                    c.setClassId(rs.getInt("class_id"));
                    c.setClassName(rs.getString("class_name"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(c);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getTotalLesson(int courseId) {
        String sql = """
            SELECT COUNT(*)
            FROM Lesson l
            JOIN Module m ON l.module_id = m.module_id
            WHERE m.course_id = ?
              AND l.status = 'Published'
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

    public int getCompletedLesson(int studentId, int courseId) {
        String sql = """
            SELECT COUNT(*)
            FROM LessonProgress lp
            JOIN Lesson l ON lp.lesson_id = l.lesson_id
            JOIN Module m ON l.module_id = m.module_id
            WHERE lp.student_id = ?
              AND m.course_id = ?
              AND lp.status = 'Completed'
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

    public ArrayList<Integer> getCompletedLessonIds(int studentId, int courseId) {
        ArrayList<Integer> list = new ArrayList<>();
        String sql = """
            SELECT lp.lesson_id
            FROM LessonProgress lp
            JOIN Lesson l ON lp.lesson_id = l.lesson_id
            JOIN Module m ON l.module_id = m.module_id
            WHERE lp.student_id = ?
              AND m.course_id = ?
              AND lp.status = 'Completed'
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("lesson_id"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public float getProgressPercent(int studentId, int courseId) {
        int total = getTotalLesson(courseId);
        if (total == 0) {
            return 0;
        }
        int completed = getCompletedLesson(studentId, courseId);
        return (completed * 100f) / total;
    }

    // Trích xuất hàm lấy CourseId từ LessonId để phục vụ việc đồng bộ bảng Progress tổng
    public int getCourseIdByLessonId(int lessonId) {
        String sql = """
            SELECT m.course_id 
            FROM Lesson l 
            JOIN Module m ON l.module_id = m.module_id 
            WHERE l.lesson_id = ?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, lessonId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("course_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void insertOrUpdateLessonProgress(int studentId, int lessonId, String status) {
        String checkSql = "SELECT COUNT(*) FROM LessonProgress WHERE student_id = ? AND lesson_id = ?";
        String insertSql = "INSERT INTO LessonProgress (student_id, lesson_id, status) VALUES (?, ?, ?)";
        String updateSql = "UPDATE LessonProgress SET status = ? WHERE student_id = ? AND lesson_id = ?";

        boolean exists = false;
        
        // Tách biệt hoàn toàn các khối xử lý kết nối để tránh tranh chấp Connection
        try (PreparedStatement psCheck = connection.prepareStatement(checkSql)) {
            psCheck.setInt(1, studentId);
            psCheck.setInt(2, lessonId);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    exists = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (exists) {
            try (PreparedStatement psUpdate = connection.prepareStatement(updateSql)) {
                psUpdate.setString(1, status);
                psUpdate.setInt(2, studentId);
                psUpdate.setInt(3, lessonId);
                psUpdate.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            try (PreparedStatement psInsert = connection.prepareStatement(insertSql)) {
                psInsert.setInt(1, studentId);
                psInsert.setInt(2, lessonId);
                psInsert.setString(3, status);
                psInsert.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // ĐỒNG BỘ: Cập nhật lại bảng tổng hợp Progress tổng của khóa học nếu có bài học thay đổi trạng thái
        int courseId = getCourseIdByLessonId(lessonId);
        if (courseId != -1) {
            updateCourseProgressTable(studentId, courseId);
        }
    }

    private void updateCourseProgressTable(int studentId, int courseId) {
        float newPercent = getProgressPercent(studentId, courseId);
        int totalCompletedLessons = getCompletedLesson(studentId, courseId);
        
        String checkProgressSql = "SELECT COUNT(*) FROM Progress WHERE student_id = ? AND course_id = ?";
        String insertProgressSql = "INSERT INTO Progress (student_id, course_id, progress_percent, lesson_completed) VALUES (?, ?, ?, ?)";
        String updateProgressSql = "UPDATE Progress SET progress_percent = ?, lesson_completed = ? WHERE student_id = ? AND course_id = ?";
        
        boolean progressExists = false;
        try (PreparedStatement ps = connection.prepareStatement(checkProgressSql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    progressExists = true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (progressExists) {
            try (PreparedStatement ps = connection.prepareStatement(updateProgressSql)) {
                ps.setFloat(1, newPercent);
                ps.setInt(2, totalCompletedLessons);
                ps.setInt(3, studentId);
                ps.setInt(4, courseId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            try (PreparedStatement ps = connection.prepareStatement(insertProgressSql)) {
                ps.setInt(1, studentId);
                ps.setInt(2, courseId);
                ps.setFloat(3, newPercent);
                ps.setInt(4, totalCompletedLessons);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}