/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.util.function.Consumer;

public class ModuleEnseignementStatique {
	
	enum TypeExercice {QCM, projet, questionsSynthese} 
	
	private String nomModule; //  Nom du module (chaine de caract�res)
	private int AnneeCreation; // Ann�e de cr�ation (nombre)
	private String nomDiplome; // Nom du dipl�me (chaine de caract�res)
	private String nomEnseignant; // Nom de l�enseignant responsable du (chaine de caract�res)
	private TypeExercice genre; ; //type d�exercice : QCM, Projet, questions de synth�se
	private boolean rattrapagePrevu;  // Rattrapage pr�vu (bool�en)
	
	public String getNomModule() {
		return nomModule;
	}

	public void setNomModule(String nomModule) {
		this.nomModule = nomModule;
	}

	public int getAnneeCreation() {
		return AnneeCreation;
	}

	public void setAnneeCreation(int anneeCreation) {
		AnneeCreation = anneeCreation;
	}

	public String getNomDiplome() {
		return nomDiplome;
	}

	public void setNomDiplome(String nomDiplome) {
		this.nomDiplome = nomDiplome;
	}

	public String getNomEnseignant() {
		return nomEnseignant;
	}

	public void setNomEnseignant(String nomEnseignant) {
		this.nomEnseignant = nomEnseignant;
	}

	public TypeExercice getGenre() {
		return genre;
	}

	public void setGenre(TypeExercice genre) {
		this.genre = genre;
	}

	public boolean isRattrapagePrevu() {
		return rattrapagePrevu;
	}

	public void setRattrapagePrevu(boolean rattrapagePrevu) {
		this.rattrapagePrevu = rattrapagePrevu;
	}

	public ModuleEnseignementStatique() {
		// TODO Auto-generated constructor stub
	}
	
	public ModuleEnseignementStatique(String nm, int annee, String nd, String ne, TypeExercice qcm, boolean r) {
		nomModule = nm;
		AnneeCreation = annee;
		nomDiplome = nd;
		nomEnseignant = ne;
		genre = qcm;
		rattrapagePrevu = r;
	}
	
public static class ConsummerUE implements Consumer<ModuleEnseignementStatique> {
	    
	    public void accept(ModuleEnseignementStatique m) {
	    	 System.out.println("le nom du module est : " + m.getNomModule() + " et ann�e de cr�ation initiale : " + m.getAnneeCreation());
	    	 m.setAnneeCreation(m.getAnneeCreation() + 1);
		      System.out.println("le nom du module est : " + m.getNomModule() + " et ann�e de cr�ation modifi�e : " + m.getAnneeCreation());
		}
	}

public static class ConsummerUE2 implements Consumer<ModuleEnseignementStatique> {
    
    public void accept(ModuleEnseignementStatique m) {

    	 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et ann�e de cr�ation initiale : " + m.getAnneeCreation());
    	 if (m.getNomEnseignant().equals("Dupont"))
    		 m.setAnneeCreation(m.getAnneeCreation() + 1);
    	 else
    		 System.out.print("Pas de modification: ");
	     System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et ann�e de cr�ation modifi�e : " + m.getAnneeCreation());
	}
}
public static class ConsummerUE3 implements Consumer<ModuleEnseignementStatique> {
    
    public void accept(ModuleEnseignementStatique m) {
    	 if (m.getGenre() == TypeExercice.QCM) {
    		 m.setRattrapagePrevu(false);
    		 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et rattapage modifi� : " + m.isRattrapagePrevu());
    	 }
    	 else
    		 System.out.println("Pas de modification du rattrapage");
    	 System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / "+ m.getNomEnseignant() + " et ann�e de cr�ation initiale : " + m.getAnneeCreation());
    	 if (m.getNomEnseignant().equals("Dupont") && m.getGenre() == TypeExercice.QCM)
    		 m.setAnneeCreation(m.getAnneeCreation() + 1);
    	 else
    		 System.out.println("Pas de modification de l'ann�e de cr�ation");
	     //System.out.println("le nom Module/enseignant est : " + m.getNomModule() + " / " + m.getNomEnseignant() + " et ann�e de cr�ation : " + m.getAnneeCreation());
	}
}
}
