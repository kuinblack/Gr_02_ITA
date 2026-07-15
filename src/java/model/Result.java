package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Result {

    private int resultId;
    private int submissionId;
    private BigDecimal score;
    private String feedback;
    private String gradedBy;
    private Timestamp gradedAt;

    public Result() {
    }

    public Result(int resultId, int submissionId, BigDecimal score, String feedback, String gradedBy, Timestamp gradedAt) {
        this.resultId = resultId;
        this.submissionId = submissionId;
        this.score = score;
        this.feedback = feedback;
        this.gradedBy = gradedBy;
        this.gradedAt = gradedAt;
    }

    public int getResultId() {
        return resultId;
    }

    public void setResultId(int resultId) {
        this.resultId = resultId;
    }

    public int getSubmissionId() {
        return submissionId;
    }

    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public String getGradedBy() {
        return gradedBy;
    }

    public void setGradedBy(String gradedBy) {
        this.gradedBy = gradedBy;
    }

    public Timestamp getGradedAt() {
        return gradedAt;
    }

    public void setGradedAt(Timestamp gradedAt) {
        this.gradedAt = gradedAt;
    }
}