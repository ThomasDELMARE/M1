package controle.ex4;

import java.io.Serializable;

public class Personne implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String nom;
	private String prenom;
	private int age;
	
	public Personne() {
		System.out.println("Constructeur par défaut de personne");
	}
	
	public Personne (String n, String p, int a) {
		nom = n;
		prenom = p;
		age = a;
	}
     
	public String getNom() {
		return nom;
	}
	public void setNom(String nom) {
		this.nom = nom;
	}
	public String getPrenom() {
		return prenom;
	}
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	
	public String toString () {
		System.out.println("Execution de toString (personne)");
		return "nom: " + nom + "- Prénom: " + prenom + " - age: " + age ;
	}
}
