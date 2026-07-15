package model;

import java.math.BigDecimal;

import java.sql.Timestamp;

public class Course {

    private int courseId;

    private String title;

    private String description;

    private String thumbnailUrl;

    private BigDecimal price;

    private int createdBy;

    private String status;

    private Timestamp createdAt;
    private int lessonCompleted;

// Dùng cho Student Dashboard
    private int classId;
    private String className;
    private int totalLessons;
    private float progressPercent;
    private int completedLessons;

    public Course() {

    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
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

    public int getLessonCompleted() {
        return lessonCompleted;
    }

    public void setLessonCompleted(int lessonCompleted) {
        this.lessonCompleted = lessonCompleted;
        this.completedLessons = lessonCompleted;
    }

    public int getClassId() {
        return classId;
    }

    public void setClassId(int classId) {
        this.classId = classId;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(int totalLessons) {
        this.totalLessons = totalLessons;
    }

    public float getProgressPercent() {
        return progressPercent;
    }

    public void setProgressPercent(float progressPercent) {
        this.progressPercent = progressPercent;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public void setCompletedLessons(int completedLessons) {
        this.completedLessons = completedLessons;
    }

    @Override
    public String toString() {
        return "Course{"
                + "courseId=" + courseId
                + ", title='" + title + "'"
                + ", status='" + status + "'"
                + ", price=" + price
                + "}";
    }
}
