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
            new ProductEntity(2L, "222333444101", "Jajka", Category.FOOD, "Jajka 10 sztuk", Unit.PACKAGE),
            new ProductEntity(3L, "222333444121", "Jajka", Category.FOOD, "Jajka 12 sztuk", Unit.PACKAGE),
            new ProductEntity(4L, "333444555666", "Szynka", Category.FOOD, "Szynka", Unit.PACKAGE),
            new ProductEntity(5L, "111222333555", "Tofu", Category.FOOD, "Tofu", Unit.PACKAGE),
            new ProductEntity(6L, "112233445566", "Jabłko", Category.FOOD, "Jabłko", Unit.KILOGRAMS),
            new ProductEntity(7L, "112233445567", "Gruszka", Category.FOOD, "Odmiana wschodnia", Unit.KILOGRAMS),
            new ProductEntity(8L, "112233445568", "Tofeefe", Category.FOOD, "Opakowanie 12 czekoladek", Unit.PACKAGE),
            new ProductEntity(9L, "112233445569", "Czekolada Magnetic", Category.FOOD, "", Unit.PACKAGE),
            new ProductEntity(10L, "112233445570", "Czekolada Milka", Category.FOOD, "", Unit.PACKAGE),
            new ProductEntity(11L, "112233445571", "Pomidory gałązka", Category.FOOD, "Pomidory gałązka luz", Unit.KILOGRAMS),
            new ProductEntity(12L, "112233445572", "Pomidory malinowe", Category.FOOD, "luzem", Unit.KILOGRAMS),
            new ProductEntity(13L, "112233445573", "Żelki Haribo", Category.FOOD, "Haribo w paczce 400g", Unit.PACKAGE),
            new ProductEntity(14L, "112233445574", "Żelki paski", Category.FOOD, "100g", Unit.KILOGRAMS),
            new ProductEntity(15L, "112233445575", "Jogurt naturalny MILKO", Category.FOOD, "", Unit.KILOGRAMS),
            new ProductEntity(16L, "112233445576", "Jogobella Truskawka", Category.FOOD, "Jogurt o smaku truskawek", Unit.PACKAGE),
            new ProductEntity(17L, "112233445577", "Jogobella Owoce Leśne", Category.FOOD, "Jogurt o smaku owoców leśnych", Unit.PACKAGE)
    };

    static ShopEntity[] shopEntities = new ShopEntity[]{
            //TODO Nazwy sklepów możemy zrobić jako Enum albo wogóle jako osobną encję, bo mamy niepotrzebną dupliakcje
            new ShopEntity(1L, "Poznań", "Dworcowa", 15, "Biedronka"),
            new ShopEntity(2L, "Gdańsk", "Warszawska", 1, "Auchan"),
            new ShopEntity(3L, "Gdańsk", "Mroźna", 41, "Lidl"),
            new ShopEntity(4L, "Poznań", "Roosvelta", 41, "Lidl"),
            new ShopEntity(5L, "Poznań", "Główna", 41, "Biedronka"),
            new ShopEntity(6L, "Września", "Poznańska", 41, "InterMarche"),

            new ShopEntity(7L, "Poznań", "Dworki", 41, "Kaufland"),
            new ShopEntity(8L, "Gdańsk", "Górki", 41, "Kaufland"),
            new ShopEntity(9L, "Gdańsk", "Uliczna", 41, "Lidl"),
            new ShopEntity(10L, "Poznań", "Gajowa", 41, "Lidl"),
            new ShopEntity(11L, "Poznań", "Ciasna", 41, "Żabka"),
            new ShopEntity(12L, "Września", "Litewska", 41, "Biedronka")
    };

    static StoreEntity[] storeEntities = new StoreEntity[]{
            // For Shop 1L:
            new StoreEntity(1L, true, 23.20f, shopEntities[0], productsEntities[1]),
            new StoreEntity(2L, true, 3.00f, shopEntities[0], productsEntities[2]),

            // For Shop 2L:
            new StoreEntity(3L, true, 15.99f, shopEntities[1], productsEntities[2]),
            new StoreEntity(4L, true, 2.50f, shopEntities[1], productsEntities[3]),
            new StoreEntity(5L, true, 5.00f, shopEntities[1], productsEntities[4]),

            // For Shop 3L:
            new StoreEntity(6L, true, 3.50f, shopEntities[2], productsEntities[0]),
            new StoreEntity(7L, true, 5.49f, shopEntities[2], productsEntities[5]),
            new StoreEntity(8L, false, 5.99f, shopEntities[2], productsEntities[6]),
            new StoreEntity(9L, true, 1.12f, shopEntities[2], productsEntities[16]),
            // For Shop 4L:
            new StoreEntity(10L, true, 3.29f, shopEntities[3], productsEntities[2]),
            new StoreEntity(11L, true, 4.99f, shopEntities[3], productsEntities[6]),
            new StoreEntity(12L, true, 3.99f, shopEntities[3], productsEntities[10]),
            new StoreEntity(13L, true, 8.88f, shopEntities[3], productsEntities[11]),
            new StoreEntity(14L, true, 5.50f, shopEntities[3], productsEntities[12]),
            new StoreEntity(15L, false, 0.99f, shopEntities[3], productsEntities[16]),

            new StoreEntity(21L, true, 7.29f, shopEntities[3], productsEntities[0]),
            new StoreEntity(22L, true, 22.99f, shopEntities[3], productsEntities[1]),
            new StoreEntity(23L, true, 15.99f, shopEntities[3], productsEntities[3]),
            new StoreEntity(24L, false, 13.88f, shopEntities[3], productsEntities[4]),
            new StoreEntity(25L, true, 8.50f, shopEntities[3], productsEntities[5]),
            new StoreEntity(27L, true, 12.29f, shopEntities[3], productsEntities[7]),
            new StoreEntity(28L, true, 17.99f, shopEntities[3], productsEntities[8]),
            new StoreEntity(29L, true, 23.99f, shopEntities[3], productsEntities[9]),
            new StoreEntity(30L, true, 2.88f, shopEntities[3], productsEntities[13]),
            new StoreEntity(31L, true, 0.50f, shopEntities[3], productsEntities[14]),
            new StoreEntity(32L, false, 3.99f, shopEntities[3], productsEntities[15]),
            // For Shop 5L:
            new StoreEntity(16L, true, 3.30f, shopEntities[4], productsEntities[3]),
            new StoreEntity(17L, true, 4.50f, shopEntities[4], productsEntities[13]),
            new StoreEntity(18L, true, 2.20f, shopEntities[4], productsEntities[14]),
            new StoreEntity(19L, true, 2.40f, shopEntities[4], productsEntities[15]),
            // For Shop 6L:
            new StoreEntity(20L, true, 1.99f, shopEntities[5], productsEntities[15]),
    };

    static UserEntity[] userEntities = new UserEntity[]{
            new UserEntity(1L, "lennon123", "lenon@lemon.pl", "ouiya11", LocalDate.of(1995, 1, 1)),
            new UserEntity(2L, "maQWE77", "jubikom@gmail.com", "Zazdro99", LocalDate.of(1990, 2, 22)),
            new UserEntity(3L, "qwerty", "linki@gmail.com", "12345", LocalDate.of(2005, 2, 24)),
            new UserEntity(4L, "test", "a@b.c", "123", LocalDate.of(2000, 1, 1))
    };


}
