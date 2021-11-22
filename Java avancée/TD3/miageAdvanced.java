import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

@Target({ElementType.METHOD, ElementType.CONSTRUCTOR})
public @interface miageAdvanced {

    public static enum etat {  
        DRAFT_PARTIEL, DRAFT_COMPLET, VERSION_FINALISEEE  
    }

    public etat etatCompletude() default etat.DRAFT_PARTIEL;
    public etat etatQualite() default etat.DRAFT_PARTIEL;
    public boolean etatTests() default false;
    public boolean etatAutomatisation() default false;
}
