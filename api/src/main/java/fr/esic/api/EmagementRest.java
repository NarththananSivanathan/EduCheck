package fr.esic.api;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import fr.esic.entities.Emargement;
import fr.esic.entities.EmargementContrainte;
import fr.esic.repository.EmargementRepository;

@RestController @CrossOrigin("*")
public class EmagementRest {
	
	@Autowired
	private EmargementRepository emargRepos;
	
	@PatchMapping("emargements/{idUser}/{idCours}")
	public Optional<Emargement> modifEmargement(@PathVariable Long idUser , @PathVariable Long idCours , @RequestBody Emargement emargement){
		
		EmargementContrainte id = new EmargementContrainte(idUser , idCours);
		Optional<Emargement> e = emargRepos.findById(id);
		
		if(e.isPresent()) {
			e.get().setJustificatif(emargement.getJustificatif());
			e.get().setMotif(emargement.getMotif());
			emargRepos.save(e.get());
		}
		
		return e;
		
	}
	
	@GetMapping("/cours/etudiant/{userId}")
    public List<Object[]> getCoursesByStudentId(@PathVariable Long userId) {
        return emargRepos.findCoursesByStudentId(userId);
    }
    
    @GetMapping("/presence/etudiant/{userId}")
    public double calculatePresencePercentageByStudentId(@PathVariable Long userId) {
        int totalEmargements = emargRepos.countTotalEmargementsByStudentId(userId);
        int presentEmargements = emargRepos.countPresentEmargementsByStudentId(userId);
        
        if (totalEmargements == 0) {
            return 0.0;
        }
        
        return ((double) presentEmargements / totalEmargements) * 100.0;
    }

    
    @GetMapping("/emargements/cours/{coursId}")
    public List<Emargement> getEmargementsByCoursId(@PathVariable Long coursId) {
        return emargRepos.findEmargementsByCoursId(coursId);
    }

}
