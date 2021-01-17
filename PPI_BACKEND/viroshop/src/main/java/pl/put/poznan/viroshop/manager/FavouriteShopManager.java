package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.FavouriteShopEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.dao.repositories.FavouriteShopRepo;

import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class FavouriteShopManager {

    private final FavouriteShopRepo favouriteShopRepo;
    private final ShopManager shopManager;
    private final UserManager userManager;

    @Autowired
    public FavouriteShopManager(FavouriteShopRepo favouriteShopRepo, ShopManager shopManager, UserManager userManager) {
        this.favouriteShopRepo = favouriteShopRepo;
        this.shopManager = shopManager;
        this.userManager = userManager;
    }

    public Iterable<ShopEntity> findFavouritesShops(Long userId) {
        return StreamSupport.stream(favouriteShopRepo.findAll().spliterator(), false)
                .filter(favourite -> favourite.getUserEntity().getId() == userId)
                .map(favourite -> favourite.getShopEntity())
                .collect(Collectors.toList());
    }

    public boolean addNewFavouriteShop(Long shopId, Long userId) {
        long count = StreamSupport.stream(favouriteShopRepo.findAll().spliterator(), false)
                .filter(favourite -> favourite.getUserEntity().getId() == userId)
                .filter(favourite -> favourite.getShopEntity().getId() == shopId)
                .count();
        if (count > 0) {
            return false;
        }

        ShopEntity shopEntity = shopManager.findOneById(shopId).get();
        UserEntity userEntity = userManager.findOneById(userId).get();
        FavouriteShopEntity result = favouriteShopRepo.save(new FavouriteShopEntity(shopEntity, userEntity));
        if (result != null) {
            return true;
        }
        return false;
    }

    public boolean deleteFavouriteShop(Long shopId, Long userId) {
        return false;
    }
}
