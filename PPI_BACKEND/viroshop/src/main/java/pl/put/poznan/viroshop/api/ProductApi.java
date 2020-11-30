package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.manager.ProductManager;
import pl.put.poznan.viroshop.manager.StoreManager;

@RestController
public class ProductApi {

    private final ProductManager productManager;
    private final StoreManager storeManager;

    @Autowired
    public ProductApi(ProductManager productManager, StoreManager storeManager) {
        this.productManager = productManager;
        this.storeManager = storeManager;
    }

    @GetMapping("/api/stores")
    public Iterable<StoreEntity> getAllStores() {
        return storeManager.findAll();
    }

    @GetMapping("/api/products")
    public Iterable<ProductEntity> getAllProducts() {
        return productManager.findAll();
    }
}
