package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.manager.ShopManager;

@RestController
public class ShopApi {

    private final ShopManager shopManager;

    @Autowired
    public ShopApi(ShopManager shopManager) {
        this.shopManager = shopManager;
    }

    @GetMapping("/api/shop")
    public Iterable<ShopEntity> getAll() {
        return shopManager.findAll();
    }

}
