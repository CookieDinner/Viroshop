package pl.put.poznan.viroshop.dao.entities;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;

import javax.persistence.*;

@Entity
public class ProductReservationEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private int count;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private ReservationEntity reservation;

    @ManyToOne
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private ProductEntity product;

    public ProductReservationEntity() {
    }

    public ProductReservationEntity(int count, ProductEntity product) {
        this.count = count;
        this.product = product;
    }

    public ProductReservationEntity(int count, ReservationEntity reservation, ProductEntity product) {
        this.count = count;
        this.reservation = reservation;
        this.product = product;
    }

    public ProductReservationEntity(Long id, int count, ReservationEntity reservation, ProductEntity product) {
        this.id = id;
        this.count = count;
        this.reservation = reservation;
        this.product = product;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public ReservationEntity getReservation() {
        return reservation;
    }

    public void setReservation(ReservationEntity reservation) {
        this.reservation = reservation;
    }

    public ProductEntity getProduct() {
        return product;
    }

    public void setProduct(ProductEntity product) {
        this.product = product;
    }
}
