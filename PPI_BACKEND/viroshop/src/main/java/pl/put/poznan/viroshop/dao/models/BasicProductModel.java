package pl.put.poznan.viroshop.dao.models;

import pl.put.poznan.viroshop.dao.enums.Category;

public class BasicProductModel {

    private Long id;
    private String name;
    private boolean isAvailable;
    private Category category;

    public BasicProductModel() {
    }

    public BasicProductModel(Long id, String name, boolean isAvailable, Category category) {
        this.id = id;
        this.name = name;
        this.isAvailable = isAvailable;
        this.category = category;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }
}
