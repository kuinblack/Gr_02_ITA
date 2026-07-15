package dao;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Course;
import model.Lesson;
import model.Module;

public class CourseDAO extends DBContext {

    // ===================== MAP COURSE =====================
    private Course mapCourse(ResultSet rs) throws Exception {

        Course c = new Course();

        c.setCourseId(rs.getInt("course_id"));
        c.setTitle(rs.getNString("title"));
        c.setDescription(rs.getNString("description"));
        c.setThumbnailUrl(rs.getString("thumbnail_url"));
        c.setPrice(rs.getBigDecimal("price"));
        c.setCreatedBy(rs.getInt("created_by"));
        c.setStatus(rs.getString("status"));
        c.setCreatedAt(rs.getTimestamp("created_at"));

        return c;
    }

    // ===================== GET BY ID =====================
    public Course getCourseById(int id) {

        String sql = "SELECT * FROM Course WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapCourse(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public Course getCourse(int courseId) {
        return getCourseById(courseId);
    }

    // ===================== INSERT =====================
    public int insertCourse(Course c) {

        String sql = """
                INSERT INTO Course
                (title, description, thumbnail_url, price, created_by, status)
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (PreparedStatement ps = connection.prepareStatement(
                sql,
                Statement.RETURN_GENERATED_KEYS)) {

            ps.setNString(1, c.getTitle());
            ps.setNString(2, c.getDescription());
            ps.setString(3, c.getThumbnailUrl());
            ps.setBigDecimal(4,
                    c.getPrice() == null
                    ? BigDecimal.ZERO
                    : c.getPrice());

            ps.setInt(5, c.getCreatedBy());

            ps.setString(6,
                    c.getStatus() == null
                    ? "Draft"
                    : c.getStatus());

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

    // ===================== UPDATE =====================
    public boolean updateCourse(Course c) {

        String sql = """
                UPDATE Course
                SET title = ?,
                    description = ?,
                    thumbnail_url = ?,
                    price = ?,
                    status = ?
                WHERE course_id = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, c.getTitle());
            ps.setNString(2, c.getDescription());
            ps.setString(3, c.getThumbnailUrl());

            ps.setBigDecimal(4,
                    c.getPrice() == null
                    ? BigDecimal.ZERO
                    : c.getPrice());

            ps.setString(5, c.getStatus());
            ps.setInt(6, c.getCourseId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== DELETE =====================
    public boolean deleteCourse(int courseId) {

        String sql = "DELETE FROM Course WHERE course_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== SME COURSES =====================
    public List<Course> getCoursesBySME(int smeId, String keyword) {

        List<Course> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT * FROM Course WHERE created_by = ?");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND title LIKE ? ");
        }

        sql.append(" ORDER BY created_at DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {

            ps.setInt(1, smeId);

            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setNString(2, "%" + keyword.trim() + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapCourse(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== ALL COURSES =====================
    public ArrayList<Course> getAllCourse() {

        ArrayList<Course> list = new ArrayList<>();

        String sql = "SELECT * FROM Course ORDER BY created_at DESC";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapCourse(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== MODULES =====================
    public ArrayList<Module> getModules(int courseId) {
        return new ArrayList<>(new ModuleDAO().getModulesByCourse(courseId));
    }

    public ArrayList<Module> getModulesByCourse(int courseId) {
        return getModules(courseId);
    }

    // ===================== LESSONS =====================
    public ArrayList<Lesson> getLessons(int moduleId) {
        return new ArrayList<>(new LessonDAO().getLessonsByModule(moduleId));
    }

    public ArrayList<Lesson> getLessonsByModule(int moduleId) {
        return getLessons(moduleId);
    }

    // ===================== STUDENT COURSES =====================
    public ArrayList<Course> getCourseByStudent(int studentId) {
        return new StudentDashboardDAO().getMyCourses(studentId);
    }

    // ===================== COURSE WITH PROGRESS =====================
    public Course getCourseWithProgress(int courseId, int studentId) {

        Course c = getCourseById(courseId);

        if (c != null) {

            StudentDashboardDAO dao = new StudentDashboardDAO();

            int completed = dao.getCompletedLesson(studentId, courseId);
            int total = dao.getTotalLesson(courseId);

            c.setCompletedLessons(completed);

            c.setProgressPercent(
                    total == 0
                            ? 0
                            : completed * 100.0f / total);
        }

        return c;
    }

    // ===================== DASHBOARD COUNTS =====================
    public int countCoursesBySME(int smeId) {

        String sql = "SELECT COUNT(*) FROM Course WHERE created_by = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, smeId);

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

    public int countModulesBySME(int smeId) {

        String sql = """
                SELECT COUNT(*)
                FROM Module m
                JOIN Course c ON m.course_id = c.course_id
                WHERE c.created_by = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, smeId);

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

    public int countLessonsBySME(int smeId) {

        String sql = """
                SELECT COUNT(*)
                FROM Lesson l
                JOIN Module m ON l.module_id = m.module_id
                JOIN Course c ON m.course_id = c.course_id
                WHERE c.created_by = ?
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, smeId);

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

    public int countStudentsBySME(int smeId) {

        String sql = """
                SELECT COUNT(DISTINCT e.student_id)
                FROM Enrollment e
                JOIN Class cl ON e.class_id = cl.class_id
                JOIN Course c ON cl.course_id = c.course_id
                WHERE c.created_by = ?
                  AND e.status = 'Enrolled'
                """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, smeId);

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
    // ================= GET PUBLISHED COURSES =================

    public ArrayList<Course> getPublishedCourses() {

        ArrayList<Course> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM Course
        WHERE status = 'Published'
        ORDER BY course_id DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapCourse(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

// ================= SEARCH PUBLISHED COURSES =================
    public ArrayList<Course> searchPublishedCourses(String keyword) {

        ArrayList<Course> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM Course
        WHERE status = 'Published'
          AND title LIKE ?
        ORDER BY course_id DESC
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapCourse(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
