package pl.put.poznan.viroshop.dao.entities;

import javax.persistence.*;


@Entity
public class StoreEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private boolean isAvailable;
    private Float price;

    @ManyToOne
    private ShopEntity shopEntity;

    @ManyToOne
    private ProductEntity productEntity;

    public StoreEntity() {
    }

    public StoreEntity(Long id, boolean isAvailable, Float price, ShopEntity shopEntity, ProductEntity productEntity) {
        this.id = id;
        this.isAvailable = isAvailable;
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

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public ShopEntity getShopEntity() {
        return shopEntity;
    }

    public void setShopEntity(ShopEntity shopEntity) {
        this.shopEntity = shopEntity;
    }

    public ProductEntity getProductEntity() {
        return productEntity;
    }

    public void setProductEntity(ProductEntity productEntity) {
        this.productEntity = productEntity;
    }
}
