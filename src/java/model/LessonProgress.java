package model;

import java.sql.Timestamp;

public class LessonProgress {

    private int progressId;
    private int studentId;
    private int lessonId;
    private String status;
    private Timestamp completedAt;

    public LessonProgress() {
    }

    public LessonProgress(int progressId, int studentId, int lessonId, String status, Timestamp completedAt) {
        this.progressId = progressId;
        this.studentId = studentId;
        this.lessonId = lessonId;
        this.status = status;
        this.completedAt = completedAt;
    }

    public int getProgressId() {
        return progressId;
    }

    public void setProgressId(int progressId) {
        this.progressId = progressId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }
    
}