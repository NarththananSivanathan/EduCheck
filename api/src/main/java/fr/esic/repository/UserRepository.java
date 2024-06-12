package fr.esic.repository;


import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import fr.esic.entities.User;



//les interfaces ne comprennent que la méthode 
public interface UserRepository extends CrudRepository<User, Long>{
	
	public Optional<User> findByEmailAndPassword(String email, String password);
	public Optional<User> findByEmail(String email);
	
	// Ajoutez votre méthode de recherche personnalisée ici
    @Query("SELECT u FROM User u WHERE u.role.roleName = :roleName")
    List<User> findByRole(@Param("roleName") String roleName);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.role.roleName = 'Etudiant'")
    long countStudents();
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.role.roleName = 'Formateur'")
    long countFormateurs();
	
}
