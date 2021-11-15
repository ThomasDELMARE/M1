/* Philippe Lahire 
 * M1 MIAGE: Squelette pour l'exercice 2 A et 2B
 */

import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import java.util.ArrayList;

import lib.NonStaticUE;
import lib.NonStaticUE.TYPE_CONTROLE;

public class Exercice2 extends JDialog implements ActionListener {

	// D�claration tableauAffichage (JTextArea)
	JTextArea tableauAffichage = new JTextArea(500,500);

	private void initInterface() {
		ArrayList<NonStaticUE> modules = initData();

		this.setLayout(new FlowLayout());
		this.setTitle("Boîte à outils");

		// ajouter les boutons
		JButton boutonAjouterAnnee = new JButton("Ajouter une année");
		JButton boutonAjouterUneAnneeSiDumont = new JButton("Ajouter une année si Dumont");
		JButton boutonSupprimerRattrapageSiQCM = new JButton("Supprimer rattrapage si QCM");
		JButton boutonClearTextArea = new JButton("Clear");

		boutonAjouterAnnee.setBounds(10, 10, 200, 30);

		boutonAjouterUneAnneeSiDumont.setBounds(220, 10, 200, 30);
		boutonSupprimerRattrapageSiQCM.setBounds(10, 50, 200, 30);
		boutonClearTextArea.setBounds(220, 50, 200, 30);

		tableauAffichage.setSize(400, 400);
		tableauAffichage.setLineWrap(true);
		tableauAffichage.setEditable(false);
		tableauAffichage.setVisible(true);

		JScrollPane scroll = new JScrollPane(tableauAffichage);
		scroll.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS);
		scroll.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

		JFrame frame = new JFrame("Affichage des méthodes");
		frame.setSize(500, 500);
		frame.setResizable(false);
		frame.setVisible(true);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		// On ajoute les boutons à la vue
		this.add(boutonAjouterAnnee);
		this.add(boutonAjouterUneAnneeSiDumont);
		this.add(boutonSupprimerRattrapageSiQCM);
		this.add(boutonClearTextArea);

		// On ajoute les actions au bouton
		boutonAjouterAnnee.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modules.get(0).ajouterUneAnnee(modules, tableauAffichage);
			}
		});

		boutonAjouterUneAnneeSiDumont.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modules.get(0).ajouterUneAnneeSiResponsableDupont(modules, tableauAffichage);
			}
		});

		boutonSupprimerRattrapageSiQCM.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				modules.get(0).suppressionRattrapageSiQcm(modules, tableauAffichage);
			}
		});

		boutonClearTextArea.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				tableauAffichage.setText("");
			}
		});

		frame.add(scroll);

		this.pack();
		this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		this.setVisible(true);
	}

	private static ArrayList<NonStaticUE> initData() {

		ArrayList<NonStaticUE> listeModules = new ArrayList<NonStaticUE>();

		NonStaticUE module1 = new NonStaticUE("Français", 1995, "Sorbonne", "Dupont", TYPE_CONTROLE.QCM, true);
		NonStaticUE module2 = new NonStaticUE("Chimie", 1987, "Pierre Marie", "Kevin Tran", TYPE_CONTROLE.PROJET,
				false);
		NonStaticUE module3 = new NonStaticUE("Maths", 1874, "MathSup", "Jean Louis", TYPE_CONTROLE.SYNTHESE, true);
		NonStaticUE module4 = new NonStaticUE("EPS", 1574, "STAPS", "Zinedine Zidane", TYPE_CONTROLE.PROJET, true);
		NonStaticUE module5 = new NonStaticUE("Physique", 1847, "Daltonia", "Ray Daltona", TYPE_CONTROLE.SYNTHESE,
				true);
		NonStaticUE module6 = new NonStaticUE("PHilosophie", 1542, "Eureka", "Dupont", TYPE_CONTROLE.PROJET, false);
		NonStaticUE module7 = new NonStaticUE("Technologie", 2014, "Musk Arena", "Massa Christophe", TYPE_CONTROLE.QCM,
				false);
		NonStaticUE module8 = new NonStaticUE("Italien", 1423, "Pisa", "Barnini Angela", TYPE_CONTROLE.SYNTHESE, true);
		NonStaticUE module9 = new NonStaticUE("Anglais", 1658, "Wall Street School", "Dupont", TYPE_CONTROLE.PROJET,
				false);
		NonStaticUE module10 = new NonStaticUE("SVT", 1982, "L'école de la vie", "JCVD", TYPE_CONTROLE.QCM, true);

		listeModules.add(module1);
		listeModules.add(module2);
		listeModules.add(module3);
		listeModules.add(module4);
		listeModules.add(module5);
		listeModules.add(module6);
		listeModules.add(module7);
		listeModules.add(module8);
		listeModules.add(module9);
		listeModules.add(module10);

		return listeModules;
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		// TODO Auto-generated method stub
		
	}

	public static void main(String[] args) {
		Exercice2 content = new Exercice2();
		content.initInterface();
	}

}
