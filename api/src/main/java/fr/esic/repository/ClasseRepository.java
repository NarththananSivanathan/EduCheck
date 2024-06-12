package fr.esic.repository;


import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import fr.esic.entities.Classe;

public interface ClasseRepository extends CrudRepository<Classe, Long>{
	
	@Query("SELECT COUNT(c) FROM Classe c")
    long countClasses();
	

}
