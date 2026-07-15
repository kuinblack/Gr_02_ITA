package model;

import java.util.ArrayList;
import java.util.List;

public class Module {

    private int moduleId;
    private int courseId;
    private String moduleTitle;
    private int displayOrder;
    
    private List<Lesson> lessons = new ArrayList<>();
    
    public Module() {
    }

    public Module(int moduleId, int courseId, String moduleTitle, int displayOrder) {
        this.moduleId = moduleId;
        this.courseId = courseId;
        this.moduleTitle = moduleTitle;
        this.displayOrder = displayOrder;
    }

    public List<Lesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<Lesson> lessons) {
        this.lessons = lessons;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getModuleTitle() {
        return moduleTitle;
    }

    public void setModuleTitle(String moduleTitle) {
        this.moduleTitle = moduleTitle;
    }

    public int getDisplayOrder() {
        return displayOrder;
    }

    public void setDisplayOrder(int displayOrder) {
        this.displayOrder = displayOrder;
    }
}
