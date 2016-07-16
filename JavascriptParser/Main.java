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
		    
		    JSTree.tree.printTree();
		    
		    if (!(JSTree.tree.getRootChilds().isEmpty())){
		    	String filename = args[0];
			    filename = filename.replace("Input/", "");
			    filename = filename.replace(".js", "");
			    String jsonName = "D:/xampp/htdocs/Visualizzatore alberi/"+filename+".json";
			    JSTree.tree.generateJson(jsonName);
		    }
	            
		} catch (Exception e) {
		    e.printStackTrace();
		} 
	    }
}
