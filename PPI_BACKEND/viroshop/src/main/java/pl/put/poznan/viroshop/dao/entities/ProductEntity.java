package pl.put.poznan.viroshop.dao.entities;

import pl.put.poznan.viroshop.dao.enums.Category;
import pl.put.poznan.viroshop.dao.enums.Unit;

import javax.persistence.*;
import java.util.Set;

@Entity
public class ProductEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private String barcode;
    private String name;
    private Category category;
    private String description;
    private Unit unit;
    private String picture;
    private Boolean canBePurchaseToParcelLocker;

    @OneToMany(mappedBy = "productEntity")
    private Set<StoreEntity> storeEntities;

    @OneToMany(mappedBy = "product")
    private Set<ProductReservationEntity> productReservations;

    public ProductEntity() {
    }

    public ProductEntity(Long id, String barcode, String name, Category category, String description, Unit unit) {
        this.id = id;
        this.barcode = barcode;
        this.name = name;
        this.category = category;
        this.description = description;
        this.unit = unit;
        this.canBePurchaseToParcelLocker = true;
    }

    public ProductEntity(Long id, String barcode, String name, Category category, String description, Unit unit, String picture) {
        this.id = id;
        this.barcode = barcode;
        this.name = name;
        this.category = category;
        this.description = description;
        this.unit = unit;
        this.picture = picture;
        this.canBePurchaseToParcelLocker = true;
    }

    public ProductEntity(Long id, String barcode, String name, Category category, String description, Unit unit, Boolean canBePurchaseToParcelLocker, String picture) {
        this.id = id;
        this.barcode = barcode;
        this.name = name;
        this.category = category;
        this.description = description;
        this.unit = unit;
        this.picture = picture;
        this.canBePurchaseToParcelLocker = canBePurchaseToParcelLocker;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getBarcode() {
        return barcode;
    }

    public void setBarcode(String barcode) {
        this.barcode = barcode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Unit getUnit() {
        return unit;
    }

    public void setUnit(Unit unit) {
        this.unit = unit;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public Boolean getCanBePurchaseToParcelLocker() {
        return canBePurchaseToParcelLocker;
    }

    public void setCanBePurchaseToParcelLocker(Boolean canBePurchaseToParcelLocker) {
        this.canBePurchaseToParcelLocker = canBePurchaseToParcelLocker;
    }
}
