/* Philippe Lahire 
 * M1 MIAGE
 */
package miage.TDAnnotations;

import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.Messager;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.annotation.processing.SupportedSourceVersion;
import javax.lang.model.SourceVersion;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.tools.Diagnostic.Kind;


@SupportedAnnotationTypes(value = { "*" })
@SupportedSourceVersion(SourceVersion.RELEASE_11)
public class MiageInformationsPreprocessor extends AbstractProcessor {
	
	
	  @Override
	  public boolean process(Set<? extends TypeElement> annotations, RoundEnvironment roundEnv) {
		miageBasics mb = null;
		miageAdvanced ma = null;
	    Messager messager = processingEnv.getMessager();
	 
	    for (TypeElement te : annotations) {
	      messager.printMessage(Kind.NOTE, "Traitement annotation " 
		    + te.getQualifiedName() + "... " + te.getSimpleName());
	 
	      for (Element element : roundEnv.getElementsAnnotatedWith(te)) {
	        messager.printMessage(Kind.NOTE, "Traitement de element de type (" + te.getSimpleName() + ") " + element.getKind().toString() + ": "+ element.getSimpleName());
//	        if (te.getSimpleName().equals("TestSourceCode"))
	        mb = element.getAnnotation(miageBasics.class);
	         if (mb != null) {
		          messager.printMessage(Kind.NOTE, "   Nom auteur = " + mb.nomAuteur());
		          messager.printMessage(Kind.NOTE, "   Pr�nom auteur = " + mb.prenomAuteur());
		          messager.printMessage(Kind.NOTE, "   S�ance TD = " + mb.seanceTD());
		          messager.printMessage(Kind.NOTE, "   Ann�e universitaire = " + mb.anneeUniversitaire());
		          messager.printMessage(Kind.NOTE, "   Module information = " + mb.moduleInfo());
	         }
	         ma = element.getAnnotation(miageAdvanced.class);
	         if (ma != null) {
		          messager.printMessage(Kind.NOTE, "   Compl�tude = " + ma.completude());
		          messager.printMessage(Kind.NOTE, "   Test� ? = " + ma.tested());
		          messager.printMessage(Kind.NOTE, "   G�n�r� ? = " + ma.generated());
	         }
	      }
	    }
	   
	    return true;
	  }
}

