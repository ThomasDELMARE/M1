**
 * @version 1.00 05 mai 2021
 * @author Frédéric Mallet et Philippe Lahire

package miage.TDIntrospection;


import java.lang.reflect.Array;
import java.lang.reflect.Field;

import miage.exemple.Adresse;
import miage.exemple.Etudiant;
import miage.exemple.Personne;

public class GenericToString2 {
	StringBuffer sb;

	public String toString(Object o) {
		return toString(o, 1);
	}
	public String toString(Object o, int profondeur) {
		sb = new StringBuffer();
		buildString(o, profondeur);
		return sb.toString();
	}

	private void buildString(Object o, int profondeur) {
		if(o==null) { sb.append("null"); return; }
		if(profondeur <= 0) { sb.append(o.toString()); return; }

		Class<?> c = o.getClass();
		if (c.isArray()) {
			String sep="{"; // array elements are surrounded by curly brackets
			for(int i = 0; i<Array.getLength(o); i++) {
				sb.append(sep);
				buildString(Array.get(o, i), profondeur-1);
				sep=", "; // a list separated by colons
			}
			sb.append("}");			
		} else {
			// object slots (values of fields) are surrounded by square brackets
			sb.append(c.getName()).append('['); // print the name of the class before the bracket
			String sep = "";
			// treat the fields directly declared
			Field[] fields = c.getDeclaredFields();
			for(Field field : fields) {  
				sb.append(sep);
				build(o, field, profondeur);
				sep = "; "; // a list separated by semicolons
			}

			// also display the inherited fields
			fields = c.getFields();
			for(Field field : fields) { 
				// do not display a field that was already displayed in the previous for-loop
				if (field.getDeclaringClass()==c) continue; 
				sb.append(sep);
				build(o, field, profondeur);
				sep = "; "; // a list separated by semicolons
			}
			sb.append(']');
		}
	}

	private void build(Object o, Field field, int profondeur) {
		// print the name of the field, followed by =, followed by the value
		sb.append(field.getName()).append('='); 
		field.setAccessible(true); // allows for accessing the value of private fields
		try {
			Object fieldVal = field.get(o);
			Class<?> type = field.getType();
			if(type.isPrimitive()) sb.append(fieldVal);
			else if (type == String.class) sb.append('"').append(fieldVal).append('"');
			else buildString(fieldVal, profondeur-1); // recursive call, when not a primitive type
		} catch (Exception e) {
			sb.append("NO_ACCESS");
		}
	}

	static public void main(String[] args) {
		Adresse a = new Adresse("Nice", "Valrose", 28);
		Personne p = new Personne("Martin", "jean", a);
		Personne m = new Personne("Martin", "jeanne", a);
		Etudiant e = new Etudiant("Dupond", 15, p, m);
		System.out.println("classic:" + e);
		System.out.println("deep:" + new GenericToString2().toString(e, 4));

		Object o2 = new Object() {
			Object[] t = { new Adresse("Marseille", "le vieux port", 24), null, new int[] { 23, 24 } };
			private int v = 12;
			String nom = "Paul";
			Object self = this;
		};
		System.out.println("classic:" + o2);
		
		System.out.println("deep: " + new GenericToString2().toString(o2, 3));
		System.out.println("deep: " + new GenericToString2().toString(o2, 4));
	}
}
