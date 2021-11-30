/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.util.ArrayList;
import java.util.function.Consumer;

import javax.swing.AbstractAction;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class Exercice2b extends JDialog {
	
	 static ArrayList<ModuleEnseignementNonStatique> tab_enseignements;
	 
	 public Exercice2b(ArrayList<ModuleEnseignementNonStatique> t) {
		 tab_enseignements = t;
	 }

	static private class Exercice2_1 extends AbstractAction {
	   public Exercice2_1() {
	     super("Traitement 1");
	    }

	    @Override
	    public void actionPerformed(ActionEvent e) {
	    	tableauAffichage.append("Début exécution bouton1 (Question 1.1)\n");

			Consumer <ModuleEnseignementNonStatique> traitement1 = (ModuleEnseignementNonStatique m) -> {
				tableauAffichage.append("le nom du module est : " + m.getNomModule() + " et année de création initiale : " + m.getAnneeCreation());
				m.setAnneeCreation(m.getAnneeCreation() + 1) ;
				tableauAffichage.append("le nom du module est : " + m.getNomModule() + " et année de création modifiée : " + m.getAnneeCreation()+ "\n");
			};
			tab_enseignements.forEach(traitement1);
			tableauAffichage.append("Fin exécution bouton1 (Question 1.1) \n");
	    }
	  }
	
	static private class Exercice2_2 extends AbstractAction {
	    public Exercice2_2() {
	      super("Traitement 2");
	    }

	    @Override
	    public void actionPerformed(ActionEvent e) {
	    	tableauAffichage.append("Début exécution bouton2 (Question 1.2)\n");
			Consumer <ModuleEnseignementNonStatique> traitement2 = (ModuleEnseignementNonStatique m) -> {
				tableauAffichage.append("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et année de création initiale : " + m.getAnneeCreation() + "\n");
				if (m.getNomEnseignant().equals("Dupont"))
					m.setAnneeCreation(m.getAnneeCreation() + 1);
				else
					tableauAffichage.append("Pas de modification: \n");
				tableauAffichage.append("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et année de création modifiée : " + m.getAnneeCreation() + "\n");
			};
			tab_enseignements.forEach(traitement2);
			tableauAffichage.append("Fin exécution bouton2 (Question 1.2)\n");
	    }
	  }

	static private class Exercice2_3 extends AbstractAction {
	    public Exercice2_3() {
	      super("Traitement 3");
	    }

	    @Override
	    public void actionPerformed(ActionEvent e) {
	    	tableauAffichage.append("Début exécution bouton3 (Question 1.3)\n");
			Consumer <ModuleEnseignementNonStatique> traitement3 = (ModuleEnseignementNonStatique m) -> {
				if (m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM) {
					m.setRattrapagePrevu(false);
					tableauAffichage.append("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et rattapage modifié : " + m.isRattrapagePrevu() + "\n");
				} else
					tableauAffichage.append("Pas de modification du rattrapage\n");
				tableauAffichage.append("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et année de création initiale : " + m.getAnneeCreation() + "\n");
				if (m.getNomEnseignant().equals("Dupont")
						&& m.getGenre() == ModuleEnseignementNonStatique.TypeExercice.QCM)
					m.setAnneeCreation(m.getAnneeCreation() + 1);
				else
					tableauAffichage.append("Pas de modification de l'année de création \n");
				// System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " /
				// " + m.getNomEnseignant() + " et année de création : " +
				// m.getAnneeCreation());
			};
			tab_enseignements.forEach(traitement3);
			tableauAffichage.append("Fin exécution bouton3 (Question 1.3)\n");
	    }
	  }
	
	// le fait que cette valeur soit propre àà l'instance de 
	// TesterLesClassesInternes implique l'utilisation d'une classe 
	// non statique
	static private JTextArea tableauAffichage;
	
	private void initInterface() {
	
		 this.setLayout(new FlowLayout());
		 this.add(new JButton(new Exercice2_1()));
		 this.add(new JButton(new Exercice2_2()));
		 this.add(new JButton(new Exercice2_3()));
		 tableauAffichage = new JTextArea("Affichage des messages");
		 tableauAffichage.setSize(400,400);    
		 tableauAffichage.setLineWrap(true);
		 tableauAffichage.setEditable(false);
		 tableauAffichage.setVisible(true);
		 JScrollPane scroll = new JScrollPane (tableauAffichage);
		 scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		 scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
		 
		 JFrame frame = new JFrame ("Exercice 2B");
		 frame.setSize(500,500);
		 frame.setResizable(false);
		 frame.setVisible(true);
		 frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		    
		 frame.add(scroll);
		 
		 this.pack();
		 this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		 this.setVisible(true);
	}

	 public static void main(String[] args) {
			Exercice2b bt1 = new Exercice2b(new ArrayList<ModuleEnseignementNonStatique>());

			Exercice2b.tab_enseignements.add(0, new ModuleEnseignementNonStatique("module1", 1999, "M1", "Pierre",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(1, new ModuleEnseignementNonStatique("module2", 2006, "M1", "Dupont",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(2, new ModuleEnseignementNonStatique("module3", 2006, "M2", "Jean",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(3, new ModuleEnseignementNonStatique("module4", 2006, "M2", "Dupont",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			bt1.initInterface();
			Exercice2b bt2 = new Exercice2b(new ArrayList<ModuleEnseignementNonStatique>());
			Exercice2b.tab_enseignements.add(0, new ModuleEnseignementNonStatique("module1", 1999, "M1", "Pierre",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(1, new ModuleEnseignementNonStatique("module2", 2006, "M1", "Dupont",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(2, new ModuleEnseignementNonStatique("module3", 2006, "M2", "Jean",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			Exercice2b.tab_enseignements.add(3, new ModuleEnseignementNonStatique("module4", 2006, "M2", "Dupont",
					ModuleEnseignementNonStatique.TypeExercice.QCM, true));
			bt2.initInterface();
		  }

}
