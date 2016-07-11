import java.io.FileReader;

public class Main {
	public static void main(String args[]) {
		try {
	           
	        JavascriptLexer lexer = new JavascriptLexer(new FileReader(args[0]));
		    // start parsing
		    parser p = new parser(lexer);
		    System.out.println("Parser runs: ");
	            p.parse();
		    System.out.println("Parsing finished!");
		    
		    //JSTree.tree.printTree();
		    
		    JSTree.tree.generateJson("D:/xampp/htdocs/program.json");
	            
		} catch (Exception e) {
		    e.printStackTrace();
		} 
	    }
}
