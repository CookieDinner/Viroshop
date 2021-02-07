package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.FavouriteShopEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.dao.repositories.FavouriteShopRepo;

import java.util.List;
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

    public Iterable<ShopEntity> findFavouritesShops(String login) {
        return StreamSupport.stream(favouriteShopRepo.findAll().spliterator(), false)
                .filter(favourite -> favourite.getUserEntity().getLogin().equals(login))
                .map(favourite -> favourite.getShopEntity())
                .collect(Collectors.toList());
    }

    public boolean addNewFavouriteShop(Long shopId, String login) {
        long count = StreamSupport.stream(favouriteShopRepo.findAll().spliterator(), false)
                .filter(favourite -> favourite.getUserEntity().getLogin().equals(login))
                .filter(favourite -> favourite.getShopEntity().getId() == shopId)
                .count();
        if (count > 0) {
            return false;
        }

        ShopEntity shopEntity = shopManager.findOneById(shopId).get();
        UserEntity userEntity = userManager.findByLogin(login).get(0);
        FavouriteShopEntity result = favouriteShopRepo.save(new FavouriteShopEntity(shopEntity, userEntity));
        if (result != null) {
            return true;
        }
        return false;
    }

    public boolean deleteFavouriteShop(Long shopId, String login) {
        List<FavouriteShopEntity> found = StreamSupport.stream(favouriteShopRepo.findAll().spliterator(), false)
                .filter(favourite -> favourite.getUserEntity().getLogin().equals(login))
                .filter(favourite -> favourite.getShopEntity().getId() == shopId)
                .collect(Collectors.toList());
        if (found == null || found.isEmpty() || found.get(0) == null) {
            return false;
        }
        favouriteShopRepo.delete(found.get(0));
        return true;
    }
}
