package pl.put.poznan.viroshop.dao.models;

public class RoadPoint {
    private int order;
    private Long id;

    public RoadPoint() {
    }

    public RoadPoint(int order, Long id) {
        this.order = order;
        this.id = id;
    }

    public int getOrder() {
        return order;
    }

    public void setOrder(int order) {
        this.order = order;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
