package fr.esic.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import fr.esic.entities.Cours;
import fr.esic.entities.User;

public interface CoursRepository extends CrudRepository<Cours,Long> {
	
	List<Cours> findByCreateurId(Long createurId);
	
	@Query("SELECT c.classe.apprenants FROM Cours c WHERE c.id = :coursId")
    List<User> findApprenantsByCoursId(@Param("coursId") Long coursId);

}
