package model;

public class QuestionOption {

    private int optionId;
    private int questionId;
    private String optionLabel;
    private String optionContent;
    private boolean correct;

    public QuestionOption() {
    }

    // Constructor không chứa optionId (dùng khi insert mới vì DB tự tăng ID)
    public QuestionOption(int questionId, String optionLabel, String optionContent, boolean correct) {
        this.questionId = questionId;
        this.optionLabel = optionLabel;
        this.optionContent = optionContent;
        this.correct = correct;
    }

    public QuestionOption(int optionId, int questionId, String optionLabel, String optionContent, boolean correct) {
        this.optionId = optionId;
        this.questionId = questionId;
        this.optionLabel = optionLabel;
        this.optionContent = optionContent;
        this.correct = correct;
    }

    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getOptionLabel() {
        return optionLabel;
    }

    public void setOptionLabel(String optionLabel) {
        this.optionLabel = optionLabel;
    }

    public String getOptionContent() {
        return optionContent;
    }

    public void setOptionContent(String optionContent) {
        this.optionContent = optionContent;
    }

    public boolean isCorrect() {
        return correct;
    }

    public void setCorrect(boolean correct) {
        this.correct = correct;
    }

    @Override
    public String toString() {
        return String.format("QuestionOption{optionId=%d, questionId=%d, optionLabel='%s', optionContent='%s', correct=%b}",
                optionId, questionId, optionLabel, optionContent, correct);
    }
}
