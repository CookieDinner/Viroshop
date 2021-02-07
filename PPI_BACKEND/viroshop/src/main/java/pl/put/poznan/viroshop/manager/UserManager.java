package pl.put.poznan.viroshop.manager;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.dao.models.ChangePasswordModel;
import pl.put.poznan.viroshop.dao.repositories.UserRepo;
import pl.put.poznan.viroshop.service.MailService;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
public class UserManager {

    private final UserRepo userRepo;
    private final MailService mailService;

    @Autowired
    public UserManager(UserRepo userRepo, MailService mailService) {
        this.userRepo = userRepo;
        this.mailService = mailService;
    }

    public Optional<UserEntity> findOneById(Long id) {
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

    public boolean forgotPassword(String login) {
        List<UserEntity> foundUsers = this.findByLogin(login);
        if (foundUsers.size() == 0) {
            return false;
        }
        if (foundUsers.size() > 1) {
            // Realy bad problem if repo can find 2 users with the same login.
            return false;
        }
        UserEntity user = foundUsers.get(0);

        String password = RandomStringUtils.randomAlphanumeric(20);
        char[] chars = password.toCharArray();
        Character[] characters = new Character[chars.length];
        for (int i = 0; i < chars.length; i++) {
            characters[i] = Character.valueOf(chars[i]);
        }
        List<Character> characterList = Arrays.asList(characters);
        Collections.shuffle(characterList);
        characterList.toArray(characters);
        StringBuilder passwordBuilder = new StringBuilder();
        for (Character c : characters) {
            passwordBuilder.append(c);
        }
        user.setPassword(passwordBuilder.toString());
        userRepo.save(user);

        mailService.sendForgotPasswordMail(foundUsers.get(0).getEmail(), passwordBuilder.toString());

        return true;
    }


}
