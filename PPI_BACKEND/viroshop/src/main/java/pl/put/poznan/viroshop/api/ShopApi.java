package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.manager.ShopManager;

import java.util.Optional;

@RestController
public class ShopApi {

    private final ShopManager shopManager;

    @Autowired
    public ShopApi(ShopManager shopManager) {
        this.shopManager = shopManager;
    }

    @GetMapping("/api/shops")
    public Iterable<ShopEntity> getAll() {
        return shopManager.findAll();
    }

    @GetMapping("/api/shop")
    public Optional<ShopEntity> getOneShop(@RequestParam Long id) {
        return shopManager.findOneById(id);
    }

    @GetMapping("/api/shops/area")
    public Iterable<ShopEntity> getSurroundingShops(@RequestParam String city) {
        return shopManager.findAllFromCity(city);
    }

}
