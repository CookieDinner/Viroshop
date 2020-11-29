package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.repositories.ShopRepo;

import java.util.Optional;

@Service
public class ShopManager {

    private final ShopRepo shopRepo;

    @Autowired
    public ShopManager(ShopRepo shopRepo) {
        this.shopRepo = shopRepo;
    }

    public Optional<ShopEntity> findAllById(Long id) {
        return shopRepo.findById(id);
    }

    public Iterable<ShopEntity> findAll() {
        return shopRepo.findAll();
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
