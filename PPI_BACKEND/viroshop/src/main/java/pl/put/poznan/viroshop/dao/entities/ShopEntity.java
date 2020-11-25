package pl.put.poznan.viroshop.dao.entities;

import javax.persistence.*;
import java.util.Set;


@Entity
public class ShopEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private String city;
    private String street;
    private Integer number;
    private String name;

    @ManyToMany
    @JoinTable(
            name = "shops_products",
            joinColumns = @JoinColumn(name = "shop_id"),
            inverseJoinColumns = @JoinColumn(name = "product_id")
    )
    private Set<ProductEntity> productEntities;

    public ShopEntity() {
    }

    public ShopEntity(Long id, String city, String street, Integer number, String name) {
        this.id = id;
        this.city = city;
        this.street = street;
        this.number = number;
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
