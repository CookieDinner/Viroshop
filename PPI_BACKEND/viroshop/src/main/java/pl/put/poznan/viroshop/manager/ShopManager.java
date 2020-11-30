package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.repositories.ShopRepo;

import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class ShopManager {

    private final ShopRepo shopRepo;

    @Autowired
    public ShopManager(ShopRepo shopRepo) {
        this.shopRepo = shopRepo;
    }

    public Optional<ShopEntity> findOneById(Long id) {
        return shopRepo.findById(id);
    }

    public Iterable<ShopEntity> findAll() {
        return shopRepo.findAll();
    }

    public Iterable<ShopEntity> findAllFromCity(String cityName) {
        Iterable<ShopEntity> shops = shopRepo.findAll();
        return StreamSupport.stream(shops.spliterator(), false)
                .filter(shop -> shop.getCity().equals(cityName))
                .collect(Collectors.toList());
    }

    public ShopEntity save(ShopEntity shopEntity) {
        return shopRepo.save(shopEntity);
    }

    public void deleteById(Long id) {
        shopRepo.deleteById(id);
    }

    /**
     * Add to database specific records.
     * EventListener activate this method when application starts (parameter of the adnotation)
     */
    @EventListener(ApplicationReadyEvent.class)
    public void fillDataBase() {
        for (ShopEntity shop : DatabaseFill.shopEntities) {
            save(shop);
        }
    }
}
