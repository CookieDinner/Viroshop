package pl.put.poznan.viroshop.dao.entities;

import pl.put.poznan.viroshop.dao.AlleyType;

import javax.persistence.*;
import java.util.Set;

@Entity
public class AlleyEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private int xposition;

    private int yposition;

    private AlleyType type;

    @OneToMany(mappedBy = "alleyEntity")
    private Set<ProductEntity> products;

    @ManyToOne
    private ShopEntity shopEntity;

    public AlleyEntity() {
    }

    public AlleyEntity(Long id, int xposition, int yposition, AlleyType type, Set<ProductEntity> products, ShopEntity shopEntity) {
        this.id = id;
        this.xposition = xposition;
        this.yposition = yposition;
        this.type = type;
        this.products = products;
        this.shopEntity = shopEntity;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getXposition() {
        return xposition;
    }

    public void setXposition(int xposition) {
        this.xposition = xposition;
    }

    public int getYposition() {
        return yposition;
    }

    public void setYposition(int yposition) {
        this.yposition = yposition;
    }

    public Set<ProductEntity> getProducts() {
        return products;
    }

    public void setProducts(Set<ProductEntity> products) {
        this.products = products;
    }

    public ShopEntity getShopEntity() {
        return shopEntity;
    }

    public void setShopEntity(ShopEntity shopEntity) {
        this.shopEntity = shopEntity;
    }

    public AlleyType getType() {
        return type;
    }

    public void setType(AlleyType type) {
        this.type = type;
    }
}
