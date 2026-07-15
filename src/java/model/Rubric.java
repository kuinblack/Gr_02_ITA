package model;

import java.math.BigDecimal;

public class Rubric {

    private int rubricId;
    private int assignmentId;
    private String criteria;
    private BigDecimal weight;
    private String description;

    public Rubric() {
    }

    public int getRubricId() {
        return rubricId;
    }

    public void setRubricId(int rubricId) {
        this.rubricId = rubricId;
    }

    public int getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(int assignmentId) {
        this.assignmentId = assignmentId;
    }

    public String getCriteria() {
        return criteria;
    }

    public void setCriteria(String criteria) {
        this.criteria = criteria;
    }

    public BigDecimal getWeight() {
        return weight;
    }

    public void setWeight(BigDecimal weight) {
        this.weight = weight;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
