package miage.TDPersistance.exemple;

import java.io.ObjectStreamField;
import java.io.Serializable;

public class Adresse implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 123L;
	
	// Solution exercice 3a
	private static final ObjectStreamField[] serialPersistentFields = 
	     { new ObjectStreamField("ville", String.class),
	      new ObjectStreamField("rue", String.class),
	      new ObjectStreamField("numero", int.class),
	      new ObjectStreamField("adressePersonnelle", boolean.class)};
	
	private String ville;
	private String rue;
	private int numero;
	private boolean adressePersonnelle;
	
	public  Adresse() {
		System.out.println("Constructeur par d�faut de l'adresse");
	}
	
	public  Adresse(String v, String r, int n, boolean a) {
		ville = v;
		rue = r;
		numero = n;
		adressePersonnelle = a;
	}
	
	public String getVille() {
		return ville;
	}
	public void setVille(String ville) {
		this.ville = ville;
	}
	public String getRue() {
		return rue;
	}
	public void setRue(String rue) {
		this.rue = rue;
	}
	public int getNumero() {
		return numero;
	}
	public void setNumero(int numero) {
		this.numero = numero;
	}
	public boolean isAdressePersonnelle() {
		return adressePersonnelle;
	}
	public void setAdressePersonnelle(boolean adressePersonnelle) {
		this.adressePersonnelle = adressePersonnelle;
	}
	

}
