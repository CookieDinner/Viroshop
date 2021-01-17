package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.*;
import pl.put.poznan.viroshop.dao.models.CreateReservationModel;
import pl.put.poznan.viroshop.dao.models.DayReservationCount;
import pl.put.poznan.viroshop.dao.models.QuarterReservationCount;
import pl.put.poznan.viroshop.dao.models.UpdateReservationModel;
import pl.put.poznan.viroshop.dao.repositories.ProductReservationRepo;
import pl.put.poznan.viroshop.dao.repositories.ReservationRepo;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.*;
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
                .filter(reservation -> reservation.getDate().getMonth().getValue() == month)
                .collect(Collectors.toCollection(ArrayList::new));
        ArrayList<Integer> days = filteredReservations.stream()
                .map(reservation -> reservation.getDate().getDayOfMonth())
                .distinct()
                .collect(Collectors.toCollection(ArrayList::new));
        return days;
    }

    public Iterable<DayReservationCount> getMonthReservationCounts(Long shopId, int month, int year) {
        Iterable<ReservationEntity> allReservations = reservationRepo.findAll();
        ArrayList<ReservationEntity> filteredReservations = StreamSupport.stream(allReservations.spliterator(), false)
                .filter(reservation -> reservation.getShop().getId() == shopId)
                .filter(reservation -> reservation.getDate().getYear() == year)
                .filter(reservation -> reservation.getDate().getMonth().getValue() == month)
                .collect(Collectors.toCollection(ArrayList::new));

        Map<LocalDate, Long> mapCounts = new HashMap<>();

        ShopEntity shopEntity = shopManager.findOneById(shopId).get();
        for (ReservationEntity reservation : filteredReservations) {
            LocalDate date = reservation.getDate();
            long count = this.getReservationsDayCount(date, shopEntity);
            if (mapCounts.keySet().contains(date)) {
                Long oldValue = mapCounts.get(date);
                mapCounts.put(date, oldValue + count);
            } else {
                mapCounts.put(date, count);
            }
        }
        ArrayList<DayReservationCount> counts = new ArrayList<>();
        mapCounts.forEach((key, value) -> {
            counts.add(new DayReservationCount(key, value));
        });

        return counts;
    }

    public Iterable<QuarterReservationCount> getDayReservationCounts(Long shopId, LocalDate date) {
        ArrayList<QuarterReservationCount> counts = new ArrayList<>();

        ShopEntity shopEntity = shopManager.findOneById(shopId).get();
        for (int quarter = 0; quarter < 16 * 4; quarter++) {
            long count = getReservationsCountForQuarter(date, quarter, shopEntity);
            counts.add(new QuarterReservationCount(quarter, count));
        }
        return counts;
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

    public final int FIRST_QUARTER_FOR_SENIORS = 12; // 10:00
    public final int LAST_QUARTER_FOR_SENIORS = 23; //12:00
    public final int SENIOR_AGE = 65;

    public ReservationEntity addNewReservation(CreateReservationModel reservationModel) {
        synchronized (this) {
            int quarter = reservationModel.getQuarterOfDay();
            LocalDate date = reservationModel.getDate();
            UserEntity userEntity = userManager.findByLogin(reservationModel.getLogin()).get(0);
            if (quarter >= FIRST_QUARTER_FOR_SENIORS && quarter < LAST_QUARTER_FOR_SENIORS) {
                boolean isSenior =
                        date.getYear() - userEntity.getBirthDate().getYear() > SENIOR_AGE
                                || (date.getYear() - userEntity.getBirthDate().getYear() == SENIOR_AGE
                                || date.getDayOfYear() >= userEntity.getBirthDate().getDayOfYear());
                boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                if (!isSenior && !isWeekend) {
                    return null;
                }
            }
            ShopEntity shopEntity = shopManager.findOneById(reservationModel.getShopId()).get();
            long numberOfCurrentReservation = getReservationsCountForQuarter(reservationModel.getDate(), reservationModel.getQuarterOfDay(), shopEntity);

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

    public boolean editReservation(UpdateReservationModel reservationModel) {

        ReservationEntity reservation = reservationRepo.findById(reservationModel.getReservationId()).get();
        if (reservation == null) {
            return false;
        }

        synchronized (this) {

            UserEntity userEntity = reservation.getUser();
            if (reservationModel.getUserId() != null) {
                userEntity = userManager.findOneById(reservationModel.getUserId()).get();
                reservation.setUser(userEntity);
            }
            if (reservationModel.getShopId() != null) {
                reservation.setShop(shopManager.findOneById(reservationModel.getShopId()).get());
            }

            long numberOfCurrentReservation = getReservationsCountForQuarter(reservationModel.getDate(), reservationModel.getQuarterOfDay(), reservation.getShop());

            if (numberOfCurrentReservation >= reservation.getShop().getMaxReservationsPerQuarterOfHour()) {
                return false;
            }

            Set<ProductReservationEntity> productReservationEntities = null;
            if (reservationModel.getProductReservations() != null) {
                productReservationEntities = getNewProductReservations(reservationModel);
            }

            Integer quarter = reservationModel.getQuarterOfDay();
            LocalDate date = reservationModel.getDate();

            if (quarter != null) {
                if (quarter >= FIRST_QUARTER_FOR_SENIORS && quarter < LAST_QUARTER_FOR_SENIORS) {
                    boolean isSenior =
                            date.getYear() - userEntity.getBirthDate().getYear() > SENIOR_AGE
                                    || (date.getYear() - userEntity.getBirthDate().getYear() == SENIOR_AGE
                                    || date.getDayOfYear() >= userEntity.getBirthDate().getDayOfYear());
                    boolean isWeekend = date.getDayOfWeek() == DayOfWeek.SATURDAY || date.getDayOfWeek() == DayOfWeek.SUNDAY;
                    if (isSenior || isWeekend) {
                        reservation.setQuarterOfDay(quarter);
                    }
                }
            }
            if (date != null) {
                reservation.setDate(date);
            }

            if (productReservationEntities != null) {
                reservation.getProductReservations().forEach(x -> {
                    x.setReservation(null);
                    productReservationRepo.save(x);
                });
                productReservationEntities.forEach(x -> {
                    x.setReservation(reservation);
                    productReservationRepo.save(x);
                });
            }
            reservationRepo.save(reservation);
            return true;
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

    private HashSet<ProductReservationEntity> getNewProductReservations(UpdateReservationModel reservationModel) {
        return reservationModel.getProductReservations().stream().map(model -> {
            int count = model.getCount();
            ProductEntity productEntity = productManager.findOneById(model.getProductId()).get();
            ProductReservationEntity productReservationEntity = new ProductReservationEntity(count, productEntity);
            return productReservationRepo.save(productReservationEntity);
        }).collect(Collectors.toCollection(HashSet::new));
    }

    private long getReservationsDayCount(LocalDate date, ShopEntity shopEntity) {
        return StreamSupport.stream(reservationRepo.findAll().spliterator(), false)
                .filter(res -> res.getShop().getId() == shopEntity.getId())
                .filter(res -> res.getDate() == date)
                .count();
    }

    private long getReservationsCountForQuarter(LocalDate date, int quarter, ShopEntity shopEntity) {
        return StreamSupport.stream(reservationRepo.findAll().spliterator(), false)
                .filter(res -> res.getShop().getId() == shopEntity.getId())
                .filter(res -> res.getDate() == date)
                .filter(res -> res.getQuarterOfDay() == quarter)
                .count();
    }
}
