package model;

import java.sql.Timestamp;

public class AILessonDraft {

    private int draftId;
    private int lessonId;
    private String prompt;
    private String generatedContent;
    private String status;
    private Timestamp generatedAt;
    private Integer reviewedBy;
    private Timestamp reviewedAt;
    private String sourceType;
    private String sourceReference;

    public AILessonDraft() {
    }

    public AILessonDraft(int draftId, int lessonId, String prompt, String generatedContent, String status, Timestamp generatedAt, Integer reviewedBy, Timestamp reviewedAt, String sourceType, String sourceReference) {
        this.draftId = draftId;
        this.lessonId = lessonId;
        this.prompt = prompt;
        this.generatedContent = generatedContent;
        this.status = status;
        this.generatedAt = generatedAt;
        this.reviewedBy = reviewedBy;
        this.reviewedAt = reviewedAt;
        this.sourceType = sourceType;
        this.sourceReference = sourceReference;
    }

    public int getDraftId() {
        return draftId;
    }

    public void setDraftId(int draftId) {
        this.draftId = draftId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getPrompt() {
        return prompt;
    }

    public void setPrompt(String prompt) {
        this.prompt = prompt;
    }

    public String getGeneratedContent() {
        return generatedContent;
    }

    public void setGeneratedContent(String generatedContent) {
        this.generatedContent = generatedContent;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(Timestamp generatedAt) {
        this.generatedAt = generatedAt;
    }

    public Integer getReviewedBy() {
        return reviewedBy;
    }

    public void setReviewedBy(Integer reviewedBy) {
        this.reviewedBy = reviewedBy;
    }

    public Timestamp getReviewedAt() {
        return reviewedAt;
    }

    public void setReviewedAt(Timestamp reviewedAt) {
        this.reviewedAt = reviewedAt;
    }

    public String getSourceType() {
        return sourceType;
    }

    public void setSourceType(String sourceType) {
        this.sourceType = sourceType;
    }

    public String getSourceReference() {
        return sourceReference;
    }

    public void setSourceReference(String sourceReference) {
        this.sourceReference = sourceReference;
    }

}
