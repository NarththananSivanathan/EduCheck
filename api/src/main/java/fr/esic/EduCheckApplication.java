package fr.esic;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import fr.esic.entities.Classe;
import fr.esic.entities.Cours;
import fr.esic.entities.Emargement;
import fr.esic.entities.Role;
import fr.esic.entities.User;
import fr.esic.repository.ClasseRepository;
import fr.esic.repository.CoursRepository;
import fr.esic.repository.EmargementRepository;
import fr.esic.repository.RoleRepository;
import fr.esic.repository.UserRepository;
import fr.esic.services.UserServices;

@SpringBootApplication
public class EduCheckApplication implements CommandLineRunner {
	
	@Autowired //sans lui on ne peut pas utilise les methodes accessible au repository ajoute automatiquement des elements nécessaire (obligatoire)
	private UserRepository userRepos ;
	
	@Autowired
	private RoleRepository roleRepos ;
	
	@Autowired
	private ClasseRepository classeRepos ;
	
	@Autowired
	private CoursRepository coursRepos;
	
	@Autowired
	private EmargementRepository emargRepos;
	
	@Autowired
	private UserServices userService;

	public static void main(String[] args) {
		SpringApplication.run(EduCheckApplication.class, args);
		System.out.println("Lancement terminé");
	}

	@Override
	public void run(String... args) throws Exception {
		// TODO Auto-generated method stub
		
		Role r1 = new Role(null , "ETUDIANT");
		Role r2 = new Role(null , "FORMATEUR");
		Role r3 = new Role(null , "ADMINISTRATEUR");
		
		roleRepos.save(r1);
		roleRepos.save(r2);
		roleRepos.save(r3);
		
		
		Classe c1 = new Classe(null , "BTS SIO 1" , null);
		Classe c2 = new Classe(null , "CDA" , null);
		classeRepos.save(c1);
		classeRepos.save(c2);
		
		User u1 = new User(null , "DA SILVA" , "Nola" , "nola@esic.fr" , "azerty" , r1 , c1);
		User u2 = new User(null , "GOUANGA" , "Martha" , "martha@esic.fr" , "abcde", r2 , c2 );
		User u3 = new User(null , "BANKA" , "Joel" , "joel@esic.fr" , "qwerty" , r3 , c1);
		
		userService.saveWithPwdEncoder(u1);
		userService.saveWithPwdEncoder(u2);
		userService.saveWithPwdEncoder(u3);
		
		/*List<User> apprenantsBTS = new ArrayList<>();
		apprenantsBTS.add(u1);
		apprenantsBTS.add(u3);
		
		List<User> apprenantsCDA = new ArrayList<>();
		apprenantsCDA.add(u2);
		
		c1.setApprenants(apprenantsBTS);
		c2.setApprenants(apprenantsCDA);
		classeRepos.save(c1);
		classeRepos.save(c2);*/
		
		SimpleDateFormat d = new SimpleDateFormat("dd/MM/yyyy");
		
		Cours cral = new Cours(null , "dev" , c1 , null , d.parse("11/06/2024"), "matin", u2);
		coursRepos.save(cral);
	
		Emargement e1 = new Emargement(u1 , cral , false , null , "il est occupé" , null);
		Emargement e2 = new Emargement(u3 , cral , true , null , "" , null);
		
		emargRepos.save(e1);
		emargRepos.save(e2);
	}

}
