package model;

import java.sql.Timestamp;

public class User {

    private int userId;
    private int roleId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String googleId;
    private String avatarUrl;
    private String status;
    private Timestamp createdAt;

    public User() {
    }

    public User(int userId, int roleId, String fullName, String email,
            String passwordHash, String googleId, String avatarUrl,
            String status, Timestamp createdAt) {
        this.userId = userId;
        this.roleId = roleId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.googleId = googleId;
        this.avatarUrl = avatarUrl;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "User{"
                + "userId=" + userId
                + ", roleId=" + roleId
                + ", fullName='" + fullName + "'"
                + ", email='" + email + "'"
                + ", status='" + status + "'"
                + ", createdAt=" + createdAt
                + "}";
    }
}
