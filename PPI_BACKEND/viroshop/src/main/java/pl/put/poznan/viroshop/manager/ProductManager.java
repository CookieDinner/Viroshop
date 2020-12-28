package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.dao.models.BasicProductModel;
import pl.put.poznan.viroshop.dao.repositories.ProductRepo;
import pl.put.poznan.viroshop.dao.repositories.StoreRepo;

import java.util.ArrayList;
import java.util.Optional;
import java.util.stream.StreamSupport;

@Service
public class ProductManager {

    private final ProductRepo productRepo;
    private final StoreRepo storeRepo;

    @Autowired
    public ProductManager(ProductRepo productRepo, StoreRepo storeRepo) {
        this.productRepo = productRepo;
        this.storeRepo = storeRepo;
    }

    public Optional<ProductEntity> findAllById(Long id) {
        return productRepo.findById(id);
    }

    public Iterable<ProductEntity> findAll() {
        return productRepo.findAll();
    }

    public Iterable<StoreEntity> findAllStores() {
        return storeRepo.findAll();
    }

    public Iterable<BasicProductModel> findAllBasicProducts(Long shopId) {
        Iterable<ProductEntity> products = productRepo.findAll();
        Iterable<StoreEntity> stores = storeRepo.findAll();
        ArrayList<BasicProductModel> basicProducts = new ArrayList<>();
        StreamSupport.stream(products.spliterator(), false)
                .forEach(product -> {
                    StreamSupport.stream(stores.spliterator(), false)
                            .filter(store -> store.getShopEntity().getId() == shopId)
                            .filter(store -> store.getProductEntity().getId() == product.getId())
                            .map(store -> new BasicProductModel(product.getId(), product.getName(), store.isAvailable(), product.getCategory()))
                            .forEach(basicProduct -> basicProducts.add(basicProduct));
                });
        return basicProducts;
    }

    public Optional<ProductEntity> findOneById(Long id) {
        return productRepo.findById(id);
    }

    public ProductEntity save(ProductEntity productEntity) {
        return productRepo.save(productEntity);
    }

    public void deleteById(Long id) {
        productRepo.deleteById(id);
    }

}
