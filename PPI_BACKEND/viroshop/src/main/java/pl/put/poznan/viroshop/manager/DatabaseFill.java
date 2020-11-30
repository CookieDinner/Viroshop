package pl.put.poznan.viroshop.manager;

import pl.put.poznan.viroshop.dao.Category;
import pl.put.poznan.viroshop.dao.Unit;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.entities.ShopEntity;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;
import pl.put.poznan.viroshop.dao.entities.UserEntity;

import java.time.LocalDate;

public class DatabaseFill {
    static ProductEntity[] productsEntities = new ProductEntity[]{
            new ProductEntity(1L, "111222333444", "Makaron", Category.FOOD, "Makaron", Unit.PACKAGE),
            new ProductEntity(2L, "222333444101", "Jajka", Category.FOOD,  "Jajka 10 sztuk", Unit.PACKAGE),
            new ProductEntity(3L, "222333444121", "Jajka", Category.FOOD,  "Jajka 12 sztuk", Unit.PACKAGE),
            new ProductEntity(4L, "333444555666", "Szynka", Category.FOOD,  "Szynka", Unit.PACKAGE),
            new ProductEntity(5L, "111222333555", "Tofu", Category.FOOD,  "Tofu", Unit.PACKAGE),
            new ProductEntity(6L, "112233445566", "Jabłko", Category.FOOD,  "Jabłko", Unit.KILOGRAMS)
    };

    static ShopEntity[] shopEntities = new ShopEntity[]{
            new ShopEntity(1L, "Poznan", "Dworcowa", 15, "Biedronka"),
            new ShopEntity(2L, "Gdansk", "Warszawska", 1, "Auchan")
    };

    static StoreEntity[] storeEntities = new StoreEntity[]{
            new StoreEntity(1L, true, 23.20f, shopEntities[0], productsEntities[1]),
            new StoreEntity(2L, true, 15.99f, shopEntities[1], productsEntities[2]),
            new StoreEntity(3L, true, 2.50f, shopEntities[1], productsEntities[3]),
            new StoreEntity(4L, true, 5.00f, shopEntities[1], productsEntities[4]),
            new StoreEntity(5L, true, 3.00f, shopEntities[0], productsEntities[2]),
    };

    static UserEntity[] userEntities = new UserEntity[]{
            new UserEntity(1L, "lennon123", "lenon@lemon.pl", "ouiya11", LocalDate.of(1995, 1, 1)),
            new UserEntity(2L, "maQWE77", "jubikom@gmail.com", "Zazdro99", LocalDate.of(1990, 2, 22))
    };


}
