package classes;

import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

import javax.xml.crypto.Data;

public class Etudiant extends Personne implements java.io.Serializable {
	
	private Date datePremiereInscription;
	transient private String numTel;
	Personne[] parents;

	public Etudiant() {
		System.out.println("Constructeur par d�faut d_�tudiant");
	}

	public Etudiant(String nom, String prenom, int age, Date date, String telephone) {
		super(nom, prenom, age);
		datePremiereInscription = date;
		numTel = telephone;
	}

	public Personne[] getParents() {
		return parents;
	}

	public void setParents(Personne[] parents) {
		this.parents = parents;
	}

	public Date getDatePremiereInscription() {
		return datePremiereInscription;
	}

	public void setDatePremiereInscription(Date datePremiereInscription) {
		this.datePremiereInscription = datePremiereInscription;
	}

	public String getNumTel() {
		return numTel;
	}

	public void setNumTel(String numTel) {
		this.numTel = numTel;
	}

}
