package fr.esic.api;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import fr.esic.entities.User;
import fr.esic.repository.ClasseRepository;

@RestController @CrossOrigin("*")
public class ClasseRest {
	
	@Autowired
	private ClasseRepository classeRepos ;
	
	@GetMapping("/count/classes")
    public long countClasses() {
        return classeRepos.countClasses();
    }
	
}
