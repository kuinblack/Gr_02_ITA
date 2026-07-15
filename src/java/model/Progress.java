/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Progress {

    private int progressId;
    private int studentId;
    private int courseId;
    private float progressPercent;
    private int lessonCompleted;
    private int quizCompleted;
    private int assignmentCompleted;

    public Progress() {
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

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public float getProgressPercent() {
        return progressPercent;
    }

    public void setProgressPercent(float progressPercent) {
        this.progressPercent = progressPercent;
    }

    public int getLessonCompleted() {
        return lessonCompleted;
    }

    public void setLessonCompleted(int lessonCompleted) {
        this.lessonCompleted = lessonCompleted;
    }

    public int getQuizCompleted() {
        return quizCompleted;
    }

    public void setQuizCompleted(int quizCompleted) {
        this.quizCompleted = quizCompleted;
    }

    public int getAssignmentCompleted() {
        return assignmentCompleted;
    }

    public void setAssignmentCompleted(int assignmentCompleted) {
        this.assignmentCompleted = assignmentCompleted;
    }

}