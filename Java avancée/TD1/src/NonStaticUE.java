import java.util.ArrayList;

public class NonStaticUE {

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

    public NonStaticUE(String nomModule, int anneeCreation, String nomDiplome, String nomResponsable, TYPE_CONTROLE typeControle, boolean rattrapage) {
        this.nomModule = nomModule;
        this.anneeCreation = anneeCreation;
        this.nomDiplome = nomDiplome;
        this.nomResponsable = nomResponsable;
        this.typeControle = typeControle;
        this.rattrapage = rattrapage;
    }


    // METHODES - IMPLANTATION NON-STATIQUE

    private void ajouterUneAnnee(ArrayList<NonStaticUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnnee(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            System.out.println("L'ancienne date du module " + module.nomModule + " était le " + module.anneeCreation + ".\n");
            module.anneeCreation += 1;
            System.out.println("La nouvelle date du module " + module.nomModule + " est le " + module.anneeCreation + ".\n");
        });
    }

    private void ajouterUneAnneeSiResponsableDupont(ArrayList<NonStaticUE> arrayList) {
        System.out.print("DEMARRAGE DE LA METHODE ajouterUneAnneeSiResponsableDupont(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.nomResponsable == "Dupont"){
                System.out.println("Monsieur Dupont est en charge du module " + module.nomModule + ", l'ancienne date du module était le " + module.anneeCreation + ".\n");
                module.anneeCreation += 1;
                System.out.println("La nouvelle date du module " + module.nomModule + " car Monsieur Dupont est en charge de ce dernier, est le " + module.anneeCreation + ".\n");    
            }
        });
    }
    
    private void suppressionRattrapageSiQcm(ArrayList<NonStaticUE> arrayList){
        System.out.print("DEMARRAGE DE LA METHODE suppressionRattrapageSiQcm(ArrayList<UE> arrayList) \n\n\n");

        arrayList.forEach((module) -> {
            if(module.typeControle == TYPE_CONTROLE.QCM && module.rattrapage == true){
                module.rattrapage = false;
                System.out.println("Car le type de contrôle est un QCM, pour le module " + module.nomModule + " et que les rattrapages étaient disponibles pour cette matière, on décide de supprimer les rattrapages.\n");    
            }
        });
    }


    public static void main(String[] args) throws Exception {
        ArrayList<NonStaticUE> listeModules = new ArrayList<NonStaticUE>();

        NonStaticUE module1 = new NonStaticUE("Français", 1995, "Sorbonne", "Dupont", TYPE_CONTROLE.QCM, true);
        NonStaticUE module2 = new NonStaticUE("Chimie", 1987, "Pierre Marie", "Kevin Tran", TYPE_CONTROLE.PROJET,false);
        NonStaticUE module3 = new NonStaticUE("Maths", 1874, "MathSup", "Jean Louis", TYPE_CONTROLE.SYNTHESE,true);
        NonStaticUE module4 = new NonStaticUE("EPS", 1574, "STAPS", "Zinedine Zidane", TYPE_CONTROLE.PROJET,true);
        NonStaticUE module5 = new NonStaticUE("Physique", 1847, "Daltonia", "Ray Daltona", TYPE_CONTROLE.SYNTHESE,true);
        NonStaticUE module6 = new NonStaticUE("PHilosophie", 1542, "Eureka", "Dupont", TYPE_CONTROLE.PROJET,false);
        NonStaticUE module7 = new NonStaticUE("Technologie", 2014, "Musk Arena", "Massa Christophe", TYPE_CONTROLE.QCM, false);
        NonStaticUE module8 = new NonStaticUE("Italien", 1423, "Pisa", "Barnini Angela", TYPE_CONTROLE.SYNTHESE,true);
        NonStaticUE module9 = new NonStaticUE("Anglais", 1658, "Wall Street School", "Dupont", TYPE_CONTROLE.PROJET,false);
        NonStaticUE module10 = new NonStaticUE("SVT", 1982, "L'école de la vie", "JCVD", TYPE_CONTROLE.QCM,true);

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
    }
}