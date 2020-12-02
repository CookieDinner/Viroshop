package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.dao.models.ChangePasswordModel;
import pl.put.poznan.viroshop.manager.UserManager;
import pl.put.poznan.viroshop.service.MailService;

import java.util.List;

@RestController
public class UserApi {

    private final UserManager userManager;
    private final MailService mailService;

    @Autowired
    public UserApi(UserManager userManager, MailService mailService) {
        this.userManager = userManager;
        this.mailService = mailService;
    }

    @GetMapping("/api/users")
    public Iterable<UserEntity> getAll() {
        return userManager.findAll();
    }

    @PostMapping("/api/user/login")
    public ResponseEntity login(@RequestBody UserEntity loginBody) {
        List<UserEntity> foundUsers = userManager.findByLogin(loginBody.getLogin());
        if (foundUsers.size() == 0) {
            return new ResponseEntity("User not found", HttpStatus.BAD_REQUEST);
        }
        if (foundUsers.get(0).getPassword().equals(loginBody.getPassword())) {
            return new ResponseEntity("Login successful", HttpStatus.OK);
        }
        return new ResponseEntity("Cannot login", HttpStatus.UNAUTHORIZED);
    }

    @PostMapping("/api/user/register")
    public ResponseEntity register(@RequestBody UserEntity registerBody) {
        List<UserEntity> foundUsers = userManager.findByLogin(registerBody.getLogin());

        if (foundUsers.size() != 0) {
            return new ResponseEntity("User exists", HttpStatus.BAD_REQUEST);
        }

        userManager.save(registerBody);
        this.mailService.sendRegistrationWelcome(registerBody.getEmail());
        return new ResponseEntity("Registered", HttpStatus.OK);
    }

    @PostMapping("/api/user/password/change")
    public ResponseEntity changePassword(@RequestBody ChangePasswordModel model) {
        boolean result = userManager.changePassword(model);
        if (!result) {
            return new ResponseEntity("Error while changing password", HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity("Password was changed", HttpStatus.OK);
    }

    @PostMapping("/api/user/password/forgot")
    public ResponseEntity forgotPassword(@RequestBody String userLogin) {
        List<UserEntity> foundUsers = userManager.findByLogin(userLogin);
        if (foundUsers.size() == 0) {
            return new ResponseEntity("User not found", HttpStatus.BAD_REQUEST);
        }
        mailService.sendForgotPasswordMail(foundUsers.get(0).getEmail());
        return new ResponseEntity("Check your email, we send you temporary password", HttpStatus.OK);
    }

}
