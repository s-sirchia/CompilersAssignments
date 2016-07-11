import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

public class Tree<T> {
    private Node<T> root;

    public Tree(T rootData) {
        root = new Node<T>(rootData);
       
    }
    
    public Node<T> getRoot(){
    	return this.root;
    }
    
    public List<Node<T>> getRootChilds(){
    	return this.root.getChilds();
    }
    
    public void printTree(){
    	
    	printRecursive(this.root,0);
    }
    
    private void printRecursive(Node<T> node, int level){
		printTab(level);
                node.dump();
                System.out.println();
		for(int i = 0;i < node.getChilds().size();i++){
                    
                    printRecursive(node.getChilds().get(i),level+1);
		}
		
		
    }
    
public void generateJson(String dest){
	PrintWriter out = null;
	try {
		out = new PrintWriter(dest);
	} catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    	String text = generateJsonRecursive(this.root,0);
    	out.println(text);
    	out.close();
    }
    
    private String generateJsonRecursive(Node<T> node, int level){
        String info = "{\"name\": \""+node.getData()+"\"";
        if(node.hasChilds()){
        	info = info+", \"children\": [";
        	for(int i = 0;i < node.getChilds().size();i++){
        		info = info+generateJsonRecursive(node.getChilds().get(i),level+1);
        		if(i<(node.getChilds().size()-1))
        			info = info+",";
        	}
        	info = info+"]";
        }
		info = info+"}";
		return info;
    }
   
    private void printTab(int n){
		
		for(int i = 0; i<n;i++)
			System.out.print("\t|-");
    }
	
}