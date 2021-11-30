package controle.ex1;

import java.util.ArrayList;
import java.util.function.Consumer;

import controle.ex1.PersonneVaccinee;

public class PersonneVaccinee extends Personne {

	ArrayList<Vaccin> vaccins;

	public PersonneVaccinee() {
		super();
		vaccins = new ArrayList<Vaccin>();
	}

	public PersonneVaccinee(String nom, String prenom, int age) {
		super(nom, prenom, age);
		vaccins = new ArrayList<Vaccin>();
	}

	public void addVaccin(Vaccin v) {
		vaccins.add(v);
	}

	public void ajusterEfficacite() {
		System.out.println("Execution de ajusterEfficacite");

		int oldAge = this.getAge();
		
		this.vaccins.forEach(new Consumer<Vaccin>() {
			public void accept(Vaccin v) {

				if (oldAge>= 65) {
					for (int i = 0; i < vaccins.size(); i++) {
						vaccins.get(i).setEfficacite(Vaccin.Efficacite.Faible);
						System.out.println("La nouvelle efficacité est de " + vaccins.get(i).getEfficacite());
					}
				}
				if (oldAge <= 40) {
					for (int i = 0; i < vaccins.size(); i++) {
						vaccins.get(i).setEfficacite(Vaccin.Efficacite.Forte);
						System.out.println("La nouvelle efficacité est de " + vaccins.get(i).getEfficacite());
					}
				}

			}
		});
	}

	public void display() {
		System.out.println("Execution de display");
		System.out.println(super.toString());
		for (int i = 0; i < vaccins.size(); i++) {
			System.out.println("Vaccin " + vaccins.get(i).getNomVaccin() + "- Date injection "
					+ vaccins.get(i).getDateInjection() + " - efficacitï¿½: " + vaccins.get(i).getEfficacite());
		}
	}

}
