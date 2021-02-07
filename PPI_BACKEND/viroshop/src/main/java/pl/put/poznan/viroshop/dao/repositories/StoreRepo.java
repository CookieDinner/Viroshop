package pl.put.poznan.viroshop.dao.repositories;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pl.put.poznan.viroshop.dao.entities.StoreEntity;

@Repository
public interface StoreRepo extends CrudRepository<StoreEntity, Long> {
}
