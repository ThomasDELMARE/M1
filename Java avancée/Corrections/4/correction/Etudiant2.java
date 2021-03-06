package miage.TDPersistance.exemple;

import java.io.Externalizable;
import java.io.IOException;
import java.util.Date;

public class Etudiant2 extends Personne2 implements Externalizable {

	//private static final long serialVersionUID = 123L;
	
	private Date datePremiereInscription;
	private String numTel;
	Personne[] parents;

	public Etudiant2() {
		System.out.println("Constructeur par d?faut d_?tudiant");
	}

	public Etudiant2(String n, String p, int a, Date d, String t) {
		super(n, p, a);
		datePremiereInscription = d;
		numTel = t;
		parents = new Personne[] {};
	}

	//solution exercice 4a
	public void writeExternal(java.io.ObjectOutput out) throws IOException {
		super.writeExternal(out);
		out.writeObject(numTel);
		out.writeObject(datePremiereInscription);
		out.writeObject(parents);
	}

	//solution exercice 4a
	public void readExternal(java.io.ObjectInput in) throws IOException, ClassNotFoundException {
		super.readExternal(in);
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
