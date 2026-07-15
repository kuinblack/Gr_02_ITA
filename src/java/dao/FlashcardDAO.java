package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Flashcard;
import model.FlashcardModule;

public class FlashcardDAO extends DBContext {

    // ================= MAP =================
    private Flashcard mapFlashcard(ResultSet rs) throws Exception {

        Flashcard f = new Flashcard();

        f.setFlashcardId(rs.getInt("flashcard_id"));
        f.setModuleId(rs.getInt("module_id"));

        // DATABASE dùng question / answer
        f.setQuestion(rs.getNString("question"));
        f.setAnswer(rs.getNString("answer"));

        f.setCreatedBy(rs.getInt("created_by"));

        return f;
    }

    // ================= SME: GET ALL =================
    public ArrayList<Flashcard> getAll() {

        ArrayList<Flashcard> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM Flashcard
            ORDER BY flashcard_id DESC
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapFlashcard(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET BY ID =================
    public Flashcard getFlashcardById(int id) {

        String sql = "SELECT * FROM Flashcard WHERE flashcard_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return mapFlashcard(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ================= STUDENT: GET BY MODULE =================
    public ArrayList<Flashcard> getFlashcardsByModule(int moduleId) {

        ArrayList<Flashcard> list = new ArrayList<>();

        String sql = """
            SELECT *
            FROM Flashcard
            WHERE module_id = ?
            ORDER BY flashcard_id
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    list.add(mapFlashcard(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= INSERT =================
    public boolean addFlashcard(Flashcard card) {

        String sql = """
            INSERT INTO Flashcard(module_id, question, answer, created_by)
            VALUES (?, ?, ?, ?)
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, card.getModuleId());
            ps.setNString(2, card.getQuestion());
            ps.setNString(3, card.getAnswer());
            ps.setInt(4, card.getCreatedBy());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= UPDATE =================
    public boolean updateFlashcard(Flashcard card) {

        String sql = """
            UPDATE Flashcard
            SET question = ?,
                answer = ?
            WHERE flashcard_id = ?
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setNString(1, card.getQuestion());
            ps.setNString(2, card.getAnswer());
            ps.setInt(3, card.getFlashcardId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= DELETE =================
    public boolean deleteFlashcard(int id) {

        String sql = "DELETE FROM Flashcard WHERE flashcard_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ================= MODULE NAME =================
    public String getModuleName(int moduleId) {

        String sql = "SELECT module_title FROM Module WHERE module_id = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, moduleId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getNString("module_title");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "Unknown Module";
    }

    // ================= MODULES OF COURSE =================
    public List<FlashcardModule> getModulesByCourse(int courseId) {

        List<FlashcardModule> list = new ArrayList<>();

        String sql = """
            SELECT m.module_id,
                   m.module_title,
                   m.display_order,
                   COUNT(f.flashcard_id) AS total_flashcards
            FROM Module m
            LEFT JOIN Flashcard f
                   ON m.module_id = f.module_id
            WHERE m.course_id = ?
            GROUP BY m.module_id, m.module_title, m.display_order
            ORDER BY m.display_order
        """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, courseId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    FlashcardModule fm = new FlashcardModule();

                    fm.setModuleId(rs.getInt("module_id"));
                    fm.setModuleName(rs.getNString("module_title"));
                    fm.setModuleOrder(rs.getInt("display_order"));
                    fm.setTotalFlashcards(rs.getInt("total_flashcards"));

                    list.add(fm);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}


