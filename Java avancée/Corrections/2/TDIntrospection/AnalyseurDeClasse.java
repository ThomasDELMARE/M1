/**
 * @version 1.00 20 Avril 2021
 * @author Michel Buffa et Philippe Lahire
 */


package miage.TDIntrospection;


import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Scanner;

public class AnalyseurDeClasse {

  public static void analyseClasse(String nomClasse, String decalage) throws ClassNotFoundException {
		// Récupération d'un objet de type Class correspondant au nom passé en
		// paramètres
    Class<?> cl = getClasse(nomClasse);

    afficheEnTeteClasse(cl, decalage);
    
    System.out.println(decalage + "// Inner Classes");
    afficheInnerClasses(cl, decalage);

    System.out.println(decalage + "// Champs");
    afficheAttributs(cl, decalage);

    System.out.println("\n" + decalage + "// Constructeurs");
    afficheConstructeurs(cl, decalage);

    System.out.println(decalage + "\n" + decalage + "// Méthodes");
    afficheMethodes(cl, decalage);

    // L'accolade fermante de fin de classe !
    System.out.println(decalage + "}");
  }


  /** Retourne la classe dont le nom est passé en paramètre */
  public static Class<?> getClasse(String nomClasse) throws ClassNotFoundException {
	  return Class.forName(nomClasse);
  }

  /** Cette méthode affiche par ex "public class Toto extends Tata implements Titi, Tutu {" */
  public static void afficheEnTeteClasse(Class<?> cl, String decalage) {
    //  Affichage du modifier et du nom de la classe
	 System.out.print(decalage + Modifier.toString(cl.getModifiers()));
	 if (cl.isAnnotation()) System.out.print(" @interface ");
	 else if(cl.isInterface()) System.out.print(" interface ");
	 else if (cl.isEnum()) System.out.print(" enum ");
	 // L'ordre est important car une annotation est aussi une interface: else if (cl.isAnnotation()) System.out.print(" @interface ");
	 else System.out.print(" class ");
	 
	 System.out.print(cl.getCanonicalName());
	  
   // Récupération de la superclasse si elle existe (null si cl est le type Object)
    Class<?> supercl = cl.getSuperclass();

    // On ecrit le "extends " que si la superclasse est non nulle et
    // différente de Object
    if(supercl!=null && supercl!=Object.class)
    	System.out.print(" extends "+supercl.getCanonicalName());
    // CODE A ECRIRE

    // Affichage des interfaces que la classe implÃ©mente
    Class<?>[] interfaces = cl.getInterfaces();
    if(interfaces.length>0) {
    	System.out.print(" implements "+interfaces[0].getCanonicalName());
    	for(int i = 1; i<interfaces.length; i++)
    		System.out.print(", "+interfaces[i].getCanonicalName());
    }

    // Enfin, l'accolade ouvrante !
    System.out.println(decalage + " {");
  }

  public static void afficheInnerClasses (Class<?> cl, String decalage) throws ClassNotFoundException {
	  Class<?>[] innerClasses = cl.getDeclaredClasses();
	  for(Class<?> innerClass : innerClasses) {
		  analyseClasse(innerClass.getName(), "   ");
	  }
  }
  
  public static void afficheAttributs(Class<?> cl, String decalage) {
	  Field[] fields = cl.getDeclaredFields();
	  for(Field field : fields) {
		  System.out.print(decalage + "  ");
		  System.out.print(Modifier.toString(field.getModifiers()));
		  System.out.print(" ");
		  afficheType(field.getType(), decalage);
		  System.out.print(" ");
		  System.out.print(field.getName());
		  System.out.println(";");
	  }
  }
  private static void afficheType(Class<?> cl, String decalage) {
	  if(!cl.isArray())
		  System.out.print(cl.getCanonicalName());
	  else {
		  afficheType(cl.getComponentType(), decalage);
		  System.out.print("[]");
	  }
  }

  public static void afficheConstructeurs(Class<?> cl, String decalage) {
	  Constructor<?>[] constructors = cl.getDeclaredConstructors();
	  for(Constructor<?> c : constructors) {
		  System.out.print(decalage + "  ");
		  System.out.print(Modifier.toString(c.getModifiers()));
		  System.out.print(" ");
		  System.out.print(cl.getCanonicalName());
		  afficheParams(c.getParameterTypes(), decalage);
	  }
  }
  
  private static void afficheParams(Class<?>[] params, String decalage) {
	  System.out.print("(");
	  String sep = "";
	  for(Class<?> c : params) {
		  System.out.print(sep);
		  afficheType(c, decalage);
		  sep = ", ";
	  }
	  System.out.println(");");	  
  }

  public static void afficheMethodes(Class<?> cl, String decalage) {
	  Method[] methods = cl.getDeclaredMethods();
	  for(Method m : methods) {
		  System.out.print(decalage + "  ");
		  System.out.print(Modifier.toString(m.getModifiers()));
		  System.out.print(" ");
		  afficheType(m.getReturnType(), decalage);
		  System.out.print(" ");
		  System.out.print(m.getName());
		  afficheParams(m.getParameterTypes(), decalage);
	  }
  }

  public static String litChaineAuClavier() throws IOException {
	  Scanner sc = new Scanner(System.in);
	  String line = sc.nextLine();
	  sc.close();
      return line;
  }

  public static void main(String[] args) {
    boolean ok = false;

    while(!ok) {
      try {
        //System.out.print("Entrez le nom d'une classe (ex : java.util.Date): ");
        //String nomClasse = litChaineAuClavier();

        //analyseClasse(nomClasse, "");
        analyseClasse(args[0], "");

        ok = true;
      } catch(ClassNotFoundException e) {
        System.out.println("Classe non trouvÃ©e.");
      }
      //catch(IOException e) {
       // System.out.println("Erreur d'E/S!");
      //}
    }
  }
}