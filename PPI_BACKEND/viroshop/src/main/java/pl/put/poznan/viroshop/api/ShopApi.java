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

    @GetMapping(value = "/api/shops", produces = "application/json; charset=UTF-8")
    public Iterable<ShopEntity> getAll() {
        return shopManager.findAll();
    }

    @GetMapping(value = "/api/shop", produces = "application/json; charset=UTF-8")
    public Optional<ShopEntity> getOneShop(@RequestParam Long id) {
        return shopManager.findOneById(id);
    }

    @GetMapping(value = "/api/shops/area", produces = "application/json; charset=UTF-8")
    public Iterable<ShopEntity> getSurroundingShops(@RequestParam String city) {
        return shopManager.findAllFromCity(city);
    }

}
