/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.util.Comparator;
import java.util.function.Consumer;

public class Etudiant extends Personne {

	int noteJava;
	
	public Etudiant(String nom, int n) {
		
		super(nom);
		//this.nom = nom;
		noteJava = n;
		//adresse = "test";
	}

	public static class ComparateurEtudiant implements Comparator<Etudiant> {
	    
	    public int compare(Etudiant e1, 
				Etudiant e2) {
	      if (e1 == null) {return -1;}
	      if (e2 == null) {return 1;}
	      Integer i = e1.noteJava;
	      int res = i.compareTo(e2.noteJava);
	      if (res == 0) {
		res = e1.getNom().compareTo(e2.getNom());
		}
	      return res;
	    }
	}
	
public static class ConsummerEtudiant implements Consumer<Etudiant> {
	    
	public void accept(Etudiant t) {
	      System.out.println("le nom est : " + t.getNom() + "et obtient pour note : " + t.noteJava);
	}
}
	
	public String toString() {
	    return this.getNom() + " " + this.noteJava;
	  }
}
