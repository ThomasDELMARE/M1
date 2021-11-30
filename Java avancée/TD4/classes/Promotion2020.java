package classes;
import classes.Adresse;
import classes.Etudiant;
import classes.Personne;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Date;

// transcient, persistend field, writeobject/read object

public class Promotion2020 {
    Etudiant[] etudiants;
    Etudiant rootEtudiant;
    Adresse rootAdresse;

    public Promotion2020() {
        Etudiant etudiant1 = new Etudiant("DELMARE", "Thomas", 21, new Date(), "0707070707");
        etudiant1.setAdresse(new Adresse("Nice", "Ribotti", 36, true));
        Personne papa1 = new Personne("DELMARE", "Elisabeth", 46);
        Personne maman1 = new Personne("DELMARE", "Elisabeth", 46);
        Personne[] parents1 = { papa1, maman1 };
        etudiant1.setParents(parents1);

        Etudiant etudiant2 = new Etudiant("DELMARE", "Robin", 15, new Date(), "0707070707");
        etudiant2.setAdresse(new Adresse("Nice", "Ribotti", 36, true));
        Personne papa2 = new Personne("DELMARE", "Elisabeth", 46);
        Personne maman2 = new Personne("DELMARE", "Elisabeth", 46);
        Personne[] parents2 = { papa2, maman2 };
        etudiant2.setParents(parents2);

        Etudiant etudiant3 = new Etudiant("SANCHEZ", "Marie-Celeste", 23, new Date(), "0707070707");
        etudiant3.setAdresse(new Adresse("Nice", "Ribotti", 36, true));
        Personne papa3 = new Personne("DELMARE", "Elisabeth", 46);
        Personne maman3 = new Personne("DELMARE", "Elisabeth", 46);
        Personne[] parents3 = { papa3, maman3 };
        etudiant3.setParents(parents3);

        Etudiant[] etudiantsListe = { etudiant1, etudiant2, etudiant3 };
        etudiants = etudiantsListe;
        rootEtudiant = etudiantsListe[0];
        rootAdresse = etudiantsListe[0].getAdresse();
    }

    public void verifierContenu(Etudiant[] donneesAVerifier, boolean deserialize) {
        if(deserialize){
            System.out.println("Les donnees deserializees sont les suivantes : \n");
        }
        else{
            System.out.println("Les donnees avant deserialization sont les suivantes : \n");
        }

        for(int i = 0; i < donneesAVerifier.length; i ++){
            System.out.println("Le nom est le suivant : " + donneesAVerifier[i].getNom() + "\n Le prenom est le suivant : " +  donneesAVerifier[i].getPrenom() + "\n L'age est le suivant : " + donneesAVerifier[i].getAge() + "\n\n");
        }
    }

    public File saveEtudiants() throws FileNotFoundException, IOException {
        verifierContenu(this.etudiants, false);
        File fichier = new File("exercice1Etudiants.txt");
        ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(fichier));

        for (int i = 0; i < this.etudiants.length; i++) {
            oos.writeObject(this.etudiants[i]);
        }

        oos.close();

        return fichier;
    }

    public void retrieveEtudiants(File fichier) throws FileNotFoundException, IOException, ClassNotFoundException {
        ObjectInputStream ois = new ObjectInputStream(new FileInputStream(fichier));

        Etudiant[] listeEtudiantsDeserializee = (Etudiant[]) ois.readObject();

        verifierContenu(listeEtudiantsDeserializee, true);
    }

    public static void main(String[] args) throws FileNotFoundException, IOException, ClassNotFoundException {
        Promotion2020 currentPromo = new Promotion2020();
        File result = currentPromo.saveEtudiants();
        currentPromo.retrieveEtudiants(result);
    }
}
