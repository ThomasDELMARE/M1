/* Philippe Lahire 
 * M1 MIAGE
 */
package miage.TDAnnotations;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.TYPE, ElementType.FIELD, ElementType.METHOD, ElementType.CONSTRUCTOR, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface miageBasics {
	
	String nomAuteur();
	String prenomAuteur();
	int anneeUniversitaire() default 2020;
	String moduleInfo() default "";
	int seanceTD() default 0;
}
