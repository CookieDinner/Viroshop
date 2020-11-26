package pl.put.poznan.viroshop.dao.entities;

import javax.persistence.*;


@Entity
public class StoreEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private Float quantity;
    private Float price;

    @ManyToOne
    private ShopEntity shopEntity;

    @ManyToOne
    private ProductEntity productEntity;

    public StoreEntity() {
    }

    public StoreEntity(Long id, Float quantity, Float price, ShopEntity shopEntity, ProductEntity productEntity) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.shopEntity = shopEntity;
        this.productEntity = productEntity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Float getQuantity() {
        return quantity;
    }

    public void setQuantity(Float quantity) {
        this.quantity = quantity;
    }
}
