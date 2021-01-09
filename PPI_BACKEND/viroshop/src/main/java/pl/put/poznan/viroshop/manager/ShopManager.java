package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.repositories.ShopRepo;

import javax.swing.text.html.Option;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Service
public class ShopManager {

    private final ShopRepo shopRepo;
    private final AlleyManager alleyManager;

    @Autowired
    public ShopManager(ShopRepo shopRepo, AlleyManager alleyManager) {
        this.shopRepo = shopRepo;
        this.alleyManager = alleyManager;
    }

    public Optional<ShopEntity> findOneById(Long id) {
        return shopRepo.findById(id);
    }

    public Iterable<ShopEntity> findAll() {
        return shopRepo.findAll();
    }

    public Iterable<ShopEntity> findAllFromCity(String cityName) {
        Iterable<ShopEntity> shops = shopRepo.findAll();
        return StreamSupport.stream(shops.spliterator(), false)
                .filter(shop -> shop.getCity().equals(cityName))
                .collect(Collectors.toList());
    }

    public ShopEntity save(ShopEntity shopEntity) {
        return shopRepo.save(shopEntity);
    }

    public void deleteById(Long id) {
        shopRepo.deleteById(id);
    }

    public Iterable<AlleyEntity> getAlleysWithSelectedProducts(Long shopId, List<Long> productIds) {
        Iterable<AlleyEntity> allAlleys = alleyManager.findAll();
        ArrayList<AlleyEntity> shopAlleys = new ArrayList<>();
        ArrayList<AlleyEntity> alleysWithSelectedProducts = new ArrayList<>();
        allAlleys.forEach(alley -> {
            if (alley.getShopEntity().getId() == shopId) {
                shopAlleys.add(alley);
            }
        });
        productIds.forEach(productId -> {
            shopAlleys.forEach(alley -> {
                Optional<ProductEntity> foundProduct = alley.getProducts().stream().filter(product -> product.getId() == productId).findFirst();
                if (!foundProduct.isEmpty()) {
                    alleysWithSelectedProducts.add(alley);
                }

            });
        });
        return alleysWithSelectedProducts;
    }
}
