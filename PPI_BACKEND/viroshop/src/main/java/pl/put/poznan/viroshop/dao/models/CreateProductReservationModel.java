package pl.put.poznan.viroshop.dao.models;

public class CreateProductReservationModel {

    private Long productId;
    private int count;

    public CreateProductReservationModel() {
    }

    public CreateProductReservationModel(Long productId, int count) {
        this.productId = productId;
        this.count = count;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
