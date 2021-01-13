package pl.put.poznan.viroshop.dao.entities;

import javax.persistence.*;
import java.sql.Date;
import java.util.Set;

@Entity
public class ReservationEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private Date date;
    private int quarterOfDay;

    @OneToMany(mappedBy = "reservation")
    private Set<ProductReservationEntity> productReservations;

    @ManyToOne
    private ShopEntity shop;

    @ManyToOne
    private UserEntity user;

}
