package pl.put.poznan.viroshop.dao.models;

import java.time.LocalDate;
import java.util.List;

public class UpdateReservationModel {

    private Long reservationId;
    private LocalDate date;
    private Integer quarterOfDay;
    private List<CreateProductReservationModel> productReservations;
    private Long shopId;
    private Long userId;

    public UpdateReservationModel() {
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Integer getQuarterOfDay() {
        return quarterOfDay;
    }

    public void setQuarterOfDay(Integer quarterOfDay) {
        this.quarterOfDay = quarterOfDay;
    }

    public List<CreateProductReservationModel> getProductReservations() {
        return productReservations;
    }

    public void setProductReservations(List<CreateProductReservationModel> productReservations) {
        this.productReservations = productReservations;
    }

    public Long getReservationId() {
        return reservationId;
    }

    public void setReservationId(Long reservationId) {
        this.reservationId = reservationId;
    }

    public Long getShopId() {
        return shopId;
    }

    public void setShopId(Long shopId) {
        this.shopId = shopId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }
}
