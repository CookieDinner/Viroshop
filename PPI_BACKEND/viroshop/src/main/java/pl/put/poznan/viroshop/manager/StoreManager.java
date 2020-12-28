package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.dao.repositories.StoreRepo;

import java.util.Optional;

@Service
public class StoreManager {

    private final StoreRepo storeRepo;

    @Autowired
    public StoreManager(StoreRepo storeRepo) {
        this.storeRepo = storeRepo;
    }

    public Optional<StoreEntity> findAllById(Long id) {
        return storeRepo.findById(id);
    }

    public Iterable<StoreEntity> findAll() {
        return storeRepo.findAll();
    }

    public StoreEntity save(StoreEntity storeEntity) {
        return storeRepo.save(storeEntity);
    }

    public void deleteById(Long id) {
        storeRepo.deleteById(id);
    }

}
