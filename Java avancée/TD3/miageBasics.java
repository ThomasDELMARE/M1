import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

@Target({ElementType.METHOD, ElementType.CONSTRUCTOR, ElementType.FIELD, ElementType.TYPE})

public @interface miageBasics {
    // AJOUTER TARGET
    public String nom() default "DELMARE";
    public String prenom() default "Thomas";
    public int annee() default 2021;
    public String module() default "Nom du module";
    public int numSeance() default 1;
}
