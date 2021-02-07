package pl.put.poznan.viroshop.dao.entities;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIdentityReference;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import pl.put.poznan.viroshop.dao.enums.AlleysPositioning;

import javax.persistence.*;
import java.util.List;
import java.util.Set;


@Entity
public class ShopEntity {

    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    private Long id;

    private String city;
    private String street;
    private Integer number;
    private String name;
    private AlleysPositioning alleysPositioning;
    private Integer maxReservationsPerQuarterOfHour;

    @OneToMany(mappedBy = "shopEntity")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private Set<StoreEntity> storeEntities;

    @OneToMany(mappedBy = "shopEntity")
    @JsonIdentityInfo(generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
    @JsonIdentityReference(alwaysAsId = true)
    private List<AlleyEntity> alleys;

    public ShopEntity() {
    }

    public ShopEntity(Long id, String city, String street, Integer number, String name, AlleysPositioning alleysPositioning) {
        this.id = id;
        this.city = city;
        this.street = street;
        this.number = number;
        this.name = name;
        this.alleysPositioning = alleysPositioning;
        this.maxReservationsPerQuarterOfHour = 5;
    }

    public ShopEntity(Long id, String city, String street, Integer number, String name, AlleysPositioning alleysPositioning, Integer maxReservationsPerQuarterOfHour) {
        this.id = id;
        this.city = city;
        this.street = street;
        this.number = number;
        this.name = name;
        this.alleysPositioning = alleysPositioning;
        this.maxReservationsPerQuarterOfHour = maxReservationsPerQuarterOfHour;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<AlleyEntity> getAlleys() {
        return alleys;
    }

    public void setAlleys(List<AlleyEntity> alleys) {
        this.alleys = alleys;
    }

    public AlleysPositioning getAlleysPositioning() {
        return alleysPositioning;
    }

    public void setAlleysPositioning(AlleysPositioning alleysPositioning) {
        this.alleysPositioning = alleysPositioning;
    }

    public Integer getMaxReservationsPerQuarterOfHour() {
        return maxReservationsPerQuarterOfHour;
    }

    public void setMaxReservationsPerQuarterOfHour(Integer maxReservationsPerQuarterOfHour) {
        this.maxReservationsPerQuarterOfHour = maxReservationsPerQuarterOfHour;
    }

    public Set<StoreEntity> getStoreEntities() {
        return storeEntities;
    }

    public void setStoreEntities(Set<StoreEntity> storeEntities) {
        this.storeEntities = storeEntities;
    }
}
