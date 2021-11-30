package miage.TDPersistance.exemple;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.function.Consumer;
import java.util.GregorianCalendar;

public class Promotion2020 {

	ArrayList<Etudiant> etudiants;
	Personne[] personnes;
	Adresse rootAdresse;
	Etudiant rootEtudiant;
	Personne rootPersonne;
	
	public Promotion2020() {
	}
	
	void init() {
		GregorianCalendar dg = new GregorianCalendar(2020, 10, 3);
		etudiants = new ArrayList<Etudiant>();
		Etudiant e;
		e = new Etudiant("Andre", "Pierre", 30, dg.getTime(), "9294562389");
		System.out.println(e.getDatePremiereInscription().toString());
		e.setAdresse(new Adresse("Nice", "Valrose", 28, false));
		rootAdresse = e.getAdresse();
		rootEtudiant = e;
		rootPersonne = e;
		etudiants.add(0,e);
		e = new Etudiant("Jean", "Marc", 20, dg.getTime(), "9494562390");
		e.setAdresse(new Adresse("Nice", "Joseph Vallot", 28, false));
		etudiants.add(1,e);
		e = new Etudiant("Andre", "Loic", 30, dg.getTime(), "9394545689");
		etudiants.add(2,e);
		e = new Etudiant("Andre", "Jeanne", 30, dg.getTime(), "9294565478");
		etudiants.add(3,e);
	}
	
	void initTableau() {
		personnes = new Personne[10];
		Personne e;
		e = new Personne("Andre", "Pierre", 30);
		e.setAdresse(new Adresse("Nice", "Valrose", 28, false));
		rootAdresse = e.getAdresse();
		rootPersonne = e;
		personnes[0] = e;
		e = new Personne("Jean", "Marc", 20);
		e.setAdresse(new Adresse("Nice", "Joseph Vallot 1", 28, false));
		personnes[1] = e;
		e = new Personne("Andre", "Loic", 30);
		e.setAdresse(new Adresse("Nice", "Joseph Vallot 2", 28, false));
		personnes[2] = e;
		e = new Personne("Andre", "Jeanne", 30);
		e.setAdresse(new Adresse("Nice", "Joseph Vallot 3", 28, false));
		personnes[3] = e;
	}
	
	public void saveEtudiants(String nomfichier) {
		ObjectOutputStream g_etudiant;
		try {
		     FileOutputStream support = new FileOutputStream(nomfichier);
		     g_etudiant = new ObjectOutputStream(support);
		     g_etudiant.writeObject(rootPersonne);
		     g_etudiant.writeObject(rootEtudiant);
		     g_etudiant.writeObject(etudiants);
		     g_etudiant.writeObject(personnes);
		     g_etudiant.writeObject(rootAdresse);
		     support.flush();
		     support.close();
		} catch(java.io.IOException e) {e.printStackTrace();};
	}

	//@SuppressWarnings("unchecked")
	void retrieveEtudiants(String nomfichier) {
		ObjectInputStream g_etudiant = null;
		   try {
		           FileInputStream support = new FileInputStream(nomfichier);
		           g_etudiant = new ObjectInputStream(support);
		           rootPersonne = (Personne) g_etudiant.readObject();
		           rootEtudiant = (Etudiant) g_etudiant.readObject();
		           etudiants = (ArrayList<Etudiant>) g_etudiant.readObject();
		           personnes = (Personne[]) g_etudiant.readObject();
		           rootAdresse = (Adresse) g_etudiant.readObject();
				   support.close();
			} catch(java.io.IOException | ClassNotFoundException e) {e.printStackTrace();};
	}
	
	public void setEtudiants(ArrayList<Etudiant> etudiants) {
		this.etudiants = etudiants;
	}

	public void setPersonnes(Personne[] personnes) {
		this.personnes = personnes;
	}

	public static void main(String[] args) {
		Promotion2020 p = new Promotion2020();
//		System.out.println("Avant sérialisation");
//		p.init();
//		p.initTableau();
//		p.saveEtudiants("f_etudiant");
		
		p.retrieveEtudiants("f_etudiant");
		System.out.println("après désérialisation");
		p.etudiants.forEach(new Consumer<Etudiant>() {
			public void accept(Etudiant e) {
				System.out.println (e.toString());
				System.out.println (e.getNom() + "  " + e.getPrenom() + " " + e.getNumTel());
				System.out.println ("adr: " + e.getAdresse());
					if (e.getAdresse() != null) {
					System.out.println(e.getAdresse().getNumero() + " " + e.getAdresse().getRue() + " " + e.getAdresse().getVille() + "(" + e.getAdresse().isAdressePersonnelle() + ")");
					}
			}
		});
		for (int i = 0; i < p.personnes.length; i++) {
			if (p.personnes[i] != null) {
				System.out.println ("personne: " + p.personnes[i].getNom() + "  " + p.personnes[i].getPrenom());
				if (p.personnes[i].getAdresse() != null) {
					System.out.println("personne: " + p.personnes[i].getAdresse().getNumero() + " " + p.personnes[i].getAdresse().getRue() + " " + p.personnes[i].getAdresse().getVille() + "(" + p.personnes[i].getAdresse().isAdressePersonnelle() + ")");
				}
			}
		}
		System.out.println("root Personne: " + p.rootPersonne.getNom());
		if (p.rootPersonne.getAdresse() != null) {
			System.out.println("Ville root Personne : " + p.rootPersonne.getAdresse().getVille());
			System.out.println("root adresse: " + p.rootAdresse.getVille() + " " + p.rootAdresse.getNumero() + " " + p.rootAdresse.getRue());
		}
		else
			System.out.println("Ville root Personne : adresse non sérialisée");
		if (p.etudiants.get(0).getAdresse() != null)
			System.out.println("Ville premier etudiant : " + p.etudiants.get(0).getAdresse().getVille());
		else 
			System.out.println(" premier etudiant  : adresse non sérialisée");
		if (p.personnes[0].getAdresse() != null)
				System.out.println("Ville première personne : " + p.personnes[0].getAdresse().getVille());
		else 
			System.out.println(" Personne[0] : adresse non sérialisée");
		p.rootPersonne.setNom("XXXX");
		System.out.println("shared: " + p.rootPersonne.getNom() + " " + p.etudiants.get(0).getNom());
		p.rootPersonne.setAdresse(new Adresse());
		p.rootPersonne.getAdresse().setVille("YYYY");
		System.out.println("shared: " + p.rootPersonne.getAdresse().getVille() + " " + p.rootAdresse.getVille());
	}

}
