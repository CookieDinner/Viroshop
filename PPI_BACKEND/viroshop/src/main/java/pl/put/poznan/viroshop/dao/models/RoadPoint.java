package pl.put.poznan.viroshop.dao.models;

public class RoadPoint {
    private int order;
    private Long id;
    private int x;
    private int y;

    public RoadPoint() {
    }

    public RoadPoint(int order, Long id) {
        this.order = order;
        this.id = id;
    }

    public RoadPoint(int order, Long id, int x, int y) {
        this.order = order;
        this.id = id;
        this.x = x;
        this.y = y;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
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
