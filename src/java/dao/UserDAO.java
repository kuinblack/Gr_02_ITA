package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;

public class UserDAO extends DBContext {

    // Login bằng Email + Password
    public User checkLogin(String email, String password) {
        String sql = """
                     SELECT *
                     FROM Users
                     WHERE email = ?
                       AND password_hash = ?
                       AND status = 'Active'
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email != null ? email.trim() : "");
            ps.setString(2, password != null ? password.trim() : "");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            // Sửa ở đây: Ném thẳng lỗi lên để Servlet tóm được và báo lên giao diện
            throw new RuntimeException("Lỗi SQL Server (checkLogin): " + e.getMessage(), e);
        }
        return null;
    }

    // Tìm user theo email (Google Login hoặc Forgot Password)
    public User getUserByEmail(String email) {
        String sql = """
                     SELECT *
                     FROM Users
                     WHERE email = ?
                     """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email != null ? email.trim() : "");

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            // Sửa ở đây: Ném thẳng lỗi lên
            throw new RuntimeException("Lỗi SQL Server (getUserByEmail): " + e.getMessage(), e);
        }
        return null;
    }

    // Hàm map ResultSet -> User
    private User mapUser(ResultSet rs) throws Exception {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setRoleId(rs.getInt("role_id"));
        u.setFullName(rs.getNString("full_name")); // Dùng getNString cho chuỗi Tiếng Việt có dấu không bị lỗi font
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setGoogleId(rs.getString("google_id"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}