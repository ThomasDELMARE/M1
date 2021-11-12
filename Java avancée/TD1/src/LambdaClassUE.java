import java.util.ArrayList;

public class LambdaClassUE {

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

    public LambdaClassUE(String nomModule, int anneeCreation, String nomDiplome, String nomResponsable, TYPE_CONTROLE typeControle, boolean rattrapage) {
        this.nomModule = nomModule;
        this.anneeCreation = anneeCreation;
        this.nomDiplome = nomDiplome;
        this.nomResponsable = nomResponsable;
        this.typeControle = typeControle;
        this.rattrapage = rattrapage;
    }

    private void afficherProf(LambdaClassUE ue){
        
        class affichageProf {
            String nomProf = "Kawazi";
        }

        affichageProf prof = new affichageProf();
        System.out.println("Le professeur s'occupant du module " + ue.nomModule + " est monsieur " + prof.nomProf);
    }

    // METHODES - IMPLANTATION NON-STATIQUE

    private void ajouterUneAnnee(ArrayList<LambdaClassUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnnee(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            System.out.println("L'ancienne date du module " + module.nomModule + " était le " + module.anneeCreation + ".\n");
            module.anneeCreation += 1;
            System.out.println("La nouvelle date du module " + module.nomModule + " est le " + module.anneeCreation + ".\n");
        });
    }

    private void ajouterUneAnneeSiResponsableDupont(ArrayList<LambdaClassUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnneeSiResponsableDupont(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.nomResponsable == "Dupont"){
                System.out.println("Monsieur Dupont est en charge du module " + module.nomModule + ", l'ancienne date du module était le " + module.anneeCreation + ".\n");
                module.anneeCreation += 1;
                System.out.println("La nouvelle date du module " + module.nomModule + " car Monsieur Dupont est en charge de ce dernier, est le " + module.anneeCreation + ".\n");    
            }
        });
    }
    
    private void suppressionRattrapageSiQcm(ArrayList<LambdaClassUE> arrayList){
        System.out.print("DEMARRAGE DE LA METHODE suppressionRattrapageSiQcm(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.typeControle == TYPE_CONTROLE.QCM && module.rattrapage == true){
                module.rattrapage = false;
                System.out.println("Car le type de contrôle est un QCM, pour le module " + module.nomModule + " et que les rattrapages étaient disponibles pour cette matière, on décide de supprimer les rattrapages.\n");    
            }
        });
    }


    public static void main(String[] args) throws Exception {
        ArrayList<LambdaClassUE> listeModules = new ArrayList<LambdaClassUE>();

        LambdaClassUE module1 = new LambdaClassUE("Français", 1995, "Sorbonne", "Dupont", TYPE_CONTROLE.QCM, true);
        LambdaClassUE module2 = new LambdaClassUE("Chimie", 1987, "Pierre Marie", "Kevin Tran", TYPE_CONTROLE.PROJET,false);
        LambdaClassUE module3 = new LambdaClassUE("Maths", 1874, "MathSup", "Jean Louis", TYPE_CONTROLE.SYNTHESE,true);
        LambdaClassUE module4 = new LambdaClassUE("EPS", 1574, "STAPS", "Zinedine Zidane", TYPE_CONTROLE.PROJET,true);
        LambdaClassUE module5 = new LambdaClassUE("Physique", 1847, "Daltonia", "Ray Daltona", TYPE_CONTROLE.SYNTHESE,true);
        LambdaClassUE module6 = new LambdaClassUE("PHilosophie", 1542, "Eureka", "Dupont", TYPE_CONTROLE.PROJET,false);
        LambdaClassUE module7 = new LambdaClassUE("Technologie", 2014, "Musk Arena", "Massa Christophe", TYPE_CONTROLE.QCM, false);
        LambdaClassUE module8 = new LambdaClassUE("Italien", 1423, "Pisa", "Barnini Angela", TYPE_CONTROLE.SYNTHESE,true);
        LambdaClassUE module9 = new LambdaClassUE("Anglais", 1658, "Wall Street School", "Dupont", TYPE_CONTROLE.PROJET,false);
        LambdaClassUE module10 = new LambdaClassUE("SVT", 1982, "L'école de la vie", "JCVD", TYPE_CONTROLE.QCM,true);

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

        // COMMENCEMENT DE L INCREMENTATION DES ANNEES
        module1.ajouterUneAnnee(listeModules);

        System.out.print("_________________\n\n");

        // COMMENCEMENT DE L INCREMENTATION DES ANNES SI L ENSEIGNANT EST DUPONT
        module1.ajouterUneAnneeSiResponsableDupont(listeModules);

        System.out.print("_________________\n\n");
        
        // // COMMENCEMENT DE LA METHODE DE SUPPRESION DU RATTRAPAGE SI LE MODULE EVALUE GRACE A UN QCM
        module1.suppressionRattrapageSiQcm(listeModules);

        System.out.print("_________________\n\n");

        // Utilisation lambda
        Runnable module11 = () -> { System.out.println("Utilisation d'une fonction lambda !"); } ;
        module11.run();
    }
}