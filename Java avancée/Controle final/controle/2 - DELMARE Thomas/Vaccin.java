package controle.ex2;

import java.util.Date;

public class Vaccin { 
	
	public enum Efficacite {Forte, Normale, Faible}

	private Date dateInjection;
	
	private String nomVaccin;
	
	private Efficacite efficacite;
	
	public Vaccin() {
		System.out.println("Constructeur par défaut de vaccin");
	}
	
	public Vaccin(Date dateInjection, String nomVaccin) {
		super();
		this.dateInjection = dateInjection;
		this.nomVaccin = nomVaccin;
		this.efficacite = Efficacite.Normale;
	}
	
	
	public Date getDateInjection() {
		return dateInjection;
	}
	public void setDateInjection(Date dateInjection) {
		this.dateInjection = dateInjection;
	}
	public String getNomVaccin() {
		return nomVaccin;
	}
	public void setNomVaccin(String nomVaccin) {
		this.nomVaccin = nomVaccin;
	}
	public Efficacite getEfficacite() {
		return efficacite;
	}
	public void setEfficacite(Efficacite e) {
		this.efficacite = e;
	}
}
