package pl.put.poznan.viroshop.dao.entities;

import pl.put.poznan.viroshop.dao.Unit;

import javax.persistence.*;
import java.util.Set;

@Entity
public class ProductEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private String barcode;
    private String name;
    private String description;
    private Unit unit;

    @OneToMany(mappedBy = "productEntity")
    private Set<StoreEntity> storeEntities;

    public ProductEntity() {
    }

    public ProductEntity(Long id, String barcode, String name, String description, Unit unit) {
        this.id = id;
        this.barcode = barcode;
        this.name = name;
        this.description = description;
        this.unit = unit;
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

}
