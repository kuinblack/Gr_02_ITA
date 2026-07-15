/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;

import java.sql.ResultSet;

import java.util.ArrayList;

import java.util.List;

import model.Lesson;

import model.Module;

public class LessonDAO extends DBContext {

// ====================== GET ALL ======================
    public List<Lesson> getAllLessons() {

        List<Lesson> list = new ArrayList<>();

        String sql = """

SELECT *

FROM Lesson

ORDER BY display_order

""";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                list.add(mapLesson(rs));

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

// ====================== DETAIL ======================
    public Lesson getLessonById(int lessonId) {

        String sql = """

SELECT *

FROM Lesson

WHERE lesson_id = ?

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return mapLesson(rs);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

// ====================== GET BY MODULE ======================
    public List<Lesson> getLessonsByModule(int moduleId) {

        List<Lesson> list = new ArrayList<>();

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

                    list.add(mapLesson(rs));

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

// ====================== INSERT ======================
    public boolean insertLesson(Lesson l) {

        String sql = """

INSERT INTO Lesson

(module_id, lesson_title, content, summary,

youtube_url, duration, display_order,

status, created_by)

VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, l.getModuleId());

            ps.setNString(2, l.getLessonTitle());

            ps.setNString(3, l.getContent());

            ps.setNString(4, l.getSummary());

            ps.setString(5, l.getYoutubeUrl());

            ps.setInt(6, l.getDuration());

            ps.setInt(7, l.getDisplayOrder());

            ps.setString(8, l.getStatus());

            ps.setInt(9, l.getCreatedBy());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

// ====================== UPDATE ======================
    public boolean updateLesson(Lesson l) {

        String sql = """

UPDATE Lesson

SET module_id = ?,

lesson_title = ?,

content = ?,

summary = ?,

youtube_url = ?,

duration = ?,

display_order = ?,

status = ?,

updated_by = ?,

updated_at = GETDATE()

WHERE lesson_id = ?

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, l.getModuleId());

            ps.setNString(2, l.getLessonTitle());

            ps.setNString(3, l.getContent());

            ps.setNString(4, l.getSummary());

            ps.setString(5, l.getYoutubeUrl());

            ps.setInt(6, l.getDuration());

            ps.setInt(7, l.getDisplayOrder());

            ps.setString(8, l.getStatus());

            if (l.getUpdatedBy() == null) {

                ps.setNull(9, java.sql.Types.INTEGER);

            } else {

                ps.setInt(9, l.getUpdatedBy());

            }

            ps.setInt(10, l.getLessonId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

// ====================== DELETE ======================
    public boolean deleteLesson(int lessonId) {

        String sql = "DELETE FROM Lesson WHERE lesson_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, lessonId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

        }

        return false;

    }

// ====================== MODULES OF COURSE ======================
    public List<Module> getModulesByCourse(int courseId) {

        List<Module> list = new ArrayList<>();

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

                    list.add(mapModule(rs));

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return list;

    }

// ====================== FIRST LESSON OF COURSE ======================
    public Lesson getFirstLessonByCourse(int courseId) {

        String sql = """

SELECT TOP 1 l.*

FROM Lesson l

JOIN Module m ON l.module_id = m.module_id

WHERE m.course_id = ?

ORDER BY m.display_order, l.display_order

""";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return mapLesson(rs);

                }

            }

        } catch (Exception e) {

            e.printStackTrace();

        }

        return null;

    }

// ====================== MAPPING ======================
    private Lesson mapLesson(ResultSet rs) throws Exception {

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

        return l;

    }

    private Module mapModule(ResultSet rs) throws Exception {

        Module m = new Module();

        m.setModuleId(rs.getInt("module_id"));

        m.setCourseId(rs.getInt("course_id"));

        m.setModuleTitle(rs.getNString("module_title"));

        m.setDisplayOrder(rs.getInt("display_order"));

        return m;

    }

    public boolean publishContent(int lessonId, String content, int userId) {
        String sql = """
        UPDATE Lesson
        SET content = ?,
            updated_by = ?,
            updated_at = GETDATE(),
            published_at = GETDATE(),
            status = 'Published'
        WHERE lesson_id = ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, content);
            ps.setInt(2, userId);
            ps.setInt(3, lessonId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getCourseByLesson(int lessonId) {

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
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public Lesson getNextLesson(int lessonId) {

        int courseId = getCourseByLesson(lessonId);

        if (courseId == -1) {
            return null;
        }

        String sql = """
        SELECT l.*
        FROM Lesson l
        JOIN Module m ON l.module_id = m.module_id
        WHERE m.course_id = ?
        ORDER BY m.display_order, l.display_order
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                boolean found = false;

                while (rs.next()) {

                    Lesson l = mapLesson(rs);

                    if (found) {
                        return l;
                    }

                    if (l.getLessonId() == lessonId) {
                        found = true;
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

  
}
