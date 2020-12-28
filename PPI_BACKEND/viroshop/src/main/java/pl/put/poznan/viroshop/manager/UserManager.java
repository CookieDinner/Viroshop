package pl.put.poznan.viroshop.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.dao.models.ChangePasswordModel;
import pl.put.poznan.viroshop.dao.repositories.UserRepo;

import java.util.List;
import java.util.Optional;

@Service
public class UserManager {

    private final UserRepo userRepo;

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

    public boolean changePassword(ChangePasswordModel model) {
        List<UserEntity> foundUsers = this.findByLogin(model.getLogin());
        if (foundUsers.size() == 0) {
            return false;
        }
        if (foundUsers.size() > 1) {
            // Realy bad problem if repo can find 2 users with the same login.
            return false;
        }
        UserEntity user = foundUsers.get(0);
        if (!user.getPassword().equals(model.getOldPassword())) {
            return false;
        }
        user.setPassword(model.getNewPassword());
        userRepo.save(user);
        return true;
    }

}
