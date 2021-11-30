/* Philippe Lahire 
 * M1 MIAGE
 */
package miage.TDClassesInternes;

import java.util.ArrayList;
import java.util.function.Consumer;

import miage.TDClassesInternes.ModuleEnseignementStatique.TypeExercice;

public class Exercice1Statique {
	
	 ArrayList<ModuleEnseignementStatique> tab_enseignements;

	public Exercice1Statique(ArrayList<ModuleEnseignementStatique> t) {
		tab_enseignements = t;
	}

public static class ConsummerUE implements Consumer<ModuleEnseignementStatique> {
	 // On pourrait placer les traitements ici  (voir (*) ci dessous
	    public void accept(ModuleEnseignementStatique m) {
	    	 System.out.println("le nom du module est : " + m.getNomModule() + " et année de création initiale : " + m.getAnneeCreation());
	    	 m.setAnneeCreation(m.getAnneeCreation() + 1);
		      System.out.println("le nom du module est : " + m.getNomModule() + " et année de création modifiée : " + m.getAnneeCreation());
		}
	}

	public static void main(String[] args) {
		ArrayList<ModuleEnseignementStatique> tab_enseignements;
		tab_enseignements = new ArrayList<ModuleEnseignementStatique>();
		tab_enseignements.add(0,new ModuleEnseignementStatique("module1",1999, "M1", "Pierre", TypeExercice.QCM, true));
		tab_enseignements.add(1, new ModuleEnseignementStatique("module2",2006, "M1", "Dupont", TypeExercice.QCM, true));
		tab_enseignements.add(2, new ModuleEnseignementStatique("module3",2006, "M2", "Jean", TypeExercice.QCM, true));
		tab_enseignements.add(3, new ModuleEnseignementStatique("module4",2006, "M2", "Dupont", TypeExercice.QCM, true));
		Exercice1Statique e = new Exercice1Statique(tab_enseignements);
		System.out.println("Question 1.1");
		e.tab_enseignements.forEach(new ModuleEnseignementStatique.ConsummerUE());
		System.out.println("Question 1.2");
		e.tab_enseignements.forEach(new ModuleEnseignementStatique.ConsummerUE2());
		System.out.println("Question 1.3");
		e.tab_enseignements.forEach(new ModuleEnseignementStatique.ConsummerUE3());
		// (*) pour tester
		ConsummerUE c = new ConsummerUE();
		e.tab_enseignements.forEach(c);
	}
}
