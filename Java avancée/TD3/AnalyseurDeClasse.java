
/**
 * @author Michel Buffa + modification Philippe Lahire
 * Inspiré par la classe Reflectiontest.java de
 * Cay S. Horstmann & Gary Cornell, publiée dans le livre Core Java, Sun Press
 */

import java.lang.annotation.Annotation;
import java.lang.annotation.ElementType;
import java.lang.reflect.*;
import java.util.ArrayList;

import miageAdvanced.etat;

import java.io.*;

@miageBasics(nom = "DELMARE", prenom = "Thomas", annee = 2020, module = "Java avancée", numSeance = 3)
public class AnalyseurDeClasse {

  @miageBasics(nom = "DELMARE", prenom = "Thomas", annee = 2020, module = "Java avancée", numSeance = 3)
  public AnalyseurDeClasse() {
  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_PARTIEL, etatTests = false, etatAutomatisation = false)
  public static void analyseClasse(String nomClasse) throws ClassNotFoundException {
    // Récupération d'un objet de type Class correspondant au nom passé en
    // paramétres
    Class cl = getClasse(nomClasse);
    afficherProprietesClasse(cl);
  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.VERSION_FINALISEEE, etatTests = false, etatAutomatisation = false)
  public static void afficherProprietesClasse(Class cl) {
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
  @miageBasics(nom = "DELMARE", prenom = "Thomas", annee = 2020, module = "Java avancée", numSeance = 1)
  public static Class getClasse(String nomClasse) throws ClassNotFoundException {
    try {
      Class c = Class.forName(nomClasse);
      System.out.println("Classe trouvée !");
      return c;
    } catch (ClassNotFoundException cnfe) {
      System.out.println("Classe pas trouvée : " + cnfe.getMessage());
      return null;
    }
  }

  /**
   * Cette méthode affiche par ex "public class C1 extends C2 implements I1, I2 {"
   */
  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_PARTIEL, etatTests = false, etatAutomatisation = false)
  public static void afficheEnTeteClasse(Class cl) {
    // Affichage du modifier et du nom de la classe
    String finalChar = "";
    String modifier = getModifier(cl.getModifiers());
    String className = cl.getName();
    String temp = modifier + " class " + className;
    finalChar += temp;

    // Récupération de la superclasse si elle existe (null si cl est le type Object)
    Class supercl = cl.getSuperclass();
    Class[] interfaces = cl.getInterfaces();

    // On ecrit le "extends " que si la superclasse est non nulle et différente de
    // Object
    if (supercl != null && supercl.getClass().getName() != "Object") {
      finalChar += " extends " + supercl.getName();
    }

    System.out.println(interfaces[0]);

    if (interfaces.length > 0) {
      finalChar += " implements ";
    }

    // Affichage des interfaces que la classe implemente
    for (int i = 0; i < interfaces.length; i++) {
      if (i - 1 != interfaces.length && i != 0) {
        finalChar += ", ";
      }
      finalChar += interfaces[i];
    }

    // Accolade ouvrante de début de classe
    System.out.println(finalChar);
    System.out.print(" {\n");
  }

  /**
   * Cette méthode affiche les classes imbriquées statiques ou pas A faire aprés
   * avoir fait fonctionner le reste
   */
  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_COMPLET, etatTests = false, etatAutomatisation = false)
  public static void afficheInnerClasses(Class cl) {
    Class[] classes = cl.getDeclaredClasses();

    System.out.println("{\n");

    if (classes.length == 0) {
      System.out.println("Pas d'inner classe trouvées");
    }

    for (int i = 0; i < classes.length; i++) {
      Annotation[] temp = classes[i].getAnnotations();

      System.out.println("Class = " + classes[i].getName());

      if (temp.length > 0) {
        System.out.println("Liste des annotations disponibles : \n");

        for (int j = 0; j < temp.length; j++) {
          System.out.println(temp[j] + "\n");
        }
      }

    }
    System.out.println("}");

  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_PARTIEL, etatTests = false, etatAutomatisation = false)
  public static void afficheAttributs(Class cl) {
    Field[] result = cl.getDeclaredFields();

    System.out.println("{\n");

    if (result.length == 0) {
      System.out.println("Pas d'attributs trouvés");
    }

    for (int i = 0; i < result.length; i++) {
      Annotation[] temp = result[i].getAnnotations();

      System.out.println("L'attribut est : " + result[i] + ";\n");

      if (temp.length > 0) {
        System.out.println("Liste des annotations disponibles : \n");

        for (int j = 0; j < temp.length; j++) {
          System.out.println(temp[j] + "\n");
        }
      }
    }

    System.out.println("}");
  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_COMPLET, etatTests = false, etatAutomatisation = false)
  public static void afficheConstructeurs(Class cl) {
    Constructor[] result = cl.getConstructors();

    System.out.println("{\n");

    if (result.length == 0) {
      System.out.println("Pas de constructeurs trouvés");
    }

    for (int i = 0; i < result.length; i++) {
      System.out.println("Le constructeur est : " + result[i] + ";\n");

      Annotation[] temp = result[i].getAnnotations();

      if (temp.length > 0) {
        System.out.println("Liste des annotations disponibles : \n");

        for (int j = 0; j < temp.length; j++) {
          System.out.println(temp[j] + "\n");
        }
      }
    }

    System.out.println("}");

  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_COMPLET, etatTests = true, etatAutomatisation = false)
  public static void afficheMethodes(Class cl) {
    Method[] result = cl.getMethods();

    System.out.println("{\n");

    if (result.length == 0) {
      System.out.println("Pas de méthodes trouvées");
    }

    for (int i = 0; i < result.length; i++) {

      System.out.println("La méthode est : " + result[i] + ";\n");

      Annotation[] temp = result[i].getAnnotations();

      if (temp.length > 0) {
        System.out.println("Liste des annotations disponibles : \n");

        for (int j = 0; j < temp.length; j++) {
          System.out.println(temp[j] + "\n");
        }
      }
    }

    System.out.println("}");
  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_PARTIEL, etatTests = false, etatAutomatisation = false)
  public static String getModifier(int modifierInt) {
    String result = "";

    if (Modifier.isPublic(modifierInt)) {
      result += " public";
    }
    if (Modifier.isPrivate(modifierInt)) {
      result += " private";
    }
    if (Modifier.isProtected(modifierInt)) {
      result += " protected";
    }
    if (Modifier.isStatic(modifierInt)) {
      result += " static";
    }
    if (Modifier.isAbstract(modifierInt)) {
      result += " abstract";
    }
    if (Modifier.isFinal(modifierInt)) {
      result += " final";
    }
    if (Modifier.isNative(modifierInt)) {
      result += " native";
    }
    if (Modifier.isTransient(modifierInt)) {
      result += " transient";
    }
    if (Modifier.isSynchronized(modifierInt)) {
      result += " synchronized";
    }

    return result;
  }

  // ANNOTATIONS LISTING

  public void listerDonneesAnnotationsBasics(miageBasics[] annotationsList) {
    this.annotationsAnnees2020(annotationsList);
    this.champsEtMethodesAnnees2020(annotationsList);
    this.champsCreesPendantSeance1Et2(annotationsList);
  }

  public void listerDonneesAnnotationsAdvanced(miageAdvanced[] annotationsList) {
    this.methodesDe2020NonFinalisees(annotationsList);
    this.calculerRatios(annotationsList);
  }

  public void calculerRatios(miageAdvanced[] annotationsList) {
    this.ratioMethodeFinalisesRealisees(annotationsList, 2020);
    this.ratioDraftParielMethodesRealisees(annotationsList, 2020);
    this.ratioMethodesGenereesMethodesRealisees(annotationsList, 2020);
    this.ratioMethodesFinaliseesMethodesNonGenerees(annotationsList, 2020);
    this.ratioMethodesTesteesMethodesNonGenerees(annotationsList, 2020);
  }

  public void annotationsAnnees2020(miageBasics[] annotationsList) {
    System.out.println("Liste des classes faites en 2020.");

    for (int i = 0; i < annotationsList.length; i++) {
      // FILTRER SELON LIEN AVEC L ANNOTATION (classe)
      if (annotationsList[i].annee() == 2020) {
        System.out.println(annotationsList[i].toString());
      }
    }
  }

  public void champsEtMethodesAnnees2020(miageBasics[] annotationsList) {
    System.out.println("Liste des champs et méthodes faites en 2020.");

    for (int i = 0; i < annotationsList.length; i++) {
      // FILTRER SELON LIEN AVEC L ANNOTATION (METHODES, CHAMPS)
      if (annotationsList[i].annee() == 2020) {
        System.out.println(annotationsList[i].toString());
      }
    }
  }

  public void champsCreesPendantSeance1Et2(miageBasics[] annotationsList) {
    System.out.println("Liste des annotations créées pendant la séance 1 et 2.");

    for (int i = 0; i < annotationsList.length; i++) {
      if (annotationsList[i].numSeance() == 1 || annotationsList[i].numSeance() == 2) {
        System.out.println(annotationsList[i].toString());
      }
    }
  }

  public void methodesDe2020NonFinalisees(miageAdvanced[] annotationsList) {
    System.out.println("Liste des méthodes non finalisées et créées en 2020.");

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatCompletude() == etat.DRAFT_PARTIEL) {
        System.out.println(annotationsList[i].toString());
      }
    }
  }

  public void ratioMethodeFinalisesRealisees(miageAdvanced[] annotationsList, int anneeUniversitaire) {
    System.out.println("Ratio entre les methodes finalisées et réalisées.");

    ArrayList<miageAdvanced> methodesFinalises = new ArrayList<miageAdvanced>();

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatCompletude() == etat.VERSION_FINALISEEE) {
        methodesFinalises.add(annotationsList[i]);
      }
    }

    System.out.println(methodesFinalises.size() / annotationsList.length);
  }

  public void ratioDraftParielMethodesRealisees(miageAdvanced[] annotationsList, int anneeUniversitaire) {
    System.out.println("Ratio entre les methodes partiel et réalisées.");

    ArrayList<miageAdvanced> methodesPartiel = new ArrayList<miageAdvanced>();

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatCompletude() == etat.DRAFT_PARTIEL) {
        methodesPartiel.add(annotationsList[i]);
      }
    }

    System.out.println(methodesPartiel.size() / annotationsList.length);
  }

  public void ratioMethodesGenereesMethodesRealisees(miageAdvanced[] annotationsList, int anneeUniversitaire) {
    System.out.println("Ratio entre les methodes génerées et réalisées.");

    ArrayList<miageAdvanced> methodesGenereees = new ArrayList<miageAdvanced>();

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatCompletude() == etat.DRAFT_PARTIEL) {
        methodesGenereees.add(annotationsList[i]);
      }
    }

    System.out.println(methodesGenereees.size() / annotationsList.length);
  }

  public void ratioMethodesFinaliseesMethodesNonGenerees(miageAdvanced[] annotationsList, int anneeUniversitaire) {
    System.out.println("Ratio entre les methodes finalisées et non generees.");

    ArrayList<miageAdvanced> methodesFinalisees = new ArrayList<miageAdvanced>();
    ArrayList<miageAdvanced> methodesNonGenereees = new ArrayList<miageAdvanced>();

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatCompletude() == etat.VERSION_FINALISEEE) {
        methodesFinalisees.add(annotationsList[i]);
      }
      else if (annotationsList[i].etatCompletude() == etat.DRAFT_PARTIEL) {
        methodesNonGenereees.add(annotationsList[i]);
      }
    }

    System.out.println(methodesFinalisees.size() / methodesNonGenereees.size());
  }

  public void ratioMethodesTesteesMethodesNonGenerees(miageAdvanced[] annotationsList, int anneeUniversitaire) {
    System.out.println("Ratio des méthodes testées / nombre de méthodes non générées");

    ArrayList<miageAdvanced> methodesTestees = new ArrayList<miageAdvanced>();
    ArrayList<miageAdvanced> methodesNonGenereees = new ArrayList<miageAdvanced>();

    for (int i = 0; i < annotationsList.length; i++) {
      // IL FAUT AJOUTER L ANNEEE
      if (annotationsList[i].etatTests() == true) {
        methodesTestees.add(annotationsList[i]);
      }
      else if (annotationsList[i].etatCompletude() == etat.DRAFT_PARTIEL) {
        methodesNonGenereees.add(annotationsList[i]);
      }
    }

    System.out.println(methodesTestees.size() / methodesNonGenereees.size());
  }

  // UTILS

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_PARTIEL, etatTests = false, etatAutomatisation = false)
  public static String litChaineAuClavier() throws IOException {
    BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
    return br.readLine();
  }

  @miageAdvanced(etatCompletude = miageAdvanced.etat.VERSION_FINALISEEE, etatQualite = miageAdvanced.etat.DRAFT_COMPLET, etatTests = false, etatAutomatisation = false)
  public void toString(Class cl) {
    Class[] innerClasses = cl.getDeclaredClasses();

    for (int i = 0; i < innerClasses.length; i++) {
      afficherProprietesClasse(innerClasses[i]);
    }
  }

  @miageBasics(nom = "DELMARE", prenom = "Thomas", annee = 2021, module = "Java avancée", numSeance = 1)
  public void toString(Class cl, int profondeur) {
    Class[] innerClasses = cl.getDeclaredClasses();
    int classesRestantes = profondeur;

    while (classesRestantes < profondeur) {
      afficherProprietesClasse(innerClasses[-1]);
      classesRestantes -= 1;
    }
  }

  // MAIN

  @miageBasics(nom = "DELMARE", prenom = "Thomas", annee = 2021, module = "Java avancée", numSeance = 1)
  public static void main(String[] args) {
    boolean ok = false;

    while (!ok) {
      miageBasics[] currentBasicsAnnotations = AnalyseurDeClasse.class.getAnnotationsByType(miageBasics.class);
      miageAdvanced[] currentAdvancedAnnotations = AnalyseurDeClasse.class.getAnnotationsByType(miageAdvanced.class);

      System.out.println(currentAdvancedAnnotations.length);
      System.out.println(currentBasicsAnnotations.length);

      for (int i = 0; i < currentBasicsAnnotations.length; i++) {
        System.out.println(currentBasicsAnnotations[i].toString());
      }

      for (int i = 0; i < currentAdvancedAnnotations.length; i++) {
        System.out.println(currentAdvancedAnnotations[i].toString());
      }

      ok = true;
    }

    // classSample.listerAnnotations(currentAnnotations);

    // while (!ok) {
    // try {
    // // System.out.print("Entrez le nom d'une classe (ex : java.util.Date): ");
    // // String nomClasse = litChaineAuClavier();

    // // analyseClasse(nomClasse);
    // ok = true;
    // } catch (ClassNotFoundException e) {
    // System.out.println("Classe non trouvée.");
    // } catch (IOException e) {
    // System.out.println("Erreur d'E/S!");
    // }
    // }
  }
}
