package pl.put.poznan.viroshop.dao.entities;

import javax.persistence.*;

@Entity
public class ProductReservationEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private int count;
    @ManyToOne
    private ReservationEntity reservation;
    @ManyToOne
    private ProductEntity product;
}
