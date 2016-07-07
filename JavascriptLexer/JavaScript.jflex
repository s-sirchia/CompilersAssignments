import java_cup.runtime.*;
import java.util.HashMap;

%%

%class JavascriptLexer
%unicode
//%debug
%line
%column
%type java_cup.runtime.Symbol

%{
	StringBuffer string = new StringBuffer();
	
	public HashMap<String,Integer> table = new HashMap<String,Integer>();
	
	int lastKey = 0;

	private Symbol symbol(int type){
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value){
		return new Symbol(type, yyline, yycolumn, value);
	}
	
%}


/* Space and Terminators*/ 

WhiteSpace = [\t\v\f \u00A0\uFEFF] | {UnicodeWhiteSpace}

	UnicodeWhiteSpace = [\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000]

LineTerminator = [\n\r\u2028\u2029]

UnknownTerminators = [\u000D\u000A]

LineTerminatorSequence = [\n\r\u2028\u2029] | (\r\n)

/*Comments*/

Comment = {MultiLineComment} | {SingleLineComment}

	MultiLineComment = "/*" [^*] ~"*/" | "/*" "*"+ "/"
		
	SingleLineComment = \/\/{SingleLineCommentChars}*
		
	SingleLineCommentChars = {SingleLineCommentChar}+
		
	SingleLineCommentChar = [^\n\r\u2028\u2029]

/*Numeric Literals*/

DecimalLiteral =
{DecimalIntegerLiteral}\.{DecimalDigits}*{ExponentPart}*  | \.{DecimalDigits}{ExponentPart}* | {DecimalIntegerLiteral}{ExponentPart}*

	DecimalIntegerLiteral = "0"|{NonZeroDigit}{DecimalDigits}*

	DecimalDigits = {DecimalDigit}+

	DecimalDigit = [0-9]

	NonZeroDigit = [1-9]

	ExponentPart = {ExponentIndicator}{SignedInteger}

	ExponentIndicator = [eE]

	SignedInteger = {DecimalDigits} | \+{DecimalDigits} | \-{DecimalDigits}

BinaryIntegerLiteral = "0b"{BinaryDigits} | "0B"{BinaryDigits}

	BinaryDigits = {BinaryDigit}+

	BinaryDigit = [01]

OctalIntegerLiteral = "0o"{OctalDigits} | "0O"{OctalDigits}

	OctalDigits = {OctalDigit}+

	OctalDigit = [0-7]

HexIntegerLiteral = "0x"{HexDigits} | "0X"{HexDigits}

	HexDigits = {HexDigit}+

	HexDigit = [0-9a-fA-F]

	
/* Reserved Words */

//Keyword = "break"|"do"|"in"|"typeof"|"case"|"else"|"instanceof"|"var"|"catch"|"export"|"new"|"void"|"class"|"extends"|"return"|"while"|"const"|"finally"|"super"|"with"|"continue"|"for"|"switch"|"yield"|"debugger"|"function"|"this"|"default"|"if"|"throw"|"delete"|"import"|"try"


LPar = "("

RPar = ")"

LSqPar = "["

RSqPar = "]"

Dot = "."

Dot3 = "..."

Comma = ","

Semi = ";"

Colon = ":"

Plus = "+"

Minus = "-"

DPlus = "++"

Div = "/"

Mod = "%"

DMinus = "--"

Tilde = "~"

Not = "!"

Star = "*"

And = "&"

Or = "|"

Hat = "^"

LAng = "<"

RAng = ">"

Question = "?"

LEq = "<="

GEq = ">="

Eq = "=="

NEq = "!="

TypeEq = "==="

TypeNEq = "!=="

TwoLAng = "<<"

TwoRAng = ">>"

ThreeRAng = ">>>"

LogAnd = "&&"

LogOr = "||"

PlusEq = "+="

MinusEq = "-="

StarEq = "*="

ModEq= "%="

TwoLAngEq = "<<="

TwoRAngEq = ">>="

ThreeRAngEq = ">>>="

AndEq = "&="

OrEq = "|="

HatEq = "^="

Arrow = "=>"

DivEq = "/="

LeftBracePunctuator = "{"

RightBracePunctuator = "}"

Assign = "="

TwoStarEq = "**="

/* Identifiers */
IdentifierName = ([a-zA-Z_$][a-zA-Z0-9_$]*)


/*Regular Expressions*/
RegularExpressionLiteral =\/{RegularExpressionBody}\/{RegularExpressionFlags}
		
		RegularExpressionBody = {RegularExpressionFirstChar}{RegularExpressionChars}
			
			RegularExpressionFirstChar = {RegularExpressionNonTerminatorFC} | {RegularExpressionBackslashSequence} | {RegularExpressionClass}

			RegularExpressionChars = {RegularExpressionChar}*

			RegularExpressionChar ={RegularExpressionNonTerminatorC} | {RegularExpressionBackslashSequence} | {RegularExpressionClass}
			
			RegularExpressionBackslashSequence = \\{RegularExpressionNonTerminator}
			
			RegularExpressionNonTerminator = [^\n\r\u2028\u2029]
			
			RegularExpressionNonTerminatorFC = [^\n\r\u2028\u2029\*\\\/\[\]]
			
			RegularExpressionNonTerminatorC = [^\n\r\u2028\u2029\\\/\[\]]
			
			RegularExpressionNonTerminatorCC = [^\n\r\u2028\u2029\[\]\\]
			
			RegularExpressionClass = \[ {RegularExpressionClassChars} \]
			
			RegularExpressionClassChars = {RegularExpressionClassChar}*
			
			RegularExpressionClassChar = {RegularExpressionNonTerminatorCC} | {RegularExpressionBackslashSequence}
			
			RegularExpressionFlags = [g]?[m]?[i]?[x]?[X]?[s]?[u]?[U]?[A]?[J]?

/*Escapes*/
EscapeSequence = {CharacterEscapeSequence} | 0[^0-9] | {HexEscapeSequence} | {UnicodeEscapeSequence}

	CharacterEscapeSequence = {SingleEscapeCharacter} | {NonEscapeCharacter}
			
	SingleEscapeCharacter = [\'\"\\bfnrtv]

	NonEscapeCharacter = [^[\n\r\u2028\u2029\'\"\\bfnrtv0-9xu]]

	EscapeCharacter = {SingleEscapeCharacter} | {DecimalDigit} | x | u

	HexEscapeSequence = x {HexDigit}{HexDigit}

	UnicodeEscapeSequence = u{Hex4Digits} | {HexDigits}

	Hex4Digits ={HexDigit}{HexDigit}{HexDigit}{HexDigit}

/*Template Literals*/
Template ={NoSubstitutionTemplate} | {TemplateHead}
		
		NoSubstitutionTemplate = \`{TemplateCharacters}*\`
		
		TemplateHead = \`{TemplateCharacters}*\$\{
		
		TemplateSubstitutionTail = {TemplateMiddle} | {TemplateTail}
		
		TemplateMiddle =\}{TemplateCharacters}*\$\{
		
		TemplateTail = \}{TemplateCharacters}*\`
		
		TemplateCharacters = {TemplateCharacter}+
		
		LineContinuation = \\[LineTerminatorSequence]
				
		TemplateCharacter = \$[^\{] | \\{EscapeSequence} | {LineContinuation} | {LineTerminatorSequence} | [^\`\\\$\n\r\u2028\u2029]


%state STRING1
%state STRING2
%state COMMENT

%%

/*Initial State*/
<YYINITIAL>{

	/*Things to ignore*/
	{WhiteSpace}				{ }
	
	{LineTerminator}			{ }
	
	{LineTerminatorSequence}	{ }
	
	{SingleLineComment}			{return symbol(sym.COMMENT);}
	
	"/*"						{yybegin(COMMENT); }
	
	"*/"						{return symbol(sym.ERROR, "Unmatched */");}
	/* keywords */
	"break"						{return symbol(sym.BREAK); }
	"do"						{return symbol(sym.DO); }
	"in"						{return symbol(sym.IN); }
	"typeof"					{return symbol(sym.TYPEOF); }
	"case"						{return symbol(sym.CASE); }
	"else"						{return symbol(sym.ELSE); }
	"instanceof"				{return symbol(sym.INSTANCEOF); }
	"var"						{return symbol(sym.VAR); }
	"catch"						{return symbol(sym.CATCH); }
	"export"					{return symbol(sym.EXPORT); }
	"new"						{return symbol(sym.NEW); }
	"void"						{return symbol(sym.VOID); }
	"class"						{return symbol(sym.CLASS); }
	"extends"					{return symbol(sym.EXTENDS); }
	"return"					{return symbol(sym.RETURN); }
	"while"						{return symbol(sym.WHILE); }
	"const"						{return symbol(sym.CONST); }
	"finally"					{return symbol(sym.FINALLY); }
	"super"						{return symbol(sym.SUPER); }
	"with"						{return symbol(sym.WITH); }
	"continue"					{return symbol(sym.CONTINUE); }
	"for"						{return symbol(sym.FOR); }
	"switch"					{return symbol(sym.SWITCH); }
	"yield"						{return symbol(sym.YIELD); }
	"debugger"					{return symbol(sym.DEBUGGER); }
	"function"					{return symbol(sym.FUNCTION); }
	"this"						{return symbol(sym.THIS); }
	"default"					{return symbol(sym.DEFAULT); }
	"if"						{return symbol(sym.IF); }
	"throw"						{return symbol(sym.THROW); }
	"delete"					{return symbol(sym.DELETE); }
	"import"					{return symbol(sym.IMPORT); }
	"try"						{return symbol(sym.TRY); }
    "null"						{return symbol(sym.NULL); }
    "target"                    {return symbol(sym.TARGET); }
    "let"                       {return symbol(sym.LET); }
    "of"                        {return symbol(sym.OF); }
    "get"                       {return symbol(sym.GET); }
    "set"                       {return symbol(sym.SET); }
    "static"                    {return symbol(sym.STATIC); }
    
    "true"|"false"              {return symbol (sym.BOOLEANLITERAL, yytext();}

	{RegularExpressionLiteral}	{return symbol(sym.REGEXLITERAL, yytext());}
	
	
	
	/*Punctuators*/
	{LPar}						{return symbol(sym.LPAR);}
	
	{RPar}						{return symbol(sym.RPAR);}
    
    {LSqPar}                    {return symbol(sym.LSQPAR);}
    
    {RSqPar}                    {return symbol(sym.RSQPAR);}
	
	{Dot3}						{return symbol(sym.DOT3);}
	
	{Comma}						{return symbol(sym.COMMA);}
    
    {Div}                       {return symbol(sym.DIV);}
    
    {DivEq}                     {return symbol(sym.DIVEQ);}
	
    {LeftBracePunctuator}		{return symbol(sym.LBPAR);}
    
	{RightBracePunctuator}		{return symbol(sym.RBPAR);}
    
    {Colon}                     {return symbol(sym.COLON);}
	
	{Assign}                    {return symbol(sym.ASSIGN);}
    
    {DPlus}                     {return symbol(sym.DPLUS);}
    
    {DMinus}                    {return symbol(sym.DMINUS);}

    {Plus}                      {return symbol(sym.PLUS);}

    {Minus}                     {return symbol(sym.MINUS);}

    {Tilde}                     {return symbol(sym.TILDE);}

    {Not}                       {return symbol(sym.NOT);}
    
    {Star}                      {return symbol(sym.STAR);}
    
    {Mod}                       {return symbol(sym.MOD);}
    
    {Dot}                       {return symbol(sym.DOT);}
    
    {And}                       {return symbol(sym.AND);}
    
    {Or}                        {return symbol(sym.OR);}
    
    {LAng}                      {return symbol(sym.LANG);}
    
    {RAng}                      {return symbol(sym.RANG);}
    
    {Hat}                       {return symbol(sym.HAT);}
    
    {Question}                  {return symbol(sym.QUESTION);}

    {LEq}                       {return symbol(sym.LEQ);}

    {GEq}                       {return symbol(sym.GEQ);}

    {Eq}                        {return symbol(sym.EQ);}

    {NEq}                       {return symbol(sym.NEQ);}

    {TypeEq}                    {return symbol(sym.TYPEEQ);}

    {TypeNEq}                   {return symbol(sym.TYPENEQ);}

    {TwoLAng}                     {return symbol(sym.2LANG);}

    {TwoRAng}                     {return symbol(sym.2RANG);}

    {ThreeRAng}                     {return symbol(sym.3RANG);}

    {LogAnd}                    {return symbol(sym.LOGAND);}

    {LogOr}                     {return symbol(sym.LOGOR);}

    {PlusEq}                    {return symbol(sym.PLUSEQ);}

    {MinusEq}                   {return symbol(sym.MINUSEQ);}

    {StarEq}                    {return symbol(sym.STAREQ);}

    {ModEq}                     {return symbol(sym.MODEQ);}

    {TwoLAngEq}                   {return symbol(sym.2LANGEQ);}

    {TwoRAngEq}                   {return symbol(sym.2RANGEQ);}

    {ThreeRAngEq}                   {return symbol(sym.3RANGEQ);}

    {AndEq}                     {return symbol(sym.ANDEQ);}

    {OrEq}                      {return symbol(sym.OREQ);}

    {HatEq}                     {return symbol(sym.HATEQ);}

    {Arrow}                     {return symbol(sym.ARROW);}
    
    {TwoStarEq}                     {return symbol(sym.TWOSTAREQ);}
    
	/*Numeric Literals*/
	{BinaryIntegerLiteral}		{return symbol(sym.BYNARYLITERAL, yytext());}
		
	{OctalIntegerLiteral}		{return symbol(sym.OCTALLITERAL, yytext());}
	
	{HexIntegerLiteral}			{return symbol(sym.HEXLITERAL, yytext());}
	
	{IdentifierName}			{
									if(table.containsKey(yytext())){
										return symbol(sym.IDENTIFIERNAME, table.get(yytext()));
									}
									else{
										table.put(yytext(),lastKey);
										lastKey++;
										return symbol(sym.IDENTIFIERNAME, lastKey-1);
									}
								}
	
	{DecimalLiteral}			{return symbol(sym.DECIMALLITERAL, yytext());}
	
	//{SignedInteger}			{return symbol(sym.SIGNEDINTEGER, yytext());}
	
	/*Start of String*/
	\'                          { string.setLength(0); yybegin(STRING1); }
	
	\"                          { string.setLength(0); yybegin(STRING2); }
	
	{Template}					{return symbol(sym.TEMPLATE, yytext());}
}


/*String States*/
<STRING1> {
  <<EOF>>						 { return symbol(sym.ERROR_B,"EOF in string constant");}
  \'                             { yybegin(YYINITIAL); 
								   return symbol(sym.STRING_LITERAL, 
								   string.toString()); }
  [^\n\r\'\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\'                           { string.append('\''); }
  \\                             { string.append('\\'); }
  {UnknownTerminators}			 {	}
}

<STRING2> {
  <<EOF>>						 {  return symbol(sym.ERROR_B,"EOF in string constant");}
  \"                             { yybegin(YYINITIAL); 
								   return symbol(sym.STRING_LITERAL, 
								   string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
  {UnknownTerminators}			 {	}
}

<COMMENT> {
  <<EOF>>						 {  return symbol(sym.ERROR_B,"EOF in comment");}
  "*/"                           { yybegin(YYINITIAL); }
  .                   			 {  }
  {UnknownTerminators}			 {	}
}

/* error fallback */
[^]                              { return symbol(sym.ERROR,"Illegal character <"+
													yytext()+"> at row "+(yyline+1)+" column "+yycolumn); }



