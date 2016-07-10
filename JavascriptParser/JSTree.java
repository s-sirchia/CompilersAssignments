import java.util.ArrayList;

public class JSTree {
	public static Tree<String> tree = new Tree<String>("Javascript_program");
}

class JSNode<String> extends Node{
    int line;
    public JSNode(String data,int line){
        super(data);
        this.line = line;
    }
    
    public void setCurrentLine(int line){
        this.line = line;
    }
    
}

class Identifier<String> extends JSNode{
	
	public Identifier(String rootData,int line) {
		super("IDENTIFIER",line);
		this.addChild(new Node(rootData));
	}	
}

class Assign<String> extends JSNode{
	
	public Assign(Node<String> a, Node<String> b,int line) {
		//super(rootData,line);
		super("ASSIGN",line);
		this.addChild(a);
		this.addChild(b);
	}
	
	public Assign(String rootData,  Node<String> a, Node<String> b,int line) {
		//super(rootData,line);
		super(rootData,line);
		this.addChild(a);
		this.addChild(b);
	}
}

class Literal<String> extends JSNode{
	
	public Literal(String value,int line) {
		super("LITERAL",line);
		this.addChild(new Node(value));
	}
	
	public Literal(String value,int line, Node<String>typeConstant) {
		super("LITERAL",line);
		this.addChild(new Node(value));
		this.addChild(typeConstant);
	}	
}

class Label<String> extends JSNode{
	public Label(String label, int line){
		super(label,line);
	}
}

class StatementList<String> extends JSNode{
	public StatementList(){
		super("StatementList", -1);
	}
}

class DeclarationList<String> extends JSNode{
	public DeclarationList(){
		super("DeclarationList", -1);
	}
}

class Operation<String> extends JSNode{
	
	public Operation(String rootData,  Node<String> a, Node<String> b,int line) {
		//super(rootData,line);
		super(rootData,line);
		this.addChild(a);
		this.addChild(b);
	}
	
	public Operation(String rootData,  Node<String> a,int line) {
		//super(rootData,line);
		super(rootData,line);
		this.addChild(a);
	}
}

class LateAssign<String> extends Assign{

	public LateAssign(Node<String> a, Node<String> b, int line) {
		super("LATE ASSIGN", a, b, line);
		// TODO Auto-generated constructor stub
	}
	
}

class IfNode<String> extends JSNode{
	
	
	public IfNode(Node<String> condition,  Node<String> thenbody, Node<String> elsebody,int line) {
		//super(rootData,line);
		super("IF THEN ELSE",line);
		this.addChild(condition);
		this.addChild(thenbody);
		this.addChild(elsebody);
	}
	
	public IfNode(Node<String> condition, Node<String> thenbody,int line) {
		//super(rootData,line);
		super("IF THEN",line);
		this.addChild(condition);
		this.addChild(thenbody);
	}
	
}

class WhileOp<String> extends JSNode{

	public WhileOp(String type, Node<String> exp1, Node<String> exp2, int line){
		super(type, line);
		this.addChild(exp1);
		this.addChild(exp2);
	}	
}

class ForOp<String> extends JSNode{

	public ForOp(Node<String> init, Node<String> condition, Node<String> body, Node<String> incr, int line){
		super("FOR", line);
		this.addChild(init);
		this.addChild(condition);
		this.addChild(body);
		this.addChild(incr);
	}	
}


class Return<String> extends JSNode{
	
	public Return(int line) {
		super("RETURN",line);
	}
	
	public Return(Node<String> toReturn,int line) {
		super("RETURN",line);
		this.addChild(toReturn);
	}	
}

class Clause<String> extends JSNode{
	public Clause(String type, Node<String> expression, Node<String> statementlist, int line){
		super(type, line);
		this.addChild(expression);
		this.addChild(statementlist);
	}
	public Clause(String type, Node<String> expression, int line){
		super(type, line);
		this.addChild(expression);
	}
	
	public Clause(String type, int line){
		super(type, line);
	}
}

class Switch<String> extends JSNode{
	public Switch(Node<String> expression, int line){
		super("SWITCH", line);
		this.addChild(expression);
	}
}

class Function<String> extends JSNode{
	public Function(Node<String> name, int line){
		super("FUNCTION", line);
		this.addChild(name);
	}
}

class Call<String> extends JSNode{
	public Call(Node<String>obj, Node<String> function, int line){
		super("CALL", line);
		this.addChild(obj);
		this.addChild(function);
	}
	
	public void addArguments(Arguments args){
		((Node) this.getChilds().get(1)).addChild(args);
	}
}

class Arguments<String> extends JSNode{
	public Arguments(int line){
		super("Arguments", line);
	}
}

class ArrayNode<String> extends JSNode{
	public ArrayNode(int line){
		super("ARRAY", line);
	}
}

class ItemAccess<String> extends JSNode{
	public ItemAccess(Node<String> source, Node<String> access, int line){
		super("ITEM ACCESS", line);
		this.addChild(source);
		this.addChild(access);
	}
}

class Expression<String> extends JSNode{
	public Expression(int line){
		super("Expression", line);
	}
}

class FunctionDeclaration<String> extends JSNode{

	public FunctionDeclaration(Node<String> name, Node<String> param, Node<String> body, int line) {
		super("FUNCTION DECLARATION", line);
		this.addChild(name);
		this.addChild(param);
		this.addChild(body);
	}
	
	public FunctionDeclaration(Node<String> param, Node<String> body, int line) {
		super("FUNCTION DECLARATION", line);
		this.addChild(param);
		this.addChild(body);
	}
}

class TryStat<String> extends JSNode{
	public TryStat(int line){
		super("TRY", line);
	}
}

class ThrowNode<String> extends JSNode{
	public ThrowNode(Node<String> exception, int line){
		super("THROW", line);
		this.addChild(exception);
	}
}

class Constructor<String> extends JSNode{
	public Constructor(Node<String> obj, Node<String> arg, int line) {
		super("NEW", line);
		this.addChild(obj);
		this.addChild(arg);
	}
}