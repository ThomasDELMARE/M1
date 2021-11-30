package controle.ex4;
import java.util.ArrayList;
import java.util.Date;
import java.io.Serializable;
import java.io.ObjectStreamField;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

import controle.ex4.PersonneVaccinee;

public class ContainerDePersonnes implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	ArrayList<PersonneVaccinee> personnesVacinnees;
	
	public ContainerDePersonnes() {
		
	}
	
	public void sauverPersonnes(String nomfichier) throws IOException {
		ObjectOutputStream personnesVaccinnees;
		try {
		     FileOutputStream support = new FileOutputStream(nomfichier);
		     personnesVaccinnees = new ObjectOutputStream(support);
		     personnesVaccinnees.writeObject(personnesVacinnees);
		     support.flush();
		     support.close();
		     System.out.println("Save des personnes faite");
		} catch(java.io.IOException e) {e.printStackTrace();};
	}
	
	
	@SuppressWarnings("unchecked")
	public void restaurerPersonnes(String nomfichier) {
		ObjectInputStream lecteur = null;
		   try {
		           FileInputStream content = new FileInputStream(nomfichier);
		           lecteur = new ObjectInputStream(content);
		           personnesVacinnees = (ArrayList<PersonneVaccinee>) lecteur.readObject();
		           lecteur.close();
		           System.out.println("Récupération des données faites !");
		           System.out.println(personnesVacinnees);
		           // le nom du vaccin n'a pas été sauvé !
		           System.out.println(personnesVacinnees.get(0).vaccins.get(0).getNomVaccin());
		           System.out.println(personnesVacinnees.get(0).vaccins.get(0).getEfficacite());
		           
			} catch(java.io.IOException | ClassNotFoundException e) {e.printStackTrace();};
	}
	
	public void setPersonnesVacinnees(ArrayList<PersonneVaccinee> newPersonnesVacinnees) {
		this.personnesVacinnees = newPersonnesVacinnees;
	}

    public static void main(String[] args) throws IOException {
    	
        PersonneVaccinee personne1 = new PersonneVaccinee("Thomas", "DELMARE", 65);
        PersonneVaccinee personne2 = new PersonneVaccinee("Marie-Celeste", "SANCHEZ", 23);
        PersonneVaccinee personne3 = new PersonneVaccinee("Nicolas", "Parizet", 45);
        personne1.addVaccin(new Vaccin(new Date(),"Astra"));
        personne2.addVaccin(new Vaccin(new Date(),"Astro"));
        personne3.addVaccin(new Vaccin(new Date(),"Astra"));
        
    	ArrayList<PersonneVaccinee> personnesVacinnees = new ArrayList<PersonneVaccinee>();
    	
        personnesVacinnees.add(personne1);
        personnesVacinnees.add(personne2);
        personnesVacinnees.add(personne3);

        for(int i = 0 ; i<personnesVacinnees.size(); i++){
            personnesVacinnees.get(i).ajusterEfficacite();
        }
        
        ContainerDePersonnes container = new ContainerDePersonnes();
        container.setPersonnesVacinnees(personnesVacinnees);       
        container.sauverPersonnes("test.txt");
        container.restaurerPersonnes("test.txt");
	}
}
