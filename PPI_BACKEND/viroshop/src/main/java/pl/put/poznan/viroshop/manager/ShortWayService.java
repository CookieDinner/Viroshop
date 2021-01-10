package pl.put.poznan.viroshop.manager;

import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.AlleyEntity;
import pl.put.poznan.viroshop.dao.entities.ProductEntity;
import pl.put.poznan.viroshop.dao.enums.AlleyType;
import pl.put.poznan.viroshop.dao.models.RoadPoint;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicBoolean;
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

    private ArrayList<AlleyEntity> getAlleysTheClosestToDoors(ArrayList<AlleyEntity> doors, ArrayList<AlleyEntity> shopAlleys) {
        return getAlleysTheClosestToAnother(doors, AlleyType.DOOR, shopAlleys);
    }

    private ArrayList<AlleyEntity> getAlleysTheClosestToCashes(ArrayList<AlleyEntity> cashes, ArrayList<AlleyEntity> shopAlleys) {
        return getAlleysTheClosestToAnother(cashes, AlleyType.CASH, shopAlleys);
    }

    public ArrayList<RoadPoint> getShortestWay(ArrayList<AlleyEntity> shopAlleys, List<Long> productIds) {
        ArrayList<AlleyEntity> alleysWithSelectedProducts = new ArrayList<>();
        productIds.forEach(productId -> {
            shopAlleys.forEach(alley -> {
                Optional<ProductEntity> foundProduct = alley.getProducts().stream().filter(product -> product.getId() == productId).findFirst();
                if (!foundProduct.isEmpty()) {
                    alleysWithSelectedProducts.add(alley);
                }
            });
        });
        ArrayList<AlleyEntity> doors = shopAlleys.stream().filter(alley -> alley.getType() == AlleyType.DOOR).collect(Collectors.toCollection(ArrayList::new));
        ArrayList<AlleyEntity> cashes = shopAlleys.stream().filter(alley -> alley.getType() == AlleyType.CASH).collect(Collectors.toCollection(ArrayList::new));
        ArrayList<AlleyEntity> firstAlleys = getAlleysTheClosestToDoors(doors, shopAlleys);
        ArrayList<AlleyEntity> endAlleys = getAlleysTheClosestToCashes(cashes, shopAlleys);

        for (AlleyEntity alley: firstAlleys) {
            System.out.println("FIRST: " + alley.getId() + " " +  alley.getXposition() + " " + alley.getYposition());
        }
        for (AlleyEntity alley: endAlleys) {
            System.out.println("END: " + alley.getId() + " " +  alley.getXposition() + " " + alley.getYposition());
        }

        ArrayList<RoadPoint> resultRoad = new ArrayList<>();
        return resultRoad;
    }

}
