package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.repositories.UserRepo;
import pl.put.poznan.viroshop.dao.entities.UserEntity;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class UserManager {

    private UserRepo userRepo;

    @Autowired
    public UserManager(UserRepo userRepo) {
        this.userRepo = userRepo;
    }

    public Optional<UserEntity> findAllById(Long id) {
        return userRepo.findById(id);
    }

    public Iterable<UserEntity> findAll() {
        return userRepo.findAll();
    }

    public UserEntity save(UserEntity userEntity) {
        return userRepo.save(userEntity);
    }

    public void deleteById(Long id) {
        userRepo.deleteById(id);
    }

    public List<UserEntity> findByLogin(String login) {
        return userRepo.findByLogin(login);
    }

    /**
     * Add to database specific records.
     * EventListener activate this method when application starts (parameter of the adnotation)
     */
    @EventListener(ApplicationReadyEvent.class)
    public void fillDataBase() {
        save(new UserEntity(1L, "lennon123", "lenon@lemon.pl", "ouiya11", LocalDate.of(1995, 1, 1)));
        save(new UserEntity(2L, "maQWE77", "jubikom@gmail.com", "Zazdro99", LocalDate.of(1990, 2, 22)));
    }
}
