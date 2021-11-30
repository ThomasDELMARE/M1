/* Philippe Lahire 
 * M1 MIAGE
 */


package miage.exemple;

public class Etudiant extends Personne {

	int noteJava;
	Personne[] parents;
	
	public Etudiant(String nom, int n) {
		
		super(nom);
		noteJava = n;
	}

	public Etudiant(String nom, int n, Personne p, Personne m) {
		
		super(nom);
		noteJava = n;
		parents = new Personne[] {p, m};
	}
}
