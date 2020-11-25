package pl.put.poznan.viroshop.dao.entities;

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
    private Float price;

    @ManyToMany(mappedBy = "productEntities")
    private Set<ShopEntity> shopEntities;

    public ProductEntity() {
    }

    public ProductEntity(Long id, String barcode, String name, String description, Float price) {
        this.id = id;
        this.barcode = barcode;
        this.name = name;
        this.description = description;
        this.price = price;
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

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }
}
