package pl.put.poznan.viroshop.dao.models;

import java.time.LocalDate;

public class QuarterReservationCount {

    int quarter;
    long count;

    public QuarterReservationCount() {
    }

    public QuarterReservationCount(int quarter, long count) {
        this.quarter = quarter;
        this.count = count;
    }

    public int getDate() {
        return quarter;
    }

    public void setDate(int quarter) {
        this.quarter = quarter;
    }

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        this.count = count;
    }
}
