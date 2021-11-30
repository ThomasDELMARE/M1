/* Philippe Lahire 
 * M1 MIAGE
 */
package miage.TDAnnotations;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.METHOD, ElementType.CONSTRUCTOR, ElementType.ANNOTATION_TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface miageAdvanced {
	
	TypeCompletude completude() default TypeCompletude.Partial;
	boolean tested() default false;
	boolean generated() default false;
}
