/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.exemple;

public class Personne {

	private String nom;
	String prenom;
	private Adresse adresse;
	
	public Personne(String nom, String prenom) {
		super();
		this.setNom(nom);
		this.prenom = prenom;
	}
	
	public Personne(String nom, String prenom, Adresse a) {
		super();
		this.setNom(nom);
		this.prenom = prenom;
		adresse = a;
	}


	public Personne(String nom) {
		super();
		this.setNom(nom);
	}

	public String getNom() {
		return nom;
	}

	public void setNom(String nom) {
		this.nom = nom;
	}
	
	
}
