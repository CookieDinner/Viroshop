package pl.put.poznan.viroshop.dao.entities;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import javax.persistence.*;
import java.time.LocalDate;
import java.util.Set;

@Entity
public class ReservationEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private LocalDate date;
    private int quarterOfDay;

    @OneToMany(mappedBy = "reservation")
    private Set<ProductReservationEntity> productReservations;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private ShopEntity shop;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private UserEntity user;

    public ReservationEntity() {
    }

    public ReservationEntity(LocalDate date, int quarterOfDay, Set<ProductReservationEntity> productReservations, ShopEntity shop, UserEntity user) {
        this.date = date;
        this.quarterOfDay = quarterOfDay;
        this.productReservations = productReservations;
        this.shop = shop;
        this.user = user;
    }

    public ReservationEntity(Long id, LocalDate date, int quarterOfDay, Set<ProductReservationEntity> productReservations, ShopEntity shop, UserEntity user) {
        this.id = id;
        this.date = date;
        this.quarterOfDay = quarterOfDay;
        this.productReservations = productReservations;
        this.shop = shop;
        this.user = user;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public int getQuarterOfDay() {
        return quarterOfDay;
    }

    public void setQuarterOfDay(int quarterOfDay) {
        this.quarterOfDay = quarterOfDay;
    }

    public Set<ProductReservationEntity> getProductReservations() {
        return productReservations;
    }

    public void setProductReservations(Set<ProductReservationEntity> productReservations) {
        this.productReservations = productReservations;
    }

    public ShopEntity getShop() {
        return shop;
    }

    public void setShop(ShopEntity shop) {
        this.shop = shop;
    }

    public UserEntity getUser() {
        return user;
    }

    public void setUser(UserEntity user) {
        this.user = user;
    }
}
