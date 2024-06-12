package fr.esic.entities;


import java.io.Serializable;
import java.util.Date;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@Entity
@Data
public class Cours implements Serializable{
	
	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	private String nomDucours;
	
	@ManyToOne
	private Classe classe;
	
	@CreationTimestamp //c'est le now
	private Date dateCreation ;
	private Date dateCours;
	private String creneau;
	//private boolean instantane ;
	@ManyToOne
	private User createur ;
	//private User formateur;

}
