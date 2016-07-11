import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.Reader;
import java.lang.reflect.Field;
import java.util.HashMap;

import java_cup.runtime.Symbol;

public class TokenUtils {
	
	private static Integer[] TOKEN_IDS;
	private static String[] TOKEN_NAMES;
	private static HashMap<String, String> tokenNames = new HashMap<String, String>();
	
	public TokenUtils(){
		this.initializeTokenNames();
	}
	
	private static void initializeTokenNames() {
		tokenNames.put("LPAR","(");
		tokenNames.put("LSQPAR","[");
		tokenNames.put("RPAR",")");
		tokenNames.put("RSQPAR","]");
		tokenNames.put("DPLUS","++");
		tokenNames.put("DMINUS","--");
		tokenNames.put("PLUS","+");
		tokenNames.put("MINUS","-");
		tokenNames.put("NOT","!");
		tokenNames.put("NEW","new");
		tokenNames.put("TILDE","~");
		tokenNames.put("THIS","this");
		tokenNames.put("VOID","void");
		tokenNames.put("DELETE","delete");
		tokenNames.put("TYPEOF","typeof");
		tokenNames.put("FUNCTION","function");
		tokenNames.put("NULL","null");
		tokenNames.put("SEMI",";");
	}
	
	public static String getSymbol(String sym){
		if(tokenNames.containsKey(sym))
			return tokenNames.get(sym);
		else
			return sym;
	}
}
