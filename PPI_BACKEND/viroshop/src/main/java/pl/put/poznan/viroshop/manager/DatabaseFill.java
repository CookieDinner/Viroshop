package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.*;
import pl.put.poznan.viroshop.dao.enums.AlleyType;
import pl.put.poznan.viroshop.dao.enums.AlleysPositioning;
import pl.put.poznan.viroshop.dao.enums.Category;
import pl.put.poznan.viroshop.dao.enums.Unit;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.HashSet;

@Service
public class DatabaseFill {

    private UserManager userManager;
    private ShopManager shopManager;
    private ProductManager productManager;
    private StoreManager storeManager;
    private AlleyManager alleyManager;

    @Autowired
    public DatabaseFill(UserManager userManager, ShopManager shopManager, ProductManager productManager, StoreManager storeManager, AlleyManager alleyManager) {
        this.userManager = userManager;
        this.shopManager = shopManager;
        this.productManager = productManager;
        this.storeManager = storeManager;
        this.alleyManager = alleyManager;
    }

    private ProductEntity[] productsEntities = new ProductEntity[]{
            new ProductEntity(1L, "111222333444", "Makaron", Category.FOOD, "Makaron", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/807/680/019/5057/front_it.108.200.jpg"),
            new ProductEntity(2L, "222333444101", "Jajka", Category.FOOD, "Jajka 10 sztuk", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/325/132/008/1249/front_fr.53.200.jpg"),
            new ProductEntity(3L, "222333444121", "Jajka", Category.FOOD, "Jajka 12 sztuk", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/325/132/002/1030/front_fr.61.200.jpg"),
            new ProductEntity(4L, "333444555666", "Szynka", Category.FOOD, "Szynka", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/20834142/front_en.3.200.jpg"),
            new ProductEntity(5L, "111222333555", "Tofu", Category.FOOD, "Tofu", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/841/078/914/0118/front_es.28.200.jpg"),
            new ProductEntity(6L, "112233445566", "Jabłko", Category.FOOD, "Jabłko", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/20817138/front_de.7.200.jpg"),
            new ProductEntity(7L, "112233445567", "Gruszka", Category.FOOD, "Odmiana wschodnia", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/20241926/front_de.5.200.jpg"),
            new ProductEntity(8L, "112233445568", "Tofeefe", Category.FOOD, "Opakowanie 12 czekoladek", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/401/440/040/0007/front_en.135.200.jpg"),
            new ProductEntity(9L, "112233445569", "Czekolada Magnetic", Category.FOOD, "", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/590/744/360/0994/front_pl.4.200.jpg"),
            new ProductEntity(10L, "112233445570", "Czekolada Milka", Category.FOOD, "", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/304/514/010/5502/front_en.162.200.jpg"),
            new ProductEntity(11L, "112233445571", "Pomidory gałązka", Category.FOOD, "Pomidory gałązka luz", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/327/655/709/2820/front_fr.4.200.jpg"),
            new ProductEntity(12L, "112233445572", "Pomidory malinowe", Category.FOOD, "luzem", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/359/094/100/1275/front_fr.11.200.jpg"),
            new ProductEntity(13L, "112233445573", "Żelki Haribo", Category.FOOD, "Haribo w paczce 400g", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/310/322/000/7822/front_en.108.200.jpg"),
            new ProductEntity(14L, "112233445574", "Żelki fasolki", Category.FOOD, "100g", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/20714710/front_cs.18.200.jpg"),
            new ProductEntity(15L, "112233445575", "Jogurt naturalny MILKO", Category.FOOD, "", Unit.KILOGRAMS, "https://static.openfoodfacts.org/images/products/885/019/958/5275/front_en.4.200.jpg"),
            new ProductEntity(16L, "112233445576", "Jogobella Truskawka", Category.FOOD, "Jogurt o smaku truskawek", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/401/450/051/2907/front_en.4.200.jpg"),
            new ProductEntity(17L, "112233445577", "Jogobella Owoce Leśne", Category.FOOD, "Jogurt o smaku owoców leśnych", Unit.PACKAGE, "https://static.openfoodfacts.org/images/products/401/450/051/0927/front_fr.4.200.jpg")
    };

    private ShopEntity[] shopEntities = new ShopEntity[]{
            //TODO Nazwy sklepów możemy zrobić jako Enum albo wogóle jako osobną encję, bo mamy niepotrzebną dupliakcje
            new ShopEntity(1L, "Poznań", "Dworcowa", 15, "Biedronka", AlleysPositioning.HORIZONTAL),
            new ShopEntity(2L, "Gdańsk", "Warszawska", 1, "Auchan", AlleysPositioning.HORIZONTAL),
            new ShopEntity(3L, "Gdańsk", "Mroźna", 41, "Lidl", AlleysPositioning.VERTICAL),
            new ShopEntity(4L, "Poznań", "Roosvelta", 41, "Lidl", AlleysPositioning.HORIZONTAL),
            new ShopEntity(5L, "Poznań", "Główna", 41, "Biedronka", AlleysPositioning.VERTICAL),
            new ShopEntity(6L, "Września", "Poznańska", 41, "InterMarche", AlleysPositioning.HORIZONTAL),

            new ShopEntity(7L, "Poznań", "Dworki", 41, "Kaufland", AlleysPositioning.HORIZONTAL),
            new ShopEntity(8L, "Gdańsk", "Górki", 41, "Kaufland", AlleysPositioning.HORIZONTAL),
            new ShopEntity(9L, "Gdańsk", "Uliczna", 41, "Lidl", AlleysPositioning.HORIZONTAL),
            new ShopEntity(10L, "Poznań", "Gajowa", 41, "Lidl", AlleysPositioning.HORIZONTAL),
            new ShopEntity(11L, "Poznań", "Ciasna", 41, "Żabka", AlleysPositioning.HORIZONTAL),
            new ShopEntity(12L, "Września", "Litewska", 41, "Biedronka", AlleysPositioning.HORIZONTAL)
    };

    private StoreEntity[] storeEntities = new StoreEntity[]{
            // For Shop 1L:
            new StoreEntity(1L, true, 3.99f, shopEntities[0], productsEntities[0]),
            new StoreEntity(2L, true, 23.20f, shopEntities[0], productsEntities[1]),
            new StoreEntity(3L, true, 3.00f, shopEntities[0], productsEntities[2]),
            new StoreEntity(4L, true, 2.19f, shopEntities[0], productsEntities[3]),
            new StoreEntity(5L, true, 6.20f, shopEntities[0], productsEntities[4]),
            new StoreEntity(6L, true, 4.99f, shopEntities[0], productsEntities[5]),
            new StoreEntity(7L, true, 4.89f, shopEntities[0], productsEntities[6]),
            new StoreEntity(8L, true, 2.49f, shopEntities[0], productsEntities[7]),
            new StoreEntity(9L, true, 3.49f, shopEntities[0], productsEntities[8]),
            new StoreEntity(10L, true, 9.99f, shopEntities[0], productsEntities[9]),
            new StoreEntity(11L, true, 3.75f, shopEntities[0], productsEntities[10]),
            new StoreEntity(12L, true, 10.49f, shopEntities[0], productsEntities[11]),
            new StoreEntity(13L, false, 5.99f, shopEntities[0], productsEntities[12]),
            new StoreEntity(14L, true, 4.99f, shopEntities[0], productsEntities[13]),
            new StoreEntity(15L, true, 3.39f, shopEntities[0], productsEntities[14]),
            new StoreEntity(16L, true, 2.19f, shopEntities[0], productsEntities[15]),
            new StoreEntity(17L, true, 0.79f, shopEntities[0], productsEntities[16]),

            // For Shop 2L:
            new StoreEntity(18L, true, 15.99f, shopEntities[1], productsEntities[2]),
            new StoreEntity(19L, true, 2.50f, shopEntities[1], productsEntities[3]),
            new StoreEntity(20L, true, 5.00f, shopEntities[1], productsEntities[4]),

            // For Shop 3L:
            new StoreEntity(21L, true, 3.50f, shopEntities[2], productsEntities[0]),
            new StoreEntity(22L, true, 5.49f, shopEntities[2], productsEntities[5]),
            new StoreEntity(23L, false, 5.99f, shopEntities[2], productsEntities[6]),
            new StoreEntity(24L, true, 1.12f, shopEntities[2], productsEntities[16]),
            // For Shop 4L:
            new StoreEntity(25L, true, 3.29f, shopEntities[3], productsEntities[2]),
            new StoreEntity(26L, true, 4.99f, shopEntities[3], productsEntities[6]),
            new StoreEntity(27L, true, 3.99f, shopEntities[3], productsEntities[10]),
            new StoreEntity(28L, true, 8.88f, shopEntities[3], productsEntities[11]),
            new StoreEntity(29L, true, 5.50f, shopEntities[3], productsEntities[12]),
            new StoreEntity(30L, false, 0.99f, shopEntities[3], productsEntities[16]),
            // For Shop 5L:
            new StoreEntity(31L, true, 3.30f, shopEntities[4], productsEntities[3]),
            new StoreEntity(32L, true, 4.50f, shopEntities[4], productsEntities[13]),
            new StoreEntity(33L, true, 2.20f, shopEntities[4], productsEntities[14]),
            new StoreEntity(34L, true, 2.40f, shopEntities[4], productsEntities[15]),
            // For Shop 6L:
            new StoreEntity(35L, true, 1.99f, shopEntities[5], productsEntities[15]),
    };

    private AlleyEntity[] alleyEntities = new AlleyEntity[]{
            new AlleyEntity(1L, 1, 1, AlleyType.UNUSED, new HashSet(), shopEntities[0]),
            new AlleyEntity(2L, 2, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(3L, 3, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(4L, 4, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(5L, 5, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(6L, 6, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(7L, 7, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(8L, 8, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(9L, 9, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(10L, 10, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(11L, 11, 1, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(12L, 12, 1, AlleyType.UNUSED, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////
            new AlleyEntity(13L, 1, 2, AlleyType.UNUSED, new HashSet(), shopEntities[0]),
            new AlleyEntity(14L, 2, 2, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(15L, 3, 2, AlleyType.ALLEY, new HashSet<>(Arrays.asList(productsEntities[1])), shopEntities[0]),
            new AlleyEntity(16L, 4, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(17L, 5, 2, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[6])), shopEntities[0]),
            new AlleyEntity(18L, 6, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(19L, 7, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(20L, 8, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(21L, 9, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(22L, 10, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(23L, 11, 2, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(24L, 12, 2, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////
            new AlleyEntity(25L, 1, 3, AlleyType.UNUSED, new HashSet(), shopEntities[0]),
            new AlleyEntity(26L, 2, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(27L, 3, 3, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[5])), shopEntities[0]),
            new AlleyEntity(28L, 4, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(29L, 5, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(30L, 6, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(31L, 7, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(32L, 8, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(33L, 9, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(34L, 10, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(35L, 11, 3, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[5])), shopEntities[0]),
            new AlleyEntity(36L, 12, 3, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////
            new AlleyEntity(37L, 1, 4, AlleyType.UNUSED, new HashSet(), shopEntities[0]),
            new AlleyEntity(38L, 2, 4, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(39L, 3, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(40L, 4, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(41L, 5, 4, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[0])), shopEntities[0]),
            new AlleyEntity(42L, 6, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(43L, 7, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(44L, 8, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(45L, 9, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(46L, 10, 4, AlleyType.ALLEY, new HashSet<>(Arrays.asList(productsEntities[2])), shopEntities[0]),
            new AlleyEntity(47L, 11, 4, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(48L, 12, 4, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(49L, 1, 5, AlleyType.UNUSED, null, shopEntities[0]),
            new AlleyEntity(50L, 2, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(51L, 3, 5, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(52L, 4, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(53L, 5, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(54L, 6, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(55L, 7, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(56L, 8, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(57L, 9, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(58L, 10, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(59L, 11, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(60L, 12, 5, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(61L, 1, 6, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(62L, 2, 6, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(63L, 3, 6, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[7])), shopEntities[0]),
            new AlleyEntity(64L, 4, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(65L, 5, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(66L, 6, 6, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[4])), shopEntities[0]),
            new AlleyEntity(67L, 7, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(68L, 8, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(69L, 9, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(70L, 10, 6, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[3])), shopEntities[0]),
            new AlleyEntity(71L, 11, 6, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(72L, 12, 6, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(73L, 1, 7, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(74L, 2, 7, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(75L, 3, 7, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[15], productsEntities[16])), shopEntities[0]),
            new AlleyEntity(76L, 4, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(77L, 5, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(78L, 6, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(79L, 7, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(80L, 8, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(81L, 9, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(82L, 10, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(83L, 11, 7, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[8])), shopEntities[0]),
            new AlleyEntity(84L, 12, 7, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(85L, 1, 8, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(86L, 2, 8, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(87L, 3, 8, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(88L, 4, 8, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[14])), shopEntities[0]),
            new AlleyEntity(89L, 5, 8, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[14])), shopEntities[0]),
            new AlleyEntity(90L, 6, 8, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(91L, 7, 8, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(92L, 8, 8, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(93L, 9, 8, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(94L, 10, 8, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[9])), shopEntities[0]),
            new AlleyEntity(95L, 11, 8, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[10])), shopEntities[0]),
            new AlleyEntity(96L, 12, 8, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(97L, 1, 9, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(98L, 2, 9, AlleyType.CASH, new HashSet(), shopEntities[0]),
            new AlleyEntity(99L, 3, 9, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[13])), shopEntities[0]),
            new AlleyEntity(100L, 4, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(101L, 5, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(102L, 6, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(103L, 7, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(104L, 8, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(105L, 9, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(106L, 10, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(107L, 11, 9, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[11])), shopEntities[0]),
            new AlleyEntity(108L, 12, 9, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(109L, 1, 10, AlleyType.DOOR, new HashSet(), shopEntities[0]),
            new AlleyEntity(110L, 2, 10, AlleyType.DOOR, new HashSet(), shopEntities[0]),
            new AlleyEntity(111L, 3, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(112L, 4, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(113L, 5, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(114L, 6, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(115L, 7, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(116L, 8, 10, AlleyType.ALLEY, new HashSet(Arrays.asList(productsEntities[12])), shopEntities[0]),
            new AlleyEntity(117L, 9, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(118L, 10, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(119L, 11, 10, AlleyType.ALLEY, new HashSet(), shopEntities[0]),
            new AlleyEntity(120L, 12, 10, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            //////////////////////////////////////////////////////////////////////////////////,
            new AlleyEntity(121L, 1, 11, AlleyType.DOOR, new HashSet(), shopEntities[0]),
            new AlleyEntity(122L, 2, 11, AlleyType.DOOR, new HashSet(), shopEntities[0]),
            new AlleyEntity(123L, 3, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(124L, 4, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(125L, 5, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(126L, 6, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(127L, 7, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(128L, 8, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(129L, 9, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(130L, 10, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(131L, 11, 11, AlleyType.SHELF, new HashSet(), shopEntities[0]),
            new AlleyEntity(132L, 12, 11, AlleyType.UNUSED, new HashSet(), shopEntities[0]),

    };

    private UserEntity[] userEntities = new UserEntity[]{
            new UserEntity(1L, "lennon123", "lenon@lemon.pl", "ouiya11", LocalDate.of(1995, 1, 1)),
            new UserEntity(2L, "maQWE77", "jubikom@gmail.com", "Zazdro99", LocalDate.of(1990, 2, 22)),
            new UserEntity(3L, "qwerty", "linki@gmail.com", "12345", LocalDate.of(2005, 2, 24)),
            new UserEntity(4L, "test", "a@b.c", "123", LocalDate.of(2000, 1, 1))
    };

    /**
     * Add to database specific records.
     * EventListener activate this method when application starts (parameter of the adnotation)
     */
    @EventListener(ApplicationReadyEvent.class)
    public void fillDataBase() {
        for (UserEntity user : this.userEntities) {
            userManager.save(user);
        }
        for (ProductEntity product : this.productsEntities) {
            productManager.save(product);
        }
        for (ShopEntity shop : this.shopEntities) {
            shopManager.save(shop);
        }
        for (StoreEntity store : this.storeEntities) {
            storeManager.save(store);
        }
        for (AlleyEntity alley : this.alleyEntities) {
            alleyManager.save(alley);
        }
    }


}
