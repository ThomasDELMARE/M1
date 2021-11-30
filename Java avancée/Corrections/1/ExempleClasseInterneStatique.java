/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.util.ArrayList;
import java.util.Arrays;

public class ExempleClasseInterneStatique {
	
	 Etudiant[] etudiants;
	 ArrayList <Etudiant> etudiants2;
	 
	public ExempleClasseInterneStatique() {

		 //Etudiant e1, e2, e3;
		//e1 = new Etudiant("etudiantA",10);
		//e2 = new Etudiant("etudiantC",11);
		//e3 = new Etudiant("etudiantB",11);
		//etudiants = new Etudiant[]{e1,e2,e3};
		etudiants = new Etudiant[] {new Etudiant("etudiantA",10), 
				    new Etudiant ("etudiantC", 11), 
				     new Etudiant ("etudiantB", 11)};
		
	}
	
	private void init() {
		etudiants2 = new ArrayList<Etudiant>(3);
		etudiants2.add(etudiants[0]);
		etudiants2.add(etudiants[1]);
		etudiants2.add(etudiants[2]);
	}
	
	public void test1 () {
		ExempleClasseInterneStatique e ;
	     e = new ExempleClasseInterneStatique();
	    Arrays.sort(e.etudiants, new Etudiant.ComparateurEtudiant());
	    System.out.println(Arrays.toString(e.etudiants));
	}

	public void test2 () {

		ExempleClasseInterneStatique e ;
	     e = new ExempleClasseInterneStatique();
		e.init();
		 e.etudiants2.forEach(new Etudiant.ConsummerEtudiant());
	}
	
	public static void main(String[] args) {
		ExempleClasseInterneStatique e ;
	     e = new ExempleClasseInterneStatique();
	    Arrays.sort(e.etudiants, new Etudiant.ComparateurEtudiant());
	    System.out.println(Arrays.toString(e.etudiants));
	    e.init();
	    e.etudiants2.forEach(new Etudiant.ConsummerEtudiant());
	}

}
