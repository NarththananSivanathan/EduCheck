package fr.esic.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RestController;

import fr.esic.repository.RoleRepository;

@RestController @CrossOrigin("*")
public class RoleRest {
	
	@Autowired
	private RoleRepository roleRepos;
}
