package pl.put.poznan.viroshop.dao.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pl.put.poznan.viroshop.dao.entities.ProductReservationEntity;

@Repository
public interface ProductReservationRepo extends CrudRepository<ProductReservationEntity, Long> {
}
