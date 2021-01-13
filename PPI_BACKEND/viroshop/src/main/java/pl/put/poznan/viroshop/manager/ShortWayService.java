package pl.put.poznan.viroshop.manager;

import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.enums.AlleyType;
import pl.put.poznan.viroshop.dao.enums.AlleysPositioning;
import pl.put.poznan.viroshop.dao.models.RoadPoint;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ShortWayService {

    private ArrayList<AlleyEntity> getAlleysTheClosestToAnother(ArrayList<AlleyEntity> destination, AlleyType destinationType, ArrayList<AlleyEntity> shopAlleys) {
        return shopAlleys.stream().filter(alley -> {
            boolean canBeAFirstAlley = false;
            if (alley.getType() != AlleyType.ALLEY) {
                return false;
            }
            for (AlleyEntity destinationElement : destination) {
                if (destinationElement.getType() != destinationType) {
                    break;
                }
                int x = destinationElement.getXposition();
                int y = destinationElement.getYposition();
                int alleyX = alley.getXposition();
                int alleyY = alley.getYposition();
                boolean isHorizontalNeighbour = (alleyX == x + 1 || alleyX == x - 1);
                boolean isVerticalNeighbour = (alleyY == y + 1 || alleyY == y - 1);
                boolean hasTheSameX = alleyX == x;
                boolean hasTheSameY = alleyY == y;
                if ((isHorizontalNeighbour && hasTheSameY) || (isVerticalNeighbour && hasTheSameX)) {
                    canBeAFirstAlley = true;
                }
            }
            return canBeAFirstAlley;
        }).collect(Collectors.toCollection(ArrayList::new));
    }

    private ArrayList<AlleyEntity> getAlleysTheClosestToDoors(ArrayList<AlleyEntity> shopAlleys) {
        ArrayList<AlleyEntity> doors = shopAlleys.stream().filter(alley -> alley.getType() == AlleyType.DOOR).collect(Collectors.toCollection(ArrayList::new));
        return getAlleysTheClosestToAnother(doors, AlleyType.DOOR, shopAlleys);
    }

    private ArrayList<AlleyEntity> getAlleysTheClosestToCashes(ArrayList<AlleyEntity> shopAlleys) {
        ArrayList<AlleyEntity> cashes = shopAlleys.stream().filter(alley -> alley.getType() == AlleyType.CASH).collect(Collectors.toCollection(ArrayList::new));
        return getAlleysTheClosestToAnother(cashes, AlleyType.CASH, shopAlleys);
    }

    private Map<AlleyEntity, Boolean> getAlleysWithSelectedProducts(ArrayList<AlleyEntity> shopAlleys, List<Long> productIds) {
        Map<AlleyEntity, Boolean> alleysMap = new HashMap<>();
        ArrayList<AlleyEntity> alleysWithSelectedProducts = new ArrayList<>();
        productIds.forEach(productId -> {
            shopAlleys.forEach(alley -> {
                Optional<ProductEntity> foundProduct = alley.getProducts().stream().filter(product -> product.getId() == productId).findFirst();
                if (!foundProduct.isEmpty()) {
                    alleysWithSelectedProducts.add(alley);
                }
            });
        });
        alleysWithSelectedProducts.forEach(alley -> {
            alleysMap.put(alley, false);
        });
        return alleysMap;
    }

    private void displayOnConsole(ArrayList<AlleyEntity> firstAlleys, ArrayList<AlleyEntity> endAlleys) {
        for (AlleyEntity alley : firstAlleys) {
            System.out.println("FIRST: " + alley.getId() + " " + alley.getXposition() + " " + alley.getYposition());
        }
        for (AlleyEntity alley : endAlleys) {
            System.out.println("END: " + alley.getId() + " " + alley.getXposition() + " " + alley.getYposition());
        }
    }

    private AlleyEntity findFirstAlley(ArrayList<AlleyEntity> firstAlleys) {
        return firstAlleys.stream().findFirst().get();
    }

    private AlleyEntity getAlleyWithXY(ArrayList<AlleyEntity> alleys, int x, int y) {
        return alleys.stream().filter(alley -> alley.getYposition() == y && alley.getXposition() == x).findFirst().get();
    }

    enum Side {
        LEFT,
        RIGHT
    }

    private ArrayList<AlleyEntity> findRoadBeetweenProductsAlley(AlleyEntity previousAlley, ArrayList<AlleyEntity> alleysWithProducts, ArrayList<AlleyEntity> shopAlleys) {
        ArrayList<AlleyEntity> restOfAlleysWithProducts = new ArrayList<>(alleysWithProducts);
        // For Horizontal Shop 1
        int currentY = previousAlley.getYposition();
        int currentX = previousAlley.getXposition();
        Side side = Side.LEFT;
        ArrayList<AlleyEntity> road = new ArrayList<>();
        boolean canContinue = true;
        int iter = 0;
        while (canContinue) {
            System.out.println(iter++);
            if (restOfAlleysWithProducts.size() == 0) {
                canContinue = false;
                break;
            }
            int finalCurrentY = currentY;
            ArrayList<AlleyEntity> currentRow = restOfAlleysWithProducts.stream().filter(alley -> alley.getYposition() == finalCurrentY).collect(Collectors.toCollection(ArrayList::new));
            ArrayList<AlleyEntity> rowAbove = restOfAlleysWithProducts.stream().filter(alley -> alley.getYposition() + 1 == finalCurrentY).collect(Collectors.toCollection(ArrayList::new));

            // Nie ma nic w obecnej alejce i po bokach między obecną a kolejną
            if (currentRow.size() == 0 && rowAbove.size() == 0) {
                road.add(getAlleyWithXY(shopAlleys, currentX, currentY--));
                AlleyEntity above = getAlleyWithXY(shopAlleys, currentX, currentY);
                if (restOfAlleysWithProducts.contains(above)) {
                    restOfAlleysWithProducts.remove(above);
                }
                road.add(getAlleyWithXY(shopAlleys, currentX, currentY--));
                if (currentY <= 0 || restOfAlleysWithProducts.size() == 0) {
                    canContinue = false;
                }
                continue;
            }

            // Bierze najbliższy z góry i wraca zostawiajac tego po 2 stronie sklepu
            if (rowAbove.size() == 2) {
                int x1 = rowAbove.get(0).getXposition();
                int x2 = rowAbove.get(1).getXposition();
                if (currentX == x1) {
                    AlleyEntity alleyWithProduct = getAlleyWithXY(shopAlleys, x1, currentY-1);
                    road.add(alleyWithProduct);
                    road.add(getAlleyWithXY(shopAlleys, currentX, currentY));
                    restOfAlleysWithProducts.remove(alleyWithProduct);
                    rowAbove.remove(0);
                }
                if (currentX == x2) {
                    AlleyEntity alleyWithProduct = getAlleyWithXY(shopAlleys, x2, currentY-1);
                    road.add(alleyWithProduct);
                    road.add(getAlleyWithXY(shopAlleys, currentX, currentY));
                    restOfAlleysWithProducts.remove(alleyWithProduct);
                    rowAbove.remove(1);
                }
            }
            // Sprawdza czy alejka z rzędu powyzej ma być odwiedzona
            if (rowAbove.size() == 1) {
                int x1 = rowAbove.get(0).getXposition();
                if (currentX == x1) {
                    AlleyEntity alleyWithProduct = getAlleyWithXY(shopAlleys, x1, currentY - 1);
                    road.add(alleyWithProduct);
                    restOfAlleysWithProducts.remove(alleyWithProduct);
                    rowAbove.remove(0);
                }
                if (currentRow.size() == 0 && rowAbove.size() == 0) { //Pomiń obecny rząd bo juz nic nie zostało
                    road.add(getAlleyWithXY(shopAlleys, currentX, currentY - 2));
                    currentY -= 2;
                    if (currentY <= 0) {
                        canContinue = false;
                    }
                    continue;
                } else if (currentRow.size() != 0) { //wróć do obecnego rzędu
                    road.add(getAlleyWithXY(shopAlleys, currentX, currentY));
                }
            }


            // Zbierz wszystko z głównej alejki
            boolean hasFoundNextAlley = true;
            while (hasFoundNextAlley) {
                int nextX = -1;
                if (side == Side.LEFT) {
                    nextX = currentX + 1;
                }
                if (side == Side.RIGHT) {
                    nextX = currentX - 1;
                }
                AlleyEntity nextAlley = getAlleyWithXY(shopAlleys, nextX, currentY);
                if (nextAlley.getType() != AlleyType.ALLEY) {
                    hasFoundNextAlley = false;
                    continue;
                }
                if (currentRow.contains(nextAlley)) {
                    restOfAlleysWithProducts.remove(nextAlley);
                    currentRow.remove(nextAlley);
                }
                road.add(nextAlley);
                currentX++;
            }
            if (side == Side.LEFT) {
                side = Side.RIGHT;
            } else if (side == Side.RIGHT) {
                side = Side.LEFT;
            }


            if (currentRow.size() == 0 && rowAbove.size() == 0) { //Pomiń obecny rząd bo juz nic nie zostało
                currentY -= 2;
                if (currentY <= 0) {
                    canContinue = false;
                }
                continue;
            }
            if (rowAbove.size() == 1) {
                int x1 = rowAbove.get(0).getXposition();
                if (currentX == x1) {
                    AlleyEntity alleyWithProduct = getAlleyWithXY(shopAlleys, x1, currentY);
                    road.add(alleyWithProduct);
                    restOfAlleysWithProducts.remove(alleyWithProduct);
                    rowAbove.remove(0);
                }
            }
        }
        return road;
    }

    public ArrayList<RoadPoint> getShortestWay(ArrayList<AlleyEntity> shopAlleys, List<Long> productIds, AlleysPositioning alleysPositioning) {
        Map<AlleyEntity, Boolean> alleysWithSelectedProducts = getAlleysWithSelectedProducts(shopAlleys, productIds);
        ArrayList<AlleyEntity> firstAlleys = getAlleysTheClosestToDoors(shopAlleys);
        ArrayList<AlleyEntity> endAlleys = getAlleysTheClosestToCashes(shopAlleys);
        ArrayList<RoadPoint> resultRoad = new ArrayList<>();
        ArrayList<AlleyEntity> alleysWithProducts = new ArrayList<>(alleysWithSelectedProducts.keySet());
        int orderNumber = 0;
        AlleyEntity previousAlley = findFirstAlley(firstAlleys);
        resultRoad.add(new RoadPoint(orderNumber++, previousAlley.getId(), previousAlley.getXposition(), previousAlley.getYposition()));

        ArrayList<AlleyEntity> road = findRoadBeetweenProductsAlley(previousAlley, alleysWithProducts, shopAlleys);
        for (AlleyEntity alley : road) {
            resultRoad.add(new RoadPoint(orderNumber++, alley.getId(), alley.getXposition(), alley.getYposition()));
        }

        displayOnConsole(firstAlleys, endAlleys);

        return resultRoad;
    }

}
