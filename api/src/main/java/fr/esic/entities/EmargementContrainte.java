package fr.esic.entities;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@NoArgsConstructor @AllArgsConstructor
public class EmargementContrainte implements Serializable {
	
	private Long user;
	private Long cours;

}
