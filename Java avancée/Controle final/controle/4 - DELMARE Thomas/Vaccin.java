package controle.ex4;

import java.io.Serializable;
import java.util.Date;

public class Vaccin implements Serializable { 
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public enum Efficacite {Forte, Normale, Faible}

	private Date dateInjection;
	
	transient private String nomVaccin;
	
	private Efficacite efficacite;
	
	public Vaccin() {
		System.out.println("Constructeur par d?faut de vaccin");
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
