/* Philippe Lahire 
 * M1 MIAGE
 */

package miage.TDClassesInternes;

import java.util.function.Consumer;

public class ModuleEnseignementNonStatique {
	
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

	public ModuleEnseignementNonStatique() {
		// TODO Auto-generated constructor stub
	}
	
	public ModuleEnseignementNonStatique(String nm, int annee, String nd, String ne, TypeExercice qcm, boolean r) {
		nomModule = nm;
		AnneeCreation = annee;
		nomDiplome = nd;
		nomEnseignant = ne;
		genre = qcm;
		rattrapagePrevu = r;
	}
	
}
