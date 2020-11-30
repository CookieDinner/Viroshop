package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.dao.models.BasicProductModel;
import pl.put.poznan.viroshop.manager.ProductManager;
import pl.put.poznan.viroshop.manager.StoreManager;

@RestController
public class ProductApi {

    private final ProductManager productManager;

    @Autowired
    public ProductApi(ProductManager productManager) {
        this.productManager = productManager;
    }

    @GetMapping("/api/data/stores")
    public Iterable<StoreEntity> getAllStores() {
        return productManager.findAllStores();
    }

    @GetMapping("/api/data/products/full")
    public Iterable<ProductEntity> getAllProducts() {
        return productManager.findAll();
    }

    @GetMapping("/api/data/products/basic")
    public Iterable<BasicProductModel> getAllBasicProducts(@RequestParam Long shopId) {
        return productManager.findAllBasicProducts(shopId);
    }
}
