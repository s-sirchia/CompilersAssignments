import java_cup.runtime.*;
import java.util.HashMap;

%%

%class JavascriptLexer
%unicode
//%debug
%line
%column
%yylexthrow Exception
%type java_cup.runtime.Symbol

%{
	StringBuffer string = new StringBuffer();
	
	HashMap<String,Integer> table = new HashMap<String,Integer>();
	
	int lastKey = 0;

	private Symbol symbol(int type){
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value){
		return new Symbol(type, yyline, yycolumn, value);
	}
	
	public static void main(String argv[]) {
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
	      for (int i = firstFilePos; i < argv.length; i++) {
	        JavascriptLexer scanner = null;
	        try {
	          java.io.FileInputStream stream = new java.io.FileInputStream(argv[i]);
	          java.io.Reader reader = new java.io.InputStreamReader(stream, encodingName);
	          scanner = new JavascriptLexer(reader);
	          do {
	        	  Symbol current = scanner.yylex();
	        	  if(current!=null&&current.value!=null){
	        		  System.out.printf("%s , %s\n", current.toString(),current.value.toString());
	        	  }
	            System.out.println(current);
	          } while (!scanner.zzAtEOF);

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

Punctuator = [\{\(\)\[\]\.\+\-\*\%\&\|\^\:\=\!\~\;\,\<\>\?]|(\.\.\.)|(<=)|(>=)|(==)|(\!=)|(===)|(\!==)|(\+\+)|(--)|(<<)|(>>)|(>>>)|(&&)|(\|\|)|(\+=)|(-=)|(\*=)|(%=)|(<<=)|(>>=)|(>>>=)|(&=)|(\|=)|(\^=)|(=>)

DivPunctuator = "/" | "/="

RightBracePunctuator = "}"


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

%%

/*Initial State*/
<YYINITIAL>{

	/*Things to ignore*/
	{WhiteSpace}				{ }
	
	{LineTerminator}			{ }
	
	{LineTerminatorSequence}	{ }
	
	{Comment}					{return symbol(sym.COMMENT);}
	
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

	{RegularExpressionLiteral}	{return symbol(sym.REGEXLITERAL, yytext());}
	
	
	
	/*Punctuators*/
	{Punctuator}				{return symbol(sym.PUNCTUATOR, yytext());}
	
	{DivPunctuator}				{return symbol(sym.DIVPUNCTUATOR, yytext());}
	
	{RightBracePunctuator}		{return symbol(sym.RBPUNCTUATOR);}
	
	
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
  <<EOF>>						 { throw new Exception("ERROR: String not closed before end of file");}
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
  <<EOF>>						 { throw new Exception("ERROR: String not closed before end of file");}
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

/* error fallback */
[^]                              { throw new Error("Illegal character <"+
													yytext()+"> at row "+(yyline+1)+" column "+yycolumn); }



