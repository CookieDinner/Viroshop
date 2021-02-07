package pl.put.poznan.viroshop.dao.models;

import java.time.LocalDate;

public class DayReservationCount {

    LocalDate date;
    long count;

    public DayReservationCount() {
    }

    public DayReservationCount(LocalDate date, long count) {
        this.date = date;
        this.count = count;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public long getCount() {
        return count;
    }

    public void setCount(long count) {
        this.count = count;
    }
}
