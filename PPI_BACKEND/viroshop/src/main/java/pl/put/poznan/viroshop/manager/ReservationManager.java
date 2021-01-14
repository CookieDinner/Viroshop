package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.*;
import pl.put.poznan.viroshop.dao.models.CreateReservationModel;
import pl.put.poznan.viroshop.dao.models.UpdateReservationModel;
import pl.put.poznan.viroshop.dao.repositories.ProductReservationRepo;
import pl.put.poznan.viroshop.dao.repositories.ReservationRepo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class ReservationManager {

    private final ReservationRepo reservationRepo;
    private final ProductReservationRepo productReservationRepo;
    private final ShopManager shopManager;
    private final UserManager userManager;
    private final ProductManager productManager;

    @Autowired
    public ReservationManager(ReservationRepo reservationRepo, ProductReservationRepo productReservationRepo, ShopManager shopManager, UserManager userManager, ProductManager productManager) {
        this.reservationRepo = reservationRepo;
        this.productReservationRepo = productReservationRepo;
        this.shopManager = shopManager;
        this.userManager = userManager;
        this.productManager = productManager;
    }

    public Iterable<Integer> getAllReservationDatesFromMonth(Long userId, int month, int year) {
        Iterable<ReservationEntity> allReservations = reservationRepo.findAll();
        ArrayList<ReservationEntity> filteredReservations = StreamSupport.stream(allReservations.spliterator(), false)
                .filter(reservation -> reservation.getUser().getId() == userId)
                .filter(reservation -> reservation.getDate().getYear() == year)
                .filter(reservation -> {
                    System.out.println(reservation.getDate().getMonth().getValue());
                    return reservation.getDate().getMonth().getValue() == month;
                })
                .collect(Collectors.toCollection(ArrayList::new));
        ArrayList<Integer> days = filteredReservations.stream()
                .map(reservation -> reservation.getDate().getDayOfMonth())
                .distinct()
                .collect(Collectors.toCollection(ArrayList::new));
        return days;
    }

    public Iterable<ReservationEntity> getAllUserReservations(Long userId) {
        Iterable<ReservationEntity> allReservations = reservationRepo.findAll();
        return StreamSupport.stream(allReservations.spliterator(), false)
                .filter(reservation -> reservation.getUser().getId() == userId)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public Iterable<ReservationEntity> getAllUserReservationsForShop(Long userId, Long shopId) {
        Iterable<ReservationEntity> allReservations = reservationRepo.findAll();
        return StreamSupport.stream(allReservations.spliterator(), false)
                .filter(reservation -> reservation.getUser().getId() == userId)
                .filter(reservation -> reservation.getShop().getId() == shopId)
                .collect(Collectors.toCollection(ArrayList::new));
    }

    public Iterable<ProductReservationEntity> getAllProductsFromReservation(Long reservationId) {
        ReservationEntity reservation = reservationRepo.findById(reservationId).get();
        return reservation.getProductReservations();
    }

    public ReservationEntity addNewReservation(CreateReservationModel reservationModel) {
        synchronized (this) {
            int quarter = reservationModel.getQuarterOfDay();
            LocalDate date = reservationModel.getDate();
            UserEntity userEntity = userManager.findOneById(reservationModel.getUserId()).get();
            ShopEntity shopEntity = shopManager.findOneById(reservationModel.getShopId()).get();
            long numberOfCurrentReservation = getReservationsCount(reservationModel, shopEntity);

            if (numberOfCurrentReservation >= shopEntity.getMaxReservationsPerQuarterOfHour()) {
                return null;
            }

            Set<ProductReservationEntity> productReservationEntities = getProductReservations(reservationModel);
            ReservationEntity reservation = new ReservationEntity(date, quarter, productReservationEntities, shopEntity, userEntity);

            ReservationEntity newReservationEntity = reservationRepo.save(reservation);
            productReservationEntities.forEach(x -> {
                x.setReservation(newReservationEntity);
                productReservationRepo.save(x);
            });
            return newReservationEntity;
        }
    }

    public ReservationEntity editReservation(UpdateReservationModel reservationModel) {

        ReservationEntity reservation = reservationRepo.findById(reservationModel.getReservationId()).get();
        if (reservation == null) {
            return null;
        }

        synchronized (this) {
            Integer quarter = reservationModel.getQuarterOfDay();
            LocalDate date = reservationModel.getDate();
            UserEntity userEntity = userManager.findOneById(reservationModel.getUserId()).get();
            ShopEntity shopEntity = shopManager.findOneById(reservationModel.getShopId()).get();
            long numberOfCurrentReservation = getReservationsCount(reservationModel, shopEntity);

            if (numberOfCurrentReservation >= shopEntity.getMaxReservationsPerQuarterOfHour()) {
                return null;
            }

            Set<ProductReservationEntity> productReservationEntities = getProductReservations(reservationModel);

            if (quarter != null) {
                reservation.setQuarterOfDay(quarter);
            }
            if (date != null) {
                reservation.setDate(date);
            }
            if (userEntity != null) {
                reservation.setUser(userEntity);
            }
            if (shopEntity != null) {
                reservation.setShop(shopEntity);
            }

            ReservationEntity newReservationEntity = reservationRepo.save(reservation);
            productReservationEntities.forEach(x -> {
                x.setReservation(newReservationEntity);
                productReservationRepo.save(x);
            });
            return newReservationEntity;
        }
    }

    private HashSet<ProductReservationEntity> getProductReservations(CreateReservationModel reservationModel) {
        return reservationModel.getProductReservations().stream().map(model -> {
            int count = model.getCount();
            ProductEntity productEntity = productManager.findOneById(model.getProductId()).get();
            ProductReservationEntity productReservationEntity = new ProductReservationEntity(count, productEntity);
            return productReservationRepo.save(productReservationEntity);
        }).collect(Collectors.toCollection(HashSet::new));
    }

    private HashSet<ProductReservationEntity> getProductReservations(UpdateReservationModel reservationModel) {
        return reservationModel.getProductReservations().stream().map(model -> {
            int count = model.getCount();
            ProductEntity productEntity = productManager.findOneById(model.getProductId()).get();
            ProductReservationEntity productReservationEntity = new ProductReservationEntity(count, productEntity);
            return productReservationRepo.save(productReservationEntity);
        }).collect(Collectors.toCollection(HashSet::new));
    }

    private long getReservationsCount(CreateReservationModel reservationModel, ShopEntity shopEntity) {
        return StreamSupport.stream(reservationRepo.findAll().spliterator(), false)
                .filter(res -> res.getShop().getId() == shopEntity.getId())
                .filter(res -> res.getDate() == reservationModel.getDate())
                .filter(res -> res.getQuarterOfDay() == reservationModel.getQuarterOfDay())
                .count();
    }

    private long getReservationsCount(UpdateReservationModel reservationModel, ShopEntity shopEntity) {
        return StreamSupport.stream(reservationRepo.findAll().spliterator(), false)
                .filter(res -> res.getShop().getId() == shopEntity.getId())
                .filter(res -> res.getDate() == reservationModel.getDate())
                .filter(res -> res.getQuarterOfDay() == reservationModel.getQuarterOfDay())
                .count();
    }


}
