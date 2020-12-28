package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.repositories.AlleyRepo;
import pl.put.poznan.viroshop.dao.repositories.ShopRepo;

import java.util.Optional;

@Service
public class AlleyManager {

    private final AlleyRepo alleyRepo;
    private final ShopRepo shopRepo;

    @Autowired
    public AlleyManager(AlleyRepo alleyRepo, ShopRepo shopRepo) {
        this.alleyRepo = alleyRepo;
        this.shopRepo = shopRepo;
    }

    public Iterable<AlleyEntity> findAll() {
        return alleyRepo.findAll();
    }

    public Optional<AlleyEntity> findOneById(long id) {
        return alleyRepo.findById(id);
    }

    public Iterable<AlleyEntity> findAllAlleysFromShop(long shopId) {
        return shopRepo.findById(shopId).get().getAlleys();
    }

    public AlleyEntity save(AlleyEntity alley) {
        return alleyRepo.save(alley);
    }

}
