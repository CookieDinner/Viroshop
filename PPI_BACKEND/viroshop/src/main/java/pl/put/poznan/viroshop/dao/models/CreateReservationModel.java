package pl.put.poznan.viroshop.dao.models;

import java.time.LocalDate;
import java.util.List;

public class CreateReservationModel {

    private LocalDate date;
    private Integer quarterOfDay;
    private List<CreateProductReservationModel> productReservations;
    private Long shopId;
    private String login;

    public CreateReservationModel() {
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

    public Long getShopId() {
        return shopId;
    }

    public void setShopId(Long shopId) {
        this.shopId = shopId;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }
}
