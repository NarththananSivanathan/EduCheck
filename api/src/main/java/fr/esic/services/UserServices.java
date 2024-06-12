package fr.esic.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import fr.esic.entities.User;
import fr.esic.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
public class UserServices {
	
	@Autowired
	private UserRepository userRepos;
	
	private BCryptPasswordEncoder passwordEncoder =  new BCryptPasswordEncoder();
	
	public User saveWithPwdEncoder ( User user) {
		String hashedPwd = passwordEncoder.encode(user.getPassword());
		user.setPassword(hashedPwd);
		return userRepos.save(user);
	}
	
	public Optional<User> login (String email , String pwd) {
		Optional<User> user = userRepos.findByEmail(email);
		if(user.isPresent() && passwordEncoder.matches(pwd , user.get().getPassword())) {
			return user;
		}else {
			return Optional.empty();
		}
	}
	
	public List<User> getUsersByRole(String roleName) {
        // Implémentez la logique pour récupérer les utilisateurs par rôle ici
        return userRepos.findByRole(roleName);
    }

}
