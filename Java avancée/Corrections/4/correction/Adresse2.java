package miage.TDPersistance.exemple;

import java.io.Externalizable;
import java.io.IOException;

public class Adresse2 implements Externalizable {
	
	/**
	 * 
	 */
	//private static final long serialVersionUID = 123L;
	
	
	private String ville;
	private String rue;
	private int numero;
	private boolean adressePersonnelle;
	
	public  Adresse2() {
		System.out.println("Constructeur par défaut de l'adresse");
	}
	
	public  Adresse2(String v, String r, int n, boolean a) {
		ville = v;
		rue = r;
		numero = n;
		adressePersonnelle = a;
	}
	
	//solution exercice 4a
	public void writeExternal(java.io.ObjectOutput out)    
            throws IOException {
       out.writeObject(this.ville);
       out.writeObject(this.rue);
       out.writeInt(this.numero);
       out.writeBoolean(this.adressePersonnelle);
    }

	//solution exercice 4a
   public void readExternal(java.io.ObjectInput in)
           throws IOException, ClassNotFoundException {
      this.ville = (String) in.readObject();
      this.rue = (String) in.readObject();
      this.numero = in.readInt();
      this.adressePersonnelle = in.readBoolean();
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
