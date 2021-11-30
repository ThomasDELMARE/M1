package miage.TDPersistance.exemple;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Date;

// Version simplifiée sans tableaux
// pour implémentation exercice 4
public class Promotion2020Version2Simplifiee {

	ObjectInputStream loader;
	ObjectOutputStream saver;
	
	Adresse2 rootAdresse;
	Etudiant2 rootEtudiant, rootEtudiant2;
	Personne2 rootPersonne, rootPersonne2;
	Etudiant3 rootEtudiant3, rootEtudiant4;
	
	public Promotion2020Version2Simplifiee() {
		//init0();
	}
	
	public void init0(){
		rootPersonne = new Personne2("Andre", "Pierre", 30);
		rootEtudiant = new Etudiant2("Andre", "Pierre", 30, new Date(), "9294562389");
		rootAdresse = new Adresse2 ("Nice", "avenue Valrose", 28, true);
		rootPersonne.setAdresse(rootAdresse);
		rootEtudiant.setAdresse(rootAdresse);
		//rootPersonne.setAdresse (new Adresse("Nice", "Valrose", 28, false));
		rootEtudiant3 = new Etudiant3("Andre", "Pierre", 30, new Date(), "9294562389");
		rootEtudiant3.setAdresse(rootAdresse);
	}
	
	public void testSerialization (Personne2 r) {
		System.out.println(r.getNom());
		System.out.println(r.getPrenom());
		System.out.println(r.getAge());
		//System.out.println(r.getNumTel());
		//System.out.println(r.getDatePremiereInscription().toString());
		System.out.println(r.getAdresse().isAdressePersonnelle());
		System.out.println(r.getAdresse().getNumero());
		System.out.println(r.getAdresse().getVille());
		System.out.println(r.getAdresse().getRue());
		
		//System.out.println(rootEtudiant.getParents().toString());
	}
	public void testSerialization (Etudiant2 r) {
		System.out.println(r.getNom());
		System.out.println(r.getPrenom());
		System.out.println(r.getAge());
		System.out.println(r.getNumTel());
		System.out.println(r.getDatePremiereInscription().toString());
		System.out.println(r.getParents().toString());
		System.out.println(r.getAdresse().isAdressePersonnelle());
		System.out.println(r.getAdresse().getNumero());
		System.out.println(r.getAdresse().getVille());
		System.out.println(r.getAdresse().getRue());
	}
	
	public void testSerialization (Etudiant3 r) {
		System.out.println(r.getNom());
		System.out.println(r.getPrenom());
		System.out.println(r.getAge());
		System.out.println(r.getNumTel());
		System.out.println(r.getDatePremiereInscription().toString());
		System.out.println(r.getParents().toString());
		System.out.println(r.getAdresse().isAdressePersonnelle());
		System.out.println(r.getAdresse().getNumero());
		System.out.println(r.getAdresse().getVille());
		System.out.println(r.getAdresse().getRue());
	}
	
	public void saveEtudiants(String nomfichier) {
		
		try {
		     FileOutputStream support = new FileOutputStream(nomfichier);
		     saver = new ObjectOutputStream(support);
		     saver.writeObject(rootPersonne);
		     saver.writeObject(rootEtudiant);
		     saver.writeObject(rootEtudiant3);
		     //support.flush();
		     //support.close();
		} catch(java.io.IOException e) {e.printStackTrace();};
	}

	void retrieveEtudiants(String nomfichier) {
		
		   try {
		           FileInputStream support = new FileInputStream(nomfichier);
		           loader = new ObjectInputStream(support);
		           rootPersonne2 = (Personne2) loader.readObject();
		           rootEtudiant2 = (Etudiant2) loader.readObject();
		           rootEtudiant4 = (Etudiant3) loader.readObject();
				   //support.close();
			} catch(java.io.IOException | ClassNotFoundException e) {e.printStackTrace();};
	}
	
	public static void main(String[] args) {
		Promotion2020Version2Simplifiee p = new Promotion2020Version2Simplifiee();
		p.init0();
		p.saveEtudiants("f_etudiant");

		p.testSerialization(p.rootPersonne);
		p.testSerialization(p.rootEtudiant);
		p.testSerialization(p.rootEtudiant3);
//		 p.retrieveEtudiants("f_etudiant");
//		 p.testSerialization (p.rootPersonne2);
//		 p.testSerialization (p.rootEtudiant2);
//		 p.testSerialization (p.rootEtudiant4);
	}

}
