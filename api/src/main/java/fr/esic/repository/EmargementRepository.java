package fr.esic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import fr.esic.entities.Emargement;
import fr.esic.entities.EmargementContrainte;


public interface EmargementRepository extends CrudRepository<Emargement, EmargementContrainte>{
	
	public Iterable<Emargement> findByCoursId(Long id);
	
	@Query("SELECT e.user.id , e.cours.id , e.cours.dateCours, e.cours.creneau, e.cours.nomDucours, e.isPresent FROM Emargement e WHERE e.user.id = :userId")
    List<Object[]> findCoursesByStudentId(@Param("userId") Long userId);
    
    @Query("SELECT COUNT(e) FROM Emargement e WHERE e.user.id = :userId")
    int countTotalEmargementsByStudentId(@Param("userId") Long userId);

    @Query("SELECT COUNT(e) FROM Emargement e WHERE e.user.id = :userId AND e.isPresent = true")
    int countPresentEmargementsByStudentId(@Param("userId") Long userId);
    
    @Query("SELECT e FROM Emargement e WHERE e.cours.id = :coursId")
    List<Emargement> findEmargementsByCoursId(@Param("coursId") Long coursId);
    

}
