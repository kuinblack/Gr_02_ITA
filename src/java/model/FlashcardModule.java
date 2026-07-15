/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class FlashcardModule {
    private int moduleId;
    private String moduleName;
    private int moduleOrder;
    private int totalFlashcards;

    public FlashcardModule() {
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public int getModuleOrder() {
        return moduleOrder;
    }

    public void setModuleOrder(int moduleOrder) {
        this.moduleOrder = moduleOrder;
    }

    public int getTotalFlashcards() {
        return totalFlashcards;
    }

    public void setTotalFlashcards(int totalFlashcards) {
        this.totalFlashcards = totalFlashcards;
    }
    
}
