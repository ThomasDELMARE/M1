package controle.ex3;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.ArrayList;

import controle.ex3.*;

public class PersonneVaccineeIntrospection {
	ArrayList<String> annotations = new ArrayList<String>();

	
	public PersonneVaccineeIntrospection() {
		
	}
	
	public ArrayList<String> methodesAppelees(int nombre) throws ClassNotFoundException{
		Class<?> classe = PersonneVaccinee.class;
		Method[] methods = classe.getDeclaredMethods();
		int indent = 0;
		
		for(Method m: methods) {
			UseMethod a[] = m.getAnnotationsByType(UseMethod.class);
			
			if(a.length != 0) {
				String s = m.getName() + "{";
				
				for(Parameter p : m.getParameters()) {
					s = s + p.getName() + ": " + p.getParameterizedType().getTypeName() + ",";
				}
				
				annotations.add(s + "} : " + m.getReturnType().getTypeName());
				indent++;
			}
		}
		System.out.println(annotations);
		return annotations;
	}
	
	public static void main(String[] args) throws ClassNotFoundException {
		PersonneVaccineeIntrospection test = new PersonneVaccineeIntrospection();
		test.methodesAppelees(2);
	}
}
