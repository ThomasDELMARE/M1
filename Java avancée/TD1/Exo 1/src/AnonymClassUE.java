import java.util.ArrayList;

public class AnonymClassUE {

    // DECLARATION DES VARIABLES

    String nomModule;
    int anneeCreation;
    String nomDiplome;
    String nomResponsable;

    enum TYPE_CONTROLE {
        QCM, PROJET, SYNTHESE
    }

    TYPE_CONTROLE typeControle;
    boolean rattrapage;

    // CONSTRUCTEUR

    public AnonymClassUE(String nomModule, int anneeCreation, String nomDiplome, String nomResponsable, TYPE_CONTROLE typeControle, boolean rattrapage) {
        this.nomModule = nomModule;
        this.anneeCreation = anneeCreation;
        this.nomDiplome = nomDiplome;
        this.nomResponsable = nomResponsable;
        this.typeControle = typeControle;
        this.rattrapage = rattrapage;
    }

    public AnonymClassUE(String string, int i, String string2, String string3, InsideAnonymClassUE.TYPE_CONTROLE qcm,
            boolean b) {
    }

    public void afficherProf(){
        System.out.print("Ceci ne devrait pas être affiché.");
    }

    // METHODES - IMPLANTATION NON-STATIQUE

    private void ajouterUneAnnee(ArrayList<AnonymClassUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnnee(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            System.out.println("L'ancienne date du module " + module.nomModule + " était le " + module.anneeCreation + ".\n");
            module.anneeCreation += 1;
            System.out.println("La nouvelle date du module " + module.nomModule + " est le " + module.anneeCreation + ".\n");
        });
    }

    private void ajouterUneAnneeSiResponsableDupont(ArrayList<AnonymClassUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnneeSiResponsableDupont(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.nomResponsable == "Dupont"){
                System.out.println("Monsieur Dupont est en charge du module " + module.nomModule + ", l'ancienne date du module était le " + module.anneeCreation + ".\n");
                module.anneeCreation += 1;
                System.out.println("La nouvelle date du module " + module.nomModule + " car Monsieur Dupont est en charge de ce dernier, est le " + module.anneeCreation + ".\n");    
            }
        });
    }
    
    private void suppressionRattrapageSiQcm(ArrayList<AnonymClassUE> arrayList){
        System.out.print("DEMARRAGE DE LA METHODE suppressionRattrapageSiQcm(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.typeControle == TYPE_CONTROLE.QCM && module.rattrapage == true){
                module.rattrapage = false;
                System.out.println("Car le type de contrôle est un QCM, pour le module " + module.nomModule + " et que les rattrapages étaient disponibles pour cette matière, on décide de supprimer les rattrapages.\n");    
            }
        });
    }


    public static void main(String[] args) throws Exception {
        ArrayList<AnonymClassUE> listeModules = new ArrayList<AnonymClassUE>();

        AnonymClassUE module1 = new AnonymClassUE("Français", 1995, "Sorbonne", "Dupont", TYPE_CONTROLE.QCM, true);
        AnonymClassUE module2 = new AnonymClassUE("Chimie", 1987, "Pierre Marie", "Kevin Tran", TYPE_CONTROLE.PROJET,false);
        AnonymClassUE module3 = new AnonymClassUE("Maths", 1874, "MathSup", "Jean Louis", TYPE_CONTROLE.SYNTHESE,true);
        AnonymClassUE module4 = new AnonymClassUE("EPS", 1574, "STAPS", "Zinedine Zidane", TYPE_CONTROLE.PROJET,true);
        AnonymClassUE module5 = new AnonymClassUE("Physique", 1847, "Daltonia", "Ray Daltona", TYPE_CONTROLE.SYNTHESE,true);
        AnonymClassUE module6 = new AnonymClassUE("PHilosophie", 1542, "Eureka", "Dupont", TYPE_CONTROLE.PROJET,false);
        AnonymClassUE module7 = new AnonymClassUE("Technologie", 2014, "Musk Arena", "Massa Christophe", TYPE_CONTROLE.QCM, false);
        AnonymClassUE module8 = new AnonymClassUE("Italien", 1423, "Pisa", "Barnini Angela", TYPE_CONTROLE.SYNTHESE,true);
        AnonymClassUE module9 = new AnonymClassUE("Anglais", 1658, "Wall Street School", "Dupont", TYPE_CONTROLE.PROJET,false);
        AnonymClassUE module10 = new AnonymClassUE("SVT", 1982, "L'école de la vie", "JCVD", TYPE_CONTROLE.QCM,true);

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

        COMMENCEMENT DE L INCREMENTATION DES ANNEES
        module1.ajouterUneAnnee(listeModules);

        System.out.print("_________________\n\n");

        // COMMENCEMENT DE L INCREMENTATION DES ANNES SI L ENSEIGNANT EST DUPONT
        module1.ajouterUneAnneeSiResponsableDupont(listeModules);

        System.out.print("_________________\n\n");
        
        // // COMMENCEMENT DE LA METHODE DE SUPPRESION DU RATTRAPAGE SI LE MODULE EVALUE GRACE A UN QCM
        module1.suppressionRattrapageSiQcm(listeModules);

        System.out.print("_________________\n\n");

        // Utilisation Classe anonyme
        AnonymClassUE baseClass = new AnonymClassUE("Arabe", 1995, "Sorbonne",    "Dupont", TYPE_CONTROLE.QCM, true);
        baseClass.afficherProf();
    }
}

class InsideAnonymClassUE {

    String nomModule;
    int anneeCreation;
    String nomDiplome;
    String nomResponsable;

    enum TYPE_CONTROLE {
        QCM, PROJET, SYNTHESE
    }

    TYPE_CONTROLE typeControle;
    boolean rattrapage;

    public void afficherProf() {
        AnonymClassUE stringToShow = new AnonymClassUE("Irlandais", 1995, "Sorbonne", "Irish man", TYPE_CONTROLE.QCM, true) {
            public void afficherProf() {
                System.out.println("Affichage du prof Kawazaki");
            }
        };
        stringToShow.afficherProf();
    }

    public static void main(String[] args) {
        InsideAnonymClassUE affichage = new InsideAnonymClassUE();
        affichage.afficherProf();
    }
}
