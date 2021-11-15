
/**
 * @author Michel Buffa + modification Philippe Lahire
 * Inspiré par la classe Reflectiontest.java de
 * Cay S. Horstmann & Gary Cornell, publiée dans le livre Core Java, Sun Press
 */

import java.lang.reflect.*;
import java.io.*;

public class AnalyseurDeClasse {

  public static void analyseClasse(String nomClasse) throws ClassNotFoundException {
    // Récupération d'un objet de type Class correspondant au nom passé en
    // paramétres
    Class cl = getClasse(nomClasse);
    
    afficheEnTeteClasse(cl);

    System.out.println();
    afficheInnerClasses(cl);

    System.out.println();
    afficheAttributs(cl);

    System.out.println();
    afficheConstructeurs(cl);

    System.out.println();
    afficheMethodes(cl);

    // L'accolade fermante de fin de classe !
    System.out.println("}");
  }

  /** Retourne la classe dont le nom est passé en paramétre */
  public static Class getClasse(String nomClasse) throws ClassNotFoundException {
    try {
      Class c = Class.forName(nomClasse);
      System.out.println("Classe trouvée !");
      return c;
    }
    catch(ClassNotFoundException cnfe){
      System.out.println("Classe pas trouvée : "+cnfe.getMessage());
      return null;
    }
  }

  /**
   * Cette méthode affiche par ex "public class C1 extends C2 implements I1, I2 {"
   */
  public static void afficheEnTeteClasse(Class cl) {
    // Affichage du modifier et du nom de la classe
    String finalChar = "";
    String modifier = getModifier(cl.getModifiers());
    String className = cl.getName();
    String temp = modifier + " class " + className;
    finalChar += temp;
  
    // CODE A ECRIRE


    // Récupération de la superclasse si elle existe (null si cl est le type Object)
    Class supercl = cl.getSuperclass();

        // On ecrit le "extends " que si la superclasse est non nulle et différente de
        // Object
        if(supercl != null || supercl.getClass().getName() != "Object"){
          
        }
        // CODE A ECRIRE

        // Affichage des interfaces que la classe implemente
        // CODE A ECRIRE

        // Accolade ouvrante de début de classe
        System.out.print(" {\n");

      System.out.println(finalChar);
  }

  /**
   * Cette méthode affiche les classes imbriquées statiques ou pas A faire aprés
   * avoir fait fonctionner le reste
   */
  public static void afficheInnerClasses(Class cl) {
    // CODE A ECRIRE
  }

  public static void afficheAttributs(Class cl) {
    // CODE A ECRIRE
  }

  public static void afficheConstructeurs(Class cl) {
    // CODE A ECRIRE
    System.out.println("{}");

  }

  public static void afficheMethodes(Class cl) {
    // CODE A ECRIRE
    System.out.println("{}");
  }

  public static String getModifier(int modifierInt){
    String result = "";
    
    if (Modifier.isPublic(modifierInt)){
      result += " public";
    }      
    if (Modifier.isPrivate(modifierInt)){
      result += " private";
    }     
    if (Modifier.isProtected(modifierInt)){
      result += " protected";
    }   
    if (Modifier.isStatic(modifierInt)){
      result += " static";
    }      
    if (Modifier.isAbstract(modifierInt)){
      result += " abstract";
    }    
    if (Modifier.isFinal(modifierInt)) {
      result += " final";
    }       
    if (Modifier.isNative(modifierInt)){
      result += " native";
    }      
    if (Modifier.isTransient(modifierInt)){
      result += " transient";
    }   
    if (Modifier.isSynchronized(modifierInt)){
      result += " synchronized";
    }

    return result;
  }

  /* Facultatif au moins dans un premier temps */
  /*
   * tester le programme en passant un nom de classe complet en paramétre Modifier
   * la méthode "main" en conséquence
   */
  public static String litChaineAuClavier() throws IOException {
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    return br.readLine();
  }

  public static void main(String[] args) {
    boolean ok = false;

    while (!ok) {
      try {
        System.out.print("Entrez le nom d'une classe (ex : java.util.Date): ");
        String nomClasse = litChaineAuClavier();

        analyseClasse(nomClasse);
        ok = true;
      } catch (ClassNotFoundException e) {
        System.out.println("Classe non trouvée.");
      } catch (IOException e) {
        System.out.println("Erreur d'E/S!");
      }
    }
  }
}
