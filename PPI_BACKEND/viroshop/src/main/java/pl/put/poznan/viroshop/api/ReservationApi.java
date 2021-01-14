package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import pl.put.poznan.viroshop.dao.entities.ProductReservationEntity;
import pl.put.poznan.viroshop.dao.entities.ReservationEntity;
import pl.put.poznan.viroshop.dao.models.CreateReservationModel;
import pl.put.poznan.viroshop.dao.models.UpdateReservationModel;
import pl.put.poznan.viroshop.manager.ReservationManager;

@RestController
public class ReservationApi {

    private final ReservationManager reservationManager;

    @Autowired
    public ReservationApi(ReservationManager reservationManager) {
        this.reservationManager = reservationManager;
    }

    @GetMapping(value = "/api/reservation/dates/month", produces = "application/json; charset=UTF-8")
    public Iterable<Integer> getAllReservationDatesFromMonth(@RequestParam Long userId, @RequestParam int month, @RequestParam int year) {
        return reservationManager.getAllReservationDatesFromMonth(userId, month, year);
    }

    @GetMapping(value = "/api/reservation/all", produces = "application/json; charset=UTF-8")
    public Iterable<ReservationEntity> getAllUserReservations(@RequestParam Long userId) {
        return reservationManager.getAllUserReservations(userId);
    }

    @GetMapping(value = "/api/reservation/all/shop", produces = "application/json; charset=UTF-8")
    public Iterable<ReservationEntity> getAllUserReservationsForShop(@RequestParam Long userId, @RequestParam Long shopId) {
        return reservationManager.getAllUserReservationsForShop(userId, shopId);
    }

    @GetMapping(value = "/api/reservation/products", produces = "application/json; charset=UTF-8")
    public Iterable<ProductReservationEntity> getAllProductsFromReservation(@RequestParam Long reservationId) {
        return reservationManager.getAllProductsFromReservation(reservationId);
    }

    @PostMapping(value = "/api/reservation/new", produces = "application/json; charset=UTF-8")
    public ReservationEntity addNewReservation(@RequestBody CreateReservationModel reservation) {
        return reservationManager.addNewReservation(reservation);
    }

    @PutMapping(value = "/api/reservation/edit", produces = "application/json; charset=UTF-8")
    public ReservationEntity editReservation(@RequestBody UpdateReservationModel reservation) {
        return reservationManager.editReservation(reservation);
    }


}
