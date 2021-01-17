package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.models.RoadPoint;
import pl.put.poznan.viroshop.manager.FavouriteShopManager;
import pl.put.poznan.viroshop.manager.ShopManager;

import java.util.List;
import java.util.Optional;

@CrossOrigin(origins = "http://localhost:4200")
@RestController
public class ShopApi {

    private final ShopManager shopManager;
    private final FavouriteShopManager favouriteShopManager;

    @Autowired
    public ShopApi(ShopManager shopManager, FavouriteShopManager favouriteShopManager) {
        this.shopManager = shopManager;
        this.favouriteShopManager = favouriteShopManager;
    }

    @GetMapping(value = "/api/shops", produces = "application/json; charset=UTF-8")
    public Iterable<ShopEntity> getAll() {
        return shopManager.findAll();
    }

    @GetMapping(value = "/api/shops/favourites", produces = "application/json; charset=UTF-8")
    public Iterable<ShopEntity> getFavourites(@RequestParam String login) {
        return favouriteShopManager.findFavouritesShops(login);
    }

    @PostMapping(value = "/api/shops/favourites", produces = "application/json; charset=UTF-8")
    public boolean addFavourite(@RequestParam Long shopId, @RequestParam String login) {
        return favouriteShopManager.addNewFavouriteShop(shopId, login);
    }

    @DeleteMapping(value = "/api/shops/favourites", produces = "application/json; charset=UTF-8")
    public boolean deleteFavourite(@RequestParam Long shopId, @RequestParam String login) {
        return favouriteShopManager.deleteFavouriteShop(shopId, login);
    }

    @GetMapping(value = "/api/shop", produces = "application/json; charset=UTF-8")
    public Optional<ShopEntity> getOneShop(@RequestParam Long id) {
        return shopManager.findOneById(id);
    }

    @GetMapping(value = "/api/shops/area", produces = "application/json; charset=UTF-8")
    public Iterable<ShopEntity> getSurroundingShops(@RequestParam String city) {
        return shopManager.findAllFromCity(city);
    }

    @GetMapping(value = "/api/shop/alleys", produces = "application/json; charset=UTF-8")
    public Iterable<AlleyEntity> getAllShopAlleys(@RequestParam Long shopId) {
        return shopManager.getAllShopAlleys(shopId);
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
