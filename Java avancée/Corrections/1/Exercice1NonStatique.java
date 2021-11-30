/* Philippe Lahire 
 * M1 MIAGE
 */
package miage.TDClassesInternes;

import java.util.ArrayList;
import java.util.function.Consumer;

import miage.TDClassesInternes.ModuleEnseignementStatique.TypeExercice;

public class Exercice1NonStatique {
	
	 ArrayList<ModuleEnseignementNonStatique> tab_enseignements;

	 public class ConsummerUE implements Consumer<ModuleEnseignementNonStatique> {
		    
		    public void accept(ModuleEnseignementNonStatique m) {
		    	 System.out.println("le nom du module est : " + m.getNomModule() + " et année de création initiale : " + m.getAnneeCreation());
		    	 m.setAnneeCreation(m.getAnneeCreation() + 1);
			      System.out.println("le nom du module est : " + m.getNomModule() + " et année de création modifiée : " + m.getAnneeCreation());
			}
		}

	public class ConsummerUE2 implements Consumer<ModuleEnseignementNonStatique> {
	    
	    public void accept(ModuleEnseignementNonStatique m) {

	    	 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et année de création initiale : " + m.getAnneeCreation());
	    	 if (m.getNomEnseignant().equals("Dupont"))
	    		 m.setAnneeCreation(m.getAnneeCreation() + 1);
	    	 else
	    		 System.out.print("Pas de modification: ");
		     System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et année de création modifiée : " + m.getAnneeCreation());
		}
	}
	public class ConsummerUE3 implements Consumer<ModuleEnseignementNonStatique> {
	    
	    public void accept(ModuleEnseignementNonStatique m) {
	    	 if (m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM) {
	    		 m.setRattrapagePrevu(false);
	    		 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et rattapage modifié : " + m.isRattrapagePrevu());
	    	 }
	    	 else
	    		 System.out.println("Pas de modification du rattrapage");
	    	 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et année de création initiale : " + m.getAnneeCreation());
	    	 if (m.getNomEnseignant().equals("Dupont") && m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM)
	    		 m.setAnneeCreation(m.getAnneeCreation() + 1);
	    	 else
	    		 System.out.println("Pas de modification de l'année de création");
		     //System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et année de création : " + m.getAnneeCreation());
		}
	}
	
	public Exercice1NonStatique(ArrayList<ModuleEnseignementNonStatique> t) {
		tab_enseignements = t;
	}

	// Remarque: si on implémentait les "consummer" dans "ModuleEnseignementNonStatique" on serait obligé de créer une instance par instance de "ModuleEnseignementNonStatique" ce qui est un non sens
	public static void main(String[] args) {
		Exercice1NonStatique e = new Exercice1NonStatique(new ArrayList<ModuleEnseignementNonStatique>());

		e.tab_enseignements.add(0,new ModuleEnseignementNonStatique("module1",1999, "M1", "Pierre", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(1, new ModuleEnseignementNonStatique("module2",2006, "M1", "Dupont", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(2, new ModuleEnseignementNonStatique("module3",2006, "M2", "Jean", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(3, new ModuleEnseignementNonStatique("module4",2006, "M2", "Dupont", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		System.out.println("Question 1.1");
		e.tab_enseignements.forEach(e.new ConsummerUE());
		System.out.println("Question 1.2");
		e.tab_enseignements.forEach(e.new ConsummerUE2());
		System.out.println("Question 1.3");
		e.tab_enseignements.forEach(e.new ConsummerUE3());
	}
}
