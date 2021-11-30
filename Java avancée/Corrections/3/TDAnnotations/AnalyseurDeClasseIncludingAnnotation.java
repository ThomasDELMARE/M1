/**
 * @version 1.1 (inclus: le traitement des annotations)
 * @author Michel Buffa et Philippe Lahire 
 */

package miage.TDAnnotations;


import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Scanner;

public class AnalyseurDeClasseIncludingAnnotation {

  public static void analyseClasse(String nomClasse) throws ClassNotFoundException {
		// Récupération d'un objet de type Class correspondant au nom passé en
		// paramètres
    Class<?> cl = getClasse(nomClasse);

    afficheEnTeteClasse(cl);

    System.out.println("// Champs");
    afficheAttributs(cl);

    System.out.println("\n// Constructeurs");
    afficheConstructeurs(cl);

    System.out.println("\n// Méthodes");
    afficheMethodes(cl);

    // L'accolade fermante de fin de classe !
    System.out.println("}");
  }


  /** Retourne la classe dont le nom est passé en paramètre */
  public static Class<?> getClasse(String nomClasse) throws ClassNotFoundException {
	  return Class.forName(nomClasse);
  }

  /** Cette mÃ©thode affiche par ex "public class Toto extends Tata implements Titi, Tutu {" */
  public static void afficheEnTeteClasse(Class<?> cl) {
	  
		Annotation[] classAnnotations = cl.getAnnotations();
		if(classAnnotations.length>0) {
		for (int i = 0; i < classAnnotations.length; i++) 
			System.out.println(classAnnotations[i].toString());
		}
    //  Affichage du modifier et du nom de la classe
	 System.out.print(Modifier.toString(cl.getModifiers()));
	 if (cl.isAnnotation()) System.out.print(" @interface ");
	 else if(cl.isInterface()) System.out.print(" interface ");
	 else if (cl.isEnum()) System.out.print(" enum ");
	 //else if (cl.isAnnotation()) System.out.print(" @interface ");
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
    System.out.println(" {");
  }

  public static void afficheAttributs(Class<?> cl) {
	  Field[] fields = cl.getDeclaredFields();
	  for(Field field : fields) {
		  // Ajout pour inclure les annotations
		  Annotation[] fieldAnnotations = field.getDeclaredAnnotations();
		  //if(fieldAnnotations.length>0) {
				for (int i = 0; i < fieldAnnotations.length; i++) {
					System.out.print("  ");
					System.out.println(fieldAnnotations[i].toString());
				}
		  //}
		  System.out.print("  ");
		  System.out.print(Modifier.toString(field.getModifiers()));
		  System.out.print(" ");
		  afficheType(field.getType());
		  System.out.print(" ");
		  System.out.print(field.getName());
		  System.out.println(";");
	  }
  }
  private static void afficheType(Class<?> cl) {
	  if(!cl.isArray())
		  System.out.print(cl.getCanonicalName());
	  else {
		  afficheType(cl.getComponentType());
		  System.out.print("[]");
	  }
  }

  public static void afficheConstructeurs(Class<?> cl) {
	  Constructor<?>[] constructors = cl.getDeclaredConstructors();
	  for(Constructor<?> c : constructors) {
		  // Ajout pour inclure les annotations
		  Annotation[] constructorAnnotations = c.getDeclaredAnnotations();
		  if(constructorAnnotations.length>0) {
				for (int i = 0; i < constructorAnnotations.length; i++) {
					System.out.print("  ");
					System.out.println(constructorAnnotations[i].toString());
				}
		  }
		  System.out.print("  ");
		  System.out.print(Modifier.toString(c.getModifiers()));
		  System.out.print(" ");
		  System.out.print(cl.getCanonicalName());
		  afficheParams(c.getParameterTypes());
	  }
  }
  
  private static void afficheParams(Class<?>[] params) {
	  System.out.print("(");
	  String sep = "";
	  for(Class<?> c : params) {
		  // Ajout pour inclure les annotations
		  Annotation[] parameterAnnotations = c.getDeclaredAnnotations();
		  if(parameterAnnotations.length>0) {
				for (int i = 0; i < parameterAnnotations.length; i++) {
					System.out.print("  ");
					System.out.println(parameterAnnotations[i].toString());
				}
		  }
		  
		  System.out.print(sep);
		  afficheType(c);
		  sep = ", ";
	  }
	  System.out.println(");");	  
  }

  public static void afficheMethodes(Class<?> cl) {
	  Method[] methods = cl.getDeclaredMethods();
	  for(Method m : methods) {
		  // Ajout pour inclure les annotations
		  Annotation[] methodAnnotations = m.getDeclaredAnnotations();
		  if(methodAnnotations.length>0) {
				for (int i = 0; i < methodAnnotations.length; i++) {
					System.out.print("  ");
					System.out.println(methodAnnotations[i].toString());
				}
		  }
		  System.out.print("  ");
		  System.out.print(Modifier.toString(m.getModifiers()));
		  System.out.print(" ");
		  afficheType(m.getReturnType());
		  System.out.print(" ");
		  System.out.print(m.getName());
		  afficheParams(m.getParameterTypes());
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
        String nomClasse = "miage.TDAnnotations.AnnotedClass";
        analyseClasse(nomClasse);

        ok = true;
      } catch(ClassNotFoundException e) {
        System.out.println("Classe non trouvÃ©e.");
//      }catch(IOException e) {
//        System.out.println("Erreur d'E/S!");
     }
    }
  }
}