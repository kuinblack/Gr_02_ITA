package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Module;

public class ModuleDAO extends DBContext {

    // ================= GET MODULE BY ID =================
    public Module getModuleById(int moduleId) {

        String sql = "SELECT * FROM Module WHERE module_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);

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

    // ================= GET MODULES BY COURSE =================
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
                    list.add(map(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= COUNT MODULES =================
    public int countModulesByCourse(int courseId) {

        String sql = "SELECT COUNT(*) FROM Module WHERE course_id = ?";

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

    // ================= FIRST MODULE =================
    public Module getFirstModuleByCourse(int courseId) {

        String sql = """
            SELECT TOP 1 *
            FROM Module
            WHERE course_id = ?
            ORDER BY display_order
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

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

    // ================= CHECK MODULE BELONGS COURSE =================
    public boolean belongsToCourse(int moduleId, int courseId) {

        String sql = """
            SELECT COUNT(*)
            FROM Module
            WHERE module_id = ?
              AND course_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);
            ps.setInt(2, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= INSERT =================
    public boolean insertModule(Module m) {

        String sql = """
            INSERT INTO Module(course_id, module_title, display_order)
            VALUES (?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, m.getCourseId());
            ps.setNString(2, m.getModuleTitle());
            ps.setInt(3, m.getDisplayOrder());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= UPDATE =================
    public boolean updateModule(Module m) {

        String sql = """
            UPDATE Module
            SET module_title = ?,
                display_order = ?
            WHERE module_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, m.getModuleTitle());
            ps.setInt(2, m.getDisplayOrder());
            ps.setInt(3, m.getModuleId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= DELETE =================
    public boolean deleteModule(int moduleId) {

        String sql = "DELETE FROM Module WHERE module_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= MAP =================
    private Module map(ResultSet rs) throws Exception {

        Module m = new Module();

        m.setModuleId(rs.getInt("module_id"));
        m.setCourseId(rs.getInt("course_id"));
        m.setModuleTitle(rs.getNString("module_title"));
        m.setDisplayOrder(rs.getInt("display_order"));

        return m;
    }
}