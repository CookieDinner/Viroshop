package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.repositories.ProductRepo;

import java.util.Optional;

@Service
public class ProductManager {

    private final ProductRepo productRepo;

    @Autowired
    public ProductManager(ProductRepo productRepo) {
        this.productRepo = productRepo;
    }

    public Optional<ProductEntity> findAllById(Long id) {
        return productRepo.findById(id);
    }

    public Iterable<ProductEntity> findAll() {
        return productRepo.findAll();
    }

    public ProductEntity save(ProductEntity productEntity) {
        return productRepo.save(productEntity);
    }

    public void deleteById(Long id) {
        productRepo.deleteById(id);
    }

    /**
     * Add to database specific records.
     * EventListener activate this method when application starts (parameter of the adnotation)
     */
    @EventListener(ApplicationReadyEvent.class)
    public void fillDataBase() {
    }
}
