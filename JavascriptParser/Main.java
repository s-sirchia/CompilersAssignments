import java.io.FileReader;

public class Main {
	public static void main(String args[]) {
		try {
	           
	        JavascriptLexer lexer = new JavascriptLexer(new FileReader(args[0]));
		    // start parsing
		    parser p = new parser(lexer);
		    System.out.println("Parser runs: ");
	            p.debug_parse();
		    System.out.println("Parsing finished!");
		    
		    JSTree.tree.printTree();
	            
		} catch (Exception e) {
		    e.printStackTrace();
		} 
	    }
}
