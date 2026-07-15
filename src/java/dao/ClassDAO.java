package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Class;

public class ClassDAO extends DBContext {

    private Class map(ResultSet rs) throws Exception {

        Class c = new Class();

        c.setClassId(rs.getInt("class_id"));
        c.setCourseId(rs.getInt("course_id"));
        c.setClassName(rs.getString("class_name"));
        c.setStartDate(rs.getDate("start_date"));
        c.setEndDate(rs.getDate("end_date"));
        c.setCapacity((Integer) rs.getObject("capacity"));
        c.setStatus(rs.getString("status"));

        return c;
    }

    // ================= GET ALL =================
    public List<Class> getAllClasses() {

        List<Class> list = new ArrayList<>();

        String sql = "SELECT * FROM Class ORDER BY class_name";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET BY ID =================
    public Class getClassById(int id) {

        String sql = "SELECT * FROM Class WHERE class_id = ?";

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

    // ================= GET BY COURSE =================
    public List<Class> getClassesByCourse(int courseId) {

        List<Class> list = new ArrayList<>();

        String sql = "SELECT * FROM Class WHERE course_id = ? ORDER BY class_name";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

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
}
