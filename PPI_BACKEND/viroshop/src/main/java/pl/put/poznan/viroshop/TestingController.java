package pl.put.poznan.viroshop;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
public class TestingController {

    @GetMapping("/shops")
    public List<String> getAvailableShops() {
        List<String> availableShops = new ArrayList<>();
        availableShops.add("Biedronka");
        availableShops.add("Lidl");
        availableShops.add("Auchan");
        availableShops.add("Carrefour");
        return availableShops;
    }

    @PostMapping("/test")
    public void testMessage(@RequestBody String msg) {
        System.out.println(msg);
    }
}
