

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


public class SubstTest {
	private static final String OUTPUT_FILE = "src/resources/output.txt";
	private static Integer[] TOKEN_IDS;
	private static String[] TOKEN_NAMES;
	
	public static void main(String[] args) throws IOException {
		// the standalon Subst prints status on stdout
		// redirecte it into a file
		String[] argv = new String[1];
		argv[0] = "src/resources/input.txt";
		File actual = new File(OUTPUT_FILE);
		actual.delete();
		FileOutputStream fos = new FileOutputStream(OUTPUT_FILE, true);
		System.setOut(new PrintStream(fos));

		scan(argv);

		fos.close();
	}
	
	private static void initializeTokenNames() {
		Class<sym> c = sym.class;
		Field[] fields = c.getFields();
		TOKEN_IDS = new Integer[fields.length];
		TOKEN_NAMES = new String[fields.length];
		for(int i=0; i < fields.length; i++){
			try {
				TOKEN_IDS[i] = fields[i].getInt(null);
				TOKEN_NAMES[i] = fields[i].getName();
			} catch (IllegalArgumentException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
	}
	
	public static void scan(String argv[]) {
	    if (argv.length == 0) {
	      System.out.println("Usage : java JavascriptLexer [ --encoding <name> ] <inputfile(s)>");
	    }
	    else {
	      int firstFilePos = 0;
	      String encodingName = "UTF-8";
	      if (argv[0].equals("--encoding")) {
	        firstFilePos = 2;
	        encodingName = argv[1];
	        try {
	          java.nio.charset.Charset.forName(encodingName); // Side-effect: is encodingName valid? 
	        } catch (Exception e) {
	          System.out.println("Invalid encoding '" + encodingName + "'");
	          return;
	        }
	      }
	      initializeTokenNames();
	      HashMap<Integer, String> tokenNames = new HashMap<Integer, String>();
	      for (int i = 0; i < TOKEN_IDS.length; i++)
	    	  tokenNames.put(TOKEN_IDS[i], TOKEN_NAMES[i]);
	      for (int i = firstFilePos; i < argv.length; i++) {
	        JavascriptLexer scanner = null;
	        try {
	          java.io.FileInputStream stream = new java.io.FileInputStream(argv[i]);
	          java.io.Reader reader = new java.io.InputStreamReader(stream, encodingName);
	          scanner = new JavascriptLexer(reader);
	          do {
	        	  Symbol current = scanner.yylex();
	        	  if(current==null){
	        		  System.out.println(current);
	        		  break;
	        	  }
	        	  if(current.sym==-2){
	        		  System.out.printf("%s, %s\n", tokenNames.get(current.sym),current.value.toString());
	        		  break; 
	        	  }
	        	  if(current!=null&&current.value!=null){
	        		  System.out.printf("%s, %s\n", tokenNames.get(current.sym),current.value.toString());
	        		  continue;
	        	  }
	            System.out.println(tokenNames.get(current.sym));
	          } while (true);

	        }
	        catch (java.io.FileNotFoundException e) {
	          System.out.println("File not found : \""+argv[i]+"\"");
	        }
	        catch (java.io.IOException e) {
	          System.out.println("IO error scanning file \""+argv[i]+"\"");
	          System.out.println(e);
	        }
	        catch (Exception e) {
	          System.out.println("Unexpected exception:");
	          e.printStackTrace();
	        }
	      }
	    }
	  }
}
