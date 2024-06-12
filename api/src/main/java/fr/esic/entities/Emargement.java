package fr.esic.entities;

import java.util.Date;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor @AllArgsConstructor @Data
@Entity
@IdClass(EmargementContrainte.class)
public class Emargement {
	
	@Id
	@ManyToOne
	private User user;
	@Id
	@ManyToOne
	private Cours cours;
	private boolean isPresent;
	@CreationTimestamp
	private Date dateEmargement;
	private String justificatif;
	private String motif;
	
	//private String remarqueFormateur;

}
