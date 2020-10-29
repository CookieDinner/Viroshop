package pl.put.poznan.viroshop.dao;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pl.put.poznan.viroshop.dao.entities.UserEntity;

import java.util.List;

@Repository
public interface UserRepo extends CrudRepository<UserEntity, Long> {

    @Query("SELECT u from UserEntity u WHERE login = :login")
    List<UserEntity> findByLogin(@Param("login") String login);

}
