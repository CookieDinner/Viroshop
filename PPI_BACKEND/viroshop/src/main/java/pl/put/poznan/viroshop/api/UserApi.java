package pl.put.poznan.viroshop.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import pl.put.poznan.viroshop.dao.entities.UserEntity;
import pl.put.poznan.viroshop.manager.UserManager;

import java.util.List;

@RestController
public class UserApi {

    private UserManager userManager;

    @Autowired
    public UserApi(UserManager userManager) {
        this.userManager = userManager;
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
        return new ResponseEntity("Registered", HttpStatus.OK);
    }

}
