/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.util.ArrayList;

import model.Course;

import model.Lesson;

import model.Module;

public class ProgressDAO extends DBContext {

// ===================== COURSE =====================
    public Course getCourse(int courseId) {

        String sql = """

SELECT *

FROM Course

WHERE course_id = ?

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

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

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

// ===================== MODULES =====================
    public ArrayList<Module> getModules(int courseId) {

        ArrayList<Module> list = new ArrayList<>();

        String sql = """

SELECT *

FROM Module

WHERE course_id = ?

ORDER BY display_order

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Module m = new Module();

                    m.setModuleId(rs.getInt("module_id"));

                    m.setCourseId(rs.getInt("course_id"));

                    m.setModuleTitle(rs.getNString("module_title"));

                    m.setDisplayOrder(rs.getInt("display_order"));

                    list.add(m);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

// ===================== LESSONS =====================
    public ArrayList<Lesson> getLessons(int moduleId) {

        ArrayList<Lesson> list = new ArrayList<>();

        String sql = """

SELECT *

FROM Lesson

WHERE module_id = ?

ORDER BY display_order

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Lesson l = new Lesson();

                    l.setLessonId(rs.getInt("lesson_id"));

                    l.setModuleId(rs.getInt("module_id"));

                    l.setLessonTitle(rs.getNString("lesson_title"));

                    l.setContent(rs.getNString("content"));

                    l.setSummary(rs.getNString("summary"));

                    l.setYoutubeUrl(rs.getString("youtube_url"));

                    l.setDuration(rs.getInt("duration"));

                    l.setDisplayOrder(rs.getInt("display_order"));

                    l.setStatus(rs.getString("status"));

                    l.setCreatedBy(rs.getInt("created_by"));

                    l.setUpdatedBy((Integer) rs.getObject("updated_by"));

                    l.setCreatedAt(rs.getTimestamp("created_at"));

                    l.setUpdatedAt(rs.getTimestamp("updated_at"));

                    l.setPublishedAt(rs.getTimestamp("published_at"));

                    list.add(l);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

// ===================== COMPLETED LESSONS =====================
    public ArrayList<Integer> getCompletedLessons(int studentId) {

        ArrayList<Integer> completedLessons = new ArrayList<>();

        String sql = """

SELECT lesson_id

FROM LessonProgress

WHERE student_id = ?

AND status = 'Completed'

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    completedLessons.add(rs.getInt("lesson_id"));

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return completedLessons;

    }

// ===================== COUNT COMPLETED LESSONS =====================
    public int countCompletedLessons(int studentId, int courseId) {

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

// ===================== COUNT TOTAL LESSONS =====================
    public int countTotalLessons(int courseId) {

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

// ===================== PROGRESS PERCENT =====================
    public float getProgressPercent(int studentId, int courseId) {

        int completed = countCompletedLessons(studentId, courseId);

        int total = countTotalLessons(courseId);

        if (total == 0) {

            return 0;

        }

        return (completed * 100.0f) / total;
    }
}
