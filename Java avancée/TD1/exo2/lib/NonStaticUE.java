package lib;

import java.util.ArrayList;

import javax.swing.JTextArea;

public class NonStaticUE {

    // DECLARATION DES VARIABLES

    String nomModule;
    int anneeCreation;
    String nomDiplome;
    String nomResponsable;

    public enum TYPE_CONTROLE {
        QCM, PROJET, SYNTHESE
    }

    TYPE_CONTROLE typeControle;
    boolean rattrapage;

    // CONSTRUCTEUR

    public NonStaticUE(String nomModule, int anneeCreation, String nomDiplome, String nomResponsable, TYPE_CONTROLE typeControle, boolean rattrapage) {
        this.nomModule = nomModule;
        this.anneeCreation = anneeCreation;
        this.nomDiplome = nomDiplome;
        this.nomResponsable = nomResponsable;
        this.typeControle = typeControle;
        this.rattrapage = rattrapage;
    }

    class affichageProf {
        String nomProf = "Kawazi";
        
        public affichageProf(){
            System.out.println(nomProf);
        }
    }

    // METHODES - IMPLANTATION NON-STATIQUE

    public void ajouterUneAnnee(ArrayList<NonStaticUE> arrayList, JTextArea textArea) {
        // System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnnee(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            textArea.append("L'ancienne date du module " + module.nomModule + " était le " + module.anneeCreation + ".\n");
            module.anneeCreation += 1;
            textArea.append("La nouvelle date du module " + module.nomModule + " est le " + module.anneeCreation + ".\n");
        });
    }

    public void ajouterUneAnneeSiResponsableDupont(ArrayList<NonStaticUE> arrayList, JTextArea textArea) {
        // System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnneeSiResponsableDupont(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.nomResponsable == "Dupont"){
                textArea.append("Monsieur Dupont est en charge du module " + module.nomModule + ", l'ancienne date du module était le " + module.anneeCreation + ".\n");
                module.anneeCreation += 1;
                textArea.append("La nouvelle date du module " + module.nomModule + " car Monsieur Dupont est en charge de ce dernier, est le " + module.anneeCreation + ".\n");    
            }
        });
    }
    
    public void suppressionRattrapageSiQcm(ArrayList<NonStaticUE> arrayList, JTextArea textArea){
        // System.out.print("DEMARRAGE DE LA METHODE suppressionRattrapageSiQcm(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.typeControle == TYPE_CONTROLE.QCM && module.rattrapage == true){
                module.rattrapage = false;
                textArea.append("Car le type de contrôle est un QCM, pour le module " + module.nomModule + " et que les rattrapages étaient disponibles pour cette matière, on décide de supprimer les rattrapages.\n");    
            }
        });
    }
}