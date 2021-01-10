package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.models.RoadPoint;
import pl.put.poznan.viroshop.manager.AlleyManager;
import pl.put.poznan.viroshop.manager.ShopManager;

import java.util.ArrayList;
import java.util.List;
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

    @GetMapping(value = "/api/shop/places", produces = "application/json; charset=UTF-8")
    public Iterable<AlleyEntity> getAlleysWithSelectedProducts(@RequestParam Long shopId, @RequestParam List<Long> productIds) {
        return shopManager.getAlleysWithSelectedProducts(shopId, productIds);
    }

    @GetMapping(value = "/api/shop/shortway", produces = "application/json; charset=UTF-8")
    public Iterable<RoadPoint> getShortestWay(@RequestParam Long shopId, @RequestParam List<Long> productIds) {
        return shopManager.getShortestWay(shopId, productIds);
    }

}
