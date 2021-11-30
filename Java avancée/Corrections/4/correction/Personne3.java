package miage.TDPersistance.exemple;


import java.io.IOException;

// Solution exercice 4b
public class Personne3  {
	
	private String nom;
	private String prenom;
	private int age;
	private Adresse2 adresse;
	//public String prenom2;
	
	public Personne3() {
		System.out.println("Constructeur par défaut de personne 3");
		//prenom2 = "nouveau";
	}
	
	public Personne3 (String n, String p, int a) {
		nom = n;
		prenom = p;
		age = a;
	}
	
//	public void writeExternalPersonne (java.io.ObjectOutput out)    
//            throws IOException {
//       out.writeObject(this.nom);
//       out.writeObject(this.prenom);
//       out.writeInt(this.age);
//       out.writeObject(this.adresse);
//    }
//
//   public void readExternalPersonne (java.io.ObjectInput in)
//           throws IOException, ClassNotFoundException {
//      this.nom = (String) in.readObject();
//      this.prenom = (String) in.readObject();
//      this.age = in.readInt();
//      this.adresse = (Adresse2) in.readObject();
//    }

	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		out.writeObject(this.nom);
		out.writeObject(this.prenom);
		out.writeInt(this.age);
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		this.nom = (String) in.readObject();
		this.prenom = (String) in.readObject();
		this.age = in.readInt();
	}
 
	public String getNom() {
		return nom;
	}
	public void setNom(String nom) {
		this.nom = nom;
	}
	public String getPrenom() {
		return prenom;
	}
	public void setPrenom(String prenom) {
		this.prenom = prenom;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public Adresse2 getAdresse() {
		return adresse;
	}
	public void setAdresse(Adresse2 adresse) {
		this.adresse = adresse;
	}

}
