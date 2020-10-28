package pl.put.poznan.viroshop.dao;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pl.put.poznan.viroshop.dao.entities.UserEntity;

@Repository
public interface UserRepo extends CrudRepository<UserEntity, Long> {
}
