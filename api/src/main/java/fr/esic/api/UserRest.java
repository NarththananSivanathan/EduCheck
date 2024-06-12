package fr.esic.api;


import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import fr.esic.entities.User;
import fr.esic.repository.UserRepository;
import fr.esic.services.UserServices;


@RestController @CrossOrigin("*")
public class UserRest {
	
	@Autowired
	private UserRepository userRepos;
	
	@Autowired
	private UserServices userService;
	
	@PostMapping("login")
	public Optional<User> connexion (@RequestBody User u){		
		return userService.login(u.getEmail(), u.getPassword());
	}
	
	@PostMapping("user") //inscription
	public User saveUser(@RequestBody User u) {
		return userService.saveWithPwdEncoder(u);
	}
	
	@GetMapping("users-by-role")
	public List<User> getUsersByRole(@RequestParam String roleName) {
	    return userService.getUsersByRole(roleName);
	}
	
	@GetMapping("/count/students")
    public long countStudents() {
        return userRepos.countStudents();
    }

    @GetMapping("/count/formateurs")
    public long countFormateurs() {
        return userRepos.countFormateurs();
    }
	
}
