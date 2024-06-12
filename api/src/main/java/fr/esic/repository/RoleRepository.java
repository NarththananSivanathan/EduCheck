package fr.esic.repository;

import org.springframework.data.repository.CrudRepository;

import fr.esic.entities.Role;

public interface RoleRepository extends CrudRepository<Role, Long>{
	
}
