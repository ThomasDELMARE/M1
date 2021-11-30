package miage.TDPersistance.exemple;

import java.io.Externalizable;
import java.io.IOException;
import java.util.Date;

public class Etudiant3 extends Personne3 implements Externalizable {

	//private static final long serialVersionUID = 123L;
	
	private Date datePremiereInscription;
	private String numTel;
	Personne[] parents;

	public Etudiant3() {
		System.out.println("Constructeur par défaut d_étudiant 3");
	}

	public Etudiant3(String n, String p, int a, Date d, String t) {
		super(n, p, a);
		datePremiereInscription = d;
		numTel = t;
		parents = new Personne[] {};
	}

	//solution exercice 4b
	public void writeExternal(java.io.ObjectOutput out) throws IOException {
		// writeExternalPersonne(out);

		out.writeObject(getNom());
		out.writeObject(getPrenom());
		out.writeInt(getAge());
		out.writeObject(getAdresse());
		out.writeObject(numTel);
		out.writeObject(datePremiereInscription);
		out.writeObject(parents);
	}

	//solution exercice 4b
	public void readExternal(java.io.ObjectInput in) throws IOException, ClassNotFoundException {
		// readExternalPersonne(in);
		setNom((String) in.readObject());
		setPrenom((String) in.readObject());
		setAge(in.readInt());
		setAdresse((Adresse2) in.readObject());
		setNumTel((String) in.readObject());
		setDatePremiereInscription((Date) in.readObject());
		setParents((Personne[]) in.readObject());
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
