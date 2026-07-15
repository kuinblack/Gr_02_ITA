package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AssignmentDTO {

    // Thông tin từ Model Assignment
    private int assignmentId;
    private int classId;
    private String className;
    private String title;
    private String description;
    private Timestamp deadline;
    private BigDecimal totalScore;

    // Trạng thái xử lý logic hiển thị cho Sinh viên
    private boolean isSubmitted;      // true nếu sinh viên đã nộp bài
    private boolean isGraded;         // true nếu đã có bản ghi trong bảng Result
    private BigDecimal studentScore;  // Điểm lấy từ Result nếu đã graded
    private String feedback;          // Nhận xét từ Result nếu cần hiển thị luôn

    public AssignmentDTO() {
    }

    // Getter và Setter
    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        // Lưu ý: Sắp xếp ID sẽ được xử lý trực tiếp từ câu lệnh SQL ORDER BY ASC
        this.assignmentId = assignmentId;
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

    public Timestamp getDeadline() {
        return deadline;
    }

    public void setDeadline(Timestamp deadline) {
        this.deadline = deadline;
    }

    public BigDecimal getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(BigDecimal totalScore) {
        this.totalScore = totalScore;
    }

    public boolean isSubmitted() {
        return isSubmitted;
    }

    public void setSubmitted(boolean submitted) {
        isSubmitted = submitted;
    }

    public boolean isGraded() {
        return isGraded;
    }

    public void setGraded(boolean graded) {
        isGraded = graded;
    }

    public BigDecimal getStudentScore() {
        return studentScore;
    }

    public void setStudentScore(BigDecimal studentScore) {
        this.studentScore = studentScore;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }
}
