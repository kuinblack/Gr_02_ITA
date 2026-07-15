package model;

public class Flashcard {

    private int flashcardId;

    private int moduleId;

    private String question;

    private String answer;

    private int createdBy;

    public Flashcard() {

    }

// Constructor dùng cho AI staging
    public Flashcard(int flashcardId, int moduleId,
            String question, String answer) {

        this.flashcardId = flashcardId;

        this.moduleId = moduleId;

        this.question = question;

        this.answer = answer;

    }

// Constructor đầy đủ
    public Flashcard(int flashcardId, int moduleId,
            String question, String answer,
            int createdBy) {

        this.flashcardId = flashcardId;

        this.moduleId = moduleId;

        this.question = question;

        this.answer = answer;

        this.createdBy = createdBy;

    }

    public int getFlashcardId() {

        return flashcardId;

    }

    public void setFlashcardId(int flashcardId) {

        this.flashcardId = flashcardId;

    }

    public int getModuleId() {

        return moduleId;

    }

    public void setModuleId(int moduleId) {

        this.moduleId = moduleId;

    }

// ===== Question / Answer =====
    public String getQuestion() {

        return question;

    }

    public void setQuestion(String question) {

        this.question = question;

    }

    public String getAnswer() {

        return answer;

    }

    public void setAnswer(String answer) {

        this.answer = answer;

    }

// ===== Alias cho code cũ =====
    public String getFrontContent() {

        return question;

    }

    public void setFrontContent(String frontContent) {

        this.question = frontContent;

    }

    public String getBackContent() {

        return answer;

    }

    public void setBackContent(String backContent) {

        this.answer = backContent;

    }

    public int getCreatedBy() {

        return createdBy;

    }

    public void setCreatedBy(int createdBy) {

        this.createdBy = createdBy;

    }

    @Override
    public String toString() {
        return "Flashcard{"
                + "flashcardId=" + flashcardId
                + ", moduleId=" + moduleId
                + ", question='" + question + "'"
                + ", answer='" + answer + "'"
                + "}";
    }

}
