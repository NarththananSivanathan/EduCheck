package fr.esic.entities;

import java.util.List;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Data
//@JsonIdentityInfo (generator = ObjectIdGenerators.PropertyGenerator.class, property = "id")
public class Classe {
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id ;
	private String nom;
	@OneToMany(mappedBy = "classe")
	@JsonIgnore
	private List<User> apprenants;
	
}
