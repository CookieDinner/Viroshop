package pl.put.poznan.viroshop.dao.models;

import pl.put.poznan.viroshop.dao.enums.Category;
import pl.put.poznan.viroshop.dao.enums.Unit;

public class BasicProductModel {

    private Long id;
    private String name;
    private boolean isAvailable;
    private Category category;
    private Float price;
    private Unit unit;

    public BasicProductModel() {
    }

    public BasicProductModel(Long id, String name, boolean isAvailable, Category category, Float price, Unit unit) {
        this.id = id;
        this.name = name;
        this.isAvailable = isAvailable;
        this.category = category;
        this.price = price;
        this.unit = unit;
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

    public Float getPrice() { return price; }

    public void setPrice(Float price) { this.price = price; }

    public Unit getUnit() {
        return unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
    }
}
