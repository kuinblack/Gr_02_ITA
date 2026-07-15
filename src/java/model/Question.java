package model;

import java.util.ArrayList;
import java.util.List;

public class Question {

    private int questionId;
    private int moduleId;
    private String content;
    private String questionType;
    private int createdBy;
    private List<QuestionOption> options = new ArrayList<>();

    public Question() {
    }

    // Constructor đầy đủ tham số để dựng nhanh đối tượng
    public Question(int questionId, int moduleId, String content, String questionType, int createdBy) {
        this.questionId = questionId;
        this.moduleId = moduleId;
        this.content = content;
        this.questionType = questionType;
        this.createdBy = createdBy;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public List<QuestionOption> getOptions() {
        return options;
    }

    public void setOptions(List<QuestionOption> options) {
        this.options = options;
    }
}
