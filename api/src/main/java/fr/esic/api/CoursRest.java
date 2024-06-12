package fr.esic.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import fr.esic.entities.Cours;
import fr.esic.entities.User;
import fr.esic.repository.CoursRepository;

@RestController @CrossOrigin("*")
public class CoursRest {
	
	@Autowired
	private CoursRepository coursRepos ;
	
	// API pour récupérer les cours d'un formateur
    @GetMapping("/cours/{formateurId}")
    public List<Cours> getCoursByFormateur(@PathVariable Long formateurId) {
        return coursRepos.findByCreateurId(formateurId);
    }
    
    @GetMapping("/cours/{coursId}/apprenants")
    public List<User> getApprenantsByCoursId(@PathVariable Long coursId) {
        return coursRepos.findApprenantsByCoursId(coursId);
    }
}
