import pprint
import collections
import json

terminali = ["LBPAR", "RBPAR", "LPAR", "RPAR", "LSQPAR", "RSQPAR", "DOT", "DOT3", "COMMA", "SEMI", "COLON", "ASSIGN", "DPLUS", "DMINUS", "PLUS", "MINUS", "TILDE", "NOT", "STAR", "DIV", "DIVEQ", "MOD", "AND", "OR", "LT", "GT", "HAT", "QUESTION", "LEQ", "GEQ", "EQ", "NEQ", "TYPEEQ", "TYPENEQ", "TWOLANG", "TWORANG", "THREERANG", "LOGAND", "LOGOR", "PLUSEQ", "MINUSEQ", "STAREQ", "MODEQ", "TWOLANGEQ", "TWORANGEQ", "THREERANGEQ", "ANDEQ", "OREQ", "HATEQ", "ARROW", "TWOSTAREQ", "DSTAR", "DO", "IN", "IF", "NEW", "TRY", "FOR", "VAR", "ELSE", "THIS", "CASE", "VOID", "WITH", "BREAK", "THROW", "YIELD", "CATCH", "TARGET", "CONST", "CLASS", "SUPER", "WHILE", "RETURN", "EXPORT", "IMPORT", "TYPEOF", "SWITCH", "EXTENDS", "DEFAULT", "LET", "OF", "FINALLY", "DEBUGGER", "FUNCTION", "CONTINUE", "INSTANCEOF", "IDENTIFIERNAME", "GET", "SET", "STATIC", "DECIMALLITERAL", "OCTALLITERAL", "HEXLITERAL", "BYNARYLITERAL", "SIGNEDINTEGER", "COMMENT", "STRING_LITERAL", "REGEXLITERAL", "TEMPLATE", "ERROR", "ERROR_B", "NULL", "BOOLEANLITERAL"]

def Tree(): 
	return collections.defaultdict(Tree)

def dicts(t): 
	return {k: dicts(t[k]) for k in t}

def add(t, path):
  for node in path:
    t = t[node]


def getString(node,diz):
	if node not in diz:
		yield node
	else:
		for n in range(0,len(diz[node])):
			for s in getString(diz[node][n],diz):
				yield node + ">" + s


def printRecursive(name,t):
	s = '{"name":"'+name+'"'
	chiavi = t.keys()
	if len(chiavi) != 0:
		s +=',"children":['
		for i in range(0,len(chiavi)):
			s += printRecursive(chiavi[i],t[chiavi[i]])
			if i <= len(chiavi)-2:
				s += ','
		s += ']'
	s += '}'
	return s;



tree_dict = dict()
with open("treegrammar.txt", 'r') as file:
	for line in file:
		line = line.replace("\n","")
		line = line.strip()
		splitted = line.split(" ::= ")

		if splitted[0] not in tree_dict:
			tree_dict[splitted[0]] = list()
			if len(splitted) == 1:
				tree_dict[splitted[0]].append(" ")
			else:
				tree_dict[splitted[0]].append(splitted[1])
		else:
			if len(splitted) == 1:
				tree_dict[splitted[0]].append(" ")
			else:
				tree_dict[splitted[0]].append(splitted[1])


#pprint.pprint(tree_dict)

a = getString("ScriptBody",tree_dict)

t =  Tree()
for sss in a:
	add(t,sss.split('>'))


s = printRecursive('ScriptBody',t['ScriptBody'])
print s
#pprint.pprint(json.dumps(t))
	