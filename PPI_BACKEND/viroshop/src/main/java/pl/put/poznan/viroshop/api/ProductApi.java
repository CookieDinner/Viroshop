package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.dao.models.BasicProductModel;
import pl.put.poznan.viroshop.manager.ProductManager;

import java.util.Optional;

@RestController
public class ProductApi {

    private final ProductManager productManager;

    @Autowired
    public ProductApi(ProductManager productManager) {
        this.productManager = productManager;
    }

    @GetMapping(value = "/api/data/stores", produces = "application/json; charset=UTF-8")
    public Iterable<StoreEntity> getAllStores() {
        return productManager.findAllStores();
    }

    @GetMapping(value = "/api/data/products/full", produces = "application/json; charset=UTF-8")
    public Iterable<ProductEntity> getAllProducts() {
        return productManager.findAll();
    }

    @GetMapping(value = "/api/data/products/basic", produces = "application/json; charset=UTF-8")
    public Iterable<BasicProductModel> getAllBasicProducts(@RequestParam Long shopId) {
        return productManager.findAllBasicProducts(shopId);
    }

    @GetMapping(value = "/api/data/product", produces = "application/json; charset=UTF-8")
    public Optional<ProductEntity> getOneProduct(@RequestParam Long id) {
        return productManager.findOneById(id);
    }
}
