package controle.ex3;
import java.util.ArrayList;
import java.util.Date;

import controle.ex3.PersonneVaccinee;

public class ContainerDePersonnes {
	ArrayList<PersonneVaccinee> personnesVacinnees;

    public static void main(String[] args) {
    	
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
	}
}
