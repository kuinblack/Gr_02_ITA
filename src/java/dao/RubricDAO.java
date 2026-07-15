package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Rubric;

public class RubricDAO extends DBContext {

    private Rubric mapRubric(ResultSet rs) throws Exception {
        Rubric r = new Rubric();
        r.setRubricId(rs.getInt("rubric_id"));
        r.setAssignmentId(rs.getInt("assignment_id"));
        r.setCriteria(rs.getNString("criteria"));
        r.setWeight(rs.getBigDecimal("weight"));
        r.setDescription(rs.getNString("description"));
        return r;
    }

    // ===================== GET BY ASSIGNMENT =====================
    public List<Rubric> getRubricsByAssignment(int assignmentId) {

        List<Rubric> list = new ArrayList<>();

        String sql = """
                     SELECT *
                     FROM Rubric
                     WHERE assignment_id = ?
                     ORDER BY rubric_id
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapRubric(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===================== INSERT =====================
    public boolean insertRubric(Rubric r) {

        String sql = """
                     INSERT INTO Rubric
                     (assignment_id, criteria, weight, description)
                     VALUES (?, ?, ?, ?)
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, r.getAssignmentId());
            ps.setNString(2, r.getCriteria());
            ps.setBigDecimal(3, r.getWeight());
            ps.setNString(4, r.getDescription());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== UPDATE =====================
    public boolean updateRubric(Rubric r) {

        String sql = """
                     UPDATE Rubric
                     SET criteria = ?,
                         weight = ?,
                         description = ?
                     WHERE rubric_id = ?
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, r.getCriteria());
            ps.setBigDecimal(2, r.getWeight());
            ps.setNString(3, r.getDescription());
            ps.setInt(4, r.getRubricId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== DELETE =====================
    public boolean deleteRubric(int rubricId) {

        String sql = "DELETE FROM Rubric WHERE rubric_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, rubricId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ===================== DELETE BY ASSIGNMENT =====================
    public boolean deleteByAssignment(int assignmentId) {

        String sql = "DELETE FROM Rubric WHERE assignment_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, assignmentId);

            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
