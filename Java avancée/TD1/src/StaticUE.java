import java.util.ArrayList;

public class StaticUE {

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

    public StaticUE(String nomModule, int anneeCreation, String nomDiplome, String nomResponsable, TYPE_CONTROLE typeControle, boolean rattrapage) {
        this.nomModule = nomModule;
        this.anneeCreation = anneeCreation;
        this.nomDiplome = nomDiplome;
        this.nomResponsable = nomResponsable;
        this.typeControle = typeControle;
        this.rattrapage = rattrapage;
    }
    
    // METHODES - IMPLEMENTATION STATIQUE

    private static void ajouterUneAnnee(ArrayList<StaticUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnnee(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            System.out.println("L'ancienne date du module " + module.nomModule + " était le " + module.anneeCreation + ".\n");
            module.anneeCreation += 1;
            System.out.println("La nouvelle date du module " + module.nomModule + " est le " + module.anneeCreation + ".\n");
        });
    }

    private static void ajouterUneAnneeSiResponsableDupont(ArrayList<StaticUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnneeSiResponsableDupont(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.nomResponsable == "Dupont"){
                System.out.println("Monsieur Dupont est en charge du module " + module.nomModule + ", l'ancienne date du module était le " + module.anneeCreation + ".\n");
                module.anneeCreation += 1;
                System.out.println("La nouvelle date du module " + module.nomModule + " car Monsieur Dupont est en charge de ce dernier, est le " + module.anneeCreation + ".\n");    
            }
        });
    }
    
    private static void suppressionRattrapageSiQcm(ArrayList<StaticUE> arrayList){
        System.out.print("DEMARRAGE DE LA METHODE suppressionRattrapageSiQcm(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.typeControle == TYPE_CONTROLE.QCM && module.rattrapage == true){
                module.rattrapage = false;
                System.out.println("Car le type de contrôle est un QCM, pour le module " + module.nomModule + " et que les rattrapages étaient disponibles pour cette matière, on décide de supprimer les rattrapages.\n");    
            }
        });
    }


    public static void main(String[] args) throws Exception {
        ArrayList<StaticUE> listeModules = new ArrayList<StaticUE>();

        StaticUE module1 = new StaticUE("Français", 1995, "Sorbonne", "Dupont", TYPE_CONTROLE.QCM, true);
        StaticUE module2 = new StaticUE("Chimie", 1987, "Pierre Marie", "Kevin Tran", TYPE_CONTROLE.PROJET,false);
        StaticUE module3 = new StaticUE("Maths", 1874, "MathSup", "Jean Louis", TYPE_CONTROLE.SYNTHESE,true);
        StaticUE module4 = new StaticUE("EPS", 1574, "STAPS", "Zinedine Zidane", TYPE_CONTROLE.PROJET,true);
        StaticUE module5 = new StaticUE("Physique", 1847, "Daltonia", "Ray Daltona", TYPE_CONTROLE.SYNTHESE,true);
        StaticUE module6 = new StaticUE("PHilosophie", 1542, "Eureka", "Dupont", TYPE_CONTROLE.PROJET,false);
        StaticUE module7 = new StaticUE("Technologie", 2014, "Musk Arena", "Massa Christophe", TYPE_CONTROLE.QCM, false);
        StaticUE module8 = new StaticUE("Italien", 1423, "Pisa", "Barnini Angela", TYPE_CONTROLE.SYNTHESE,true);
        StaticUE module9 = new StaticUE("Anglais", 1658, "Wall Street School", "Dupont", TYPE_CONTROLE.PROJET,false);
        StaticUE module10 = new StaticUE("SVT", 1982, "L'école de la vie", "JCVD", TYPE_CONTROLE.QCM,true);

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
        StaticUE.ajouterUneAnnee(listeModules);

        System.out.print("_________________\n\n");

        // COMMENCEMENT DE L INCREMENTATION DES ANNES SI L ENSEIGNANT EST DUPONT
        StaticUE.ajouterUneAnneeSiResponsableDupont(listeModules);

        System.out.print("_________________\n\n");
        
        // // COMMENCEMENT DE LA METHODE DE SUPPRESION DU RATTRAPAGE SI LE MODULE EVALUE GRACE A UN QCM
        StaticUE.suppressionRattrapageSiQcm(listeModules);

        System.out.print("_________________\n\n");
    }

}
