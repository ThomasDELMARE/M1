/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.util.ArrayList;
import java.util.function.Consumer;

import miage.TDClassesInternes.ModuleEnseignementStatique.TypeExercice;

public class Exercice1Locale {
	
	 ArrayList<ModuleEnseignementNonStatique> tab_enseignements;
	
	//ModuleEnseignement[] enseignements;

	public void initConsummers() {
		class ConsummerUE implements Consumer<ModuleEnseignementNonStatique> {

			public void accept(ModuleEnseignementNonStatique m) {
				System.out.println("le nom du module est : " + m.getNomModule() + " et année de création initiale : "
						+ m.getAnneeCreation());
				m.setAnneeCreation(m.getAnneeCreation() + 1);
				System.out.println("le nom du module est : " + m.getNomModule() + " et année de création modifiée : "
						+ m.getAnneeCreation());
			}
		}
		;

		class ConsummerUE2 implements Consumer<ModuleEnseignementNonStatique> {

			public void accept(ModuleEnseignementNonStatique m) {

				System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant()
						+ " et année de création initiale : " + m.getAnneeCreation());
				if (m.getNomEnseignant().equals("Dupont"))
					m.setAnneeCreation(m.getAnneeCreation() + 1);
				else
					System.out.print("Pas de modification: ");
				System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant()
						+ " et année de création modifiée : " + m.getAnneeCreation());
			}
		}
		;
		class ConsummerUE3 implements Consumer<ModuleEnseignementNonStatique> {

			public void accept(ModuleEnseignementNonStatique m) {
				if (m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM) {
					m.setRattrapagePrevu(false);
					System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "
							+ m.getNomEnseignant() + " et rattapage modifié : " + m.isRattrapagePrevu());
				} else
					System.out.println("Pas de modification du rattrapage");
				System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant()
						+ " et année de création initiale : " + m.getAnneeCreation());
				if (m.getNomEnseignant().equals("Dupont")
						&& m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM)
					m.setAnneeCreation(m.getAnneeCreation() + 1);
				else
					System.out.println("Pas de modification de l'année de création");
				// System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " /
				// " + m.getNomEnseignant() + " et année de création : " +
				// m.getAnneeCreation());
			}
		}
		;
		System.out.println("Question 1.1");
		tab_enseignements.forEach(new ConsummerUE());
		System.out.println("Question 1.2");
		tab_enseignements.forEach(new ConsummerUE2());
		System.out.println("Question 1.3");
		tab_enseignements.forEach(new ConsummerUE3());
	}
	
	public Exercice1Locale(ArrayList<ModuleEnseignementNonStatique> t) {
		tab_enseignements = t;
		//enseignements = new ModuleEnseignement[] {new ModuleEnseignement("module1",1999, "M1", "Pierre", TypeExercice.QCM, true), new ModuleEnseignement("module2",2006, "M2", "Jean", TypeExercice.QCM, true)}; 
	}

	public static void main(String[] args) {
		Exercice1Locale e = new Exercice1Locale(new ArrayList<ModuleEnseignementNonStatique>());

		e.tab_enseignements.add(0,new ModuleEnseignementNonStatique("module1",1999, "M1", "Pierre", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(1, new ModuleEnseignementNonStatique("module2",2006, "M1", "Dupont", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(2, new ModuleEnseignementNonStatique("module3",2006, "M2", "Jean", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.tab_enseignements.add(3, new ModuleEnseignementNonStatique("module4",2006, "M2", "Dupont", ModuleEnseignementNonStatique.TypeExercice.QCM, true));
		e.initConsummers();
	}
}
