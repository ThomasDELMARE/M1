package miage.exemple;

public class Adresse {

	private String ville;
	private String rue;
	private int numero;
	
	public  Adresse(String v, String r, int n) {
		ville = v;
		rue = r;
		numero = n;
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
	

}
