import java_cup.runtime.*
%%

%class JavascriptLexer
%unicode
%debug
%line
%column

%{
	StringBuffer string = new StringBuffer();

	private Symbol symbol(int type){
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol symbol(int type, Object value){
		return new Symbol(type, yyline, yycolumn, value);
	}
%}

/* Main Elements*/

InputElementDiv = {WhiteSpace} | {LineTerminator} | {Comment} | {CommonToken} | {DivPunctuator} | {RightBracePunctuator}

InputElementRegExp = {WhiteSpace} | {LineTerminator} | {Comment} | {CommonToken} | {RightBracePunctuator}| {RegularExpressionLiteral}

InputElementRegExpOrTemplateTail = {WhiteSpace} | {LineTerminator} | {Comment} | {CommonToken} | {RegularExpressionLiteral} | {TemplateSubstitutionTail}

InputElementTemplateTail = {WhiteSpace} | {LineTerminator} | {Comment} | {CommonToken} | {DivPunctuator} | {TemplateSubstitutionTail}

/* Space and Terminators*/ 

	WhiteSpace = [\t\v\f \u00A0\uFEFF] | {UnicodeWhiteSpace}

		UnicodeWhiteSpace = [\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000]

	LineTerminator = [\n\r\u2028\u2029]

	LineTerminatorSequence = [\n\r\u2028\u2029] | (\r\n)

/* Comments */

	Comment = {MultiLineComment} | {SingleLineComment}

		MultiLineComment = (\/\*){MultiLineCommentChars}*(\*\/)

		MultiLineCommentChars = {MultiLineNotAsteriskChar}{MultiLineCommentChars}* | (*){PostAsteriskCommentChars}*
		
		PostAsteriskCommentChars = {MultiLineNotForwardSlashOrAsteriskChar}{MultiLineCommentChars}* | (*) {PostAsteriskCommentChars}*

		SourceCharacter = .
		
		MultiLineNotAsteriskChar = ^((?!\*){SourceCharacter})$
			
		MultiLineNotForwardSlashOrAsteriskChar = ^((?!\*\/){SourceCharacter})$
		
		SingleLineComment = "/" {SingleLineCommentChars}*
		
		SingleLineCommentChars = {SingleLineCommentChar}{SingleLineCommentChars}*
		
		SingleLineCommentChar = ^((?!{LineTerminator}){SourceCharacter})$

/* Base Element */

	CommonToken =
		{IdentifierName} | {Punctuator} | {NumericLiteral} | {StringLiteral} | {Template}


		IdentifierName = {IdentifierStart} | {IdentifierName}{IdentifierPart}


		IdentifierStart = {UnicodeIDStart} | "$" | "_" | "\" UnicodeEscapeSequence

		IdentifierPart =  {UnicodeIDContinue} | "$" | "_" | "\" UnicodeEscapeSequence | \u200c | \u200d

			UnicodeIDStart =[a-zA-Z]

			UnicodeIDContinue =[a-zA-Z0-9]

			/*

			UnicodeIDStart = any unicode having the ID_Start property || [a-zA-Z]

			UnicodeIDContinue = any unicode having the ID_Continue property || [a-zA-Z0-9]

			IditifierStart = \ UnicodeEscapeSequence

			Qual'ora non è $ _ o UTF16Encoding matchato UnicodeIDStart viene 
			inserito 

			IditifierPart = \ UnicodeEscapeSequence

			Qual'ora non è $, _, \u200c, \u200d, UTF16Encoding, matchato UnicodeIDPart viene 
			inserito 
				
				
			*/

/* Reserved Word */

	ReservedWord =
		{Keyword} | {FutureReservedWord} | {NullLiteral} | {BooleanLiteral} 

		Keyword = "break"|"do"|"in"|"typeof"|"case"|"else"|"instanceof"|"var"|"catch"|"export"|"new"|"void"|"class"|"extends"|"return"|"while"|"const"|"finally"|"super"|"with"|"continue"|"for"|"switch"|"yield"|"debugger"|"function"|"this"|"default"|"if"|"throw"|"delete"|"import"|"try"

		FutureReservedWord = "enum"|"await"

		NullLiteral = "null"

		BooleanLiteral = "true"|"false"

/* Punctuator */

	Punctuator = [\{\(\)\[\]\.\+\-\*%&|\^:=!~;,<>?]|(\.\.\.)|(<=)|(>=)|(==)|(!=)|(===)|(!==)|(\+\+)|(--)|(<<)|(>>)|(>>>)|(&&)|(\|\|)|(\+=)|(-=)|(\*=)|(%=)|(<<=)|(>>=)|(>>>=)|(&=)|(|=)|(\^=)|(=>)

	DivPunctuator = "/" | "/="
	
	RightBracePunctuator = "}"

/* Literals */

	NumericLiteral = {DecimalLiteral} | {BinaryIntegerLiteral} | {OctalIntegerLiteral} | {HexIntegerLiteral}

		DecimalLiteral =
			{DecimalIntegerLiteral}.{DecimalDigits}*{ExponentPart}*  | . {DecimalDigits}{ExponentPart}* | {DecimalIntegerLiteral}{ExponentPart}*

			DecimalIntegerLiteral = 0 {NonZeroDigit}{DecimalDigits}*

			DecimalDigits = {DecimalDigit} |{DecimalDigits} {DecimalDigit}
			
			DecimalDigit = [0-9]
			
			NonZeroDigit = [1-9]


			ExponentPart = {ExponentIndicator}{SignedInteger}

			ExponentIndicator = [eE]


			SignedInteger = {DecimalDigits} | + {DecimalDigits} | - {DecimalDigits}
		
		BinaryIntegerLiteral = "0b" {BinaryDigits} | "0B" {BinaryDigits}

			BinaryDigits = {BinaryDigit} | {BinaryDigits}{BinaryDigit}

			BinaryDigit = [01]

		OctalIntegerLiteral = "0o" {OctalDigits} | "0O" {OctalDigits}
		
			OctalDigits = {OctalDigit} | {OctalDigits}{OctalDigit}
			
			OctalDigit = [0-7]

		HexIntegerLiteral = "0x" {HexDigits} | "0X" {HexDigits}
			
			HexDigits = {HexDigit} | {HexDigits}{HexDigit}

			HexDigit = [0-9a-fA-F]

/* String Literal */

	StringLiteral = " {DoubleStringCharacters}* " | ' {SingleStringCharacters}* '
		
		DoubleStringCharacters = {DoubleStringCharacter}{DoubleStringCharacters}*
		
		SingleStringCharacters = {SingleStringCharacter}{SingleStringCharacters}*
		
			DoubleStringCharacter = ^((?!["\{LineTerminator}]){SourceCharacter})$ | \{EscapeSequence} | {LineContinuation}
			
			SingleStringCharacter =^((?!['\{LineTerminator}]){SourceCharacter})$ | \{EscapeSequence} | {LineContinuation}
		
			LineContinuation = \[LineTerminatorSequence]
		
			EscapeSequence = {CharacterEscapeSequence} | 0 | {HexEscapeSequence} | {UnicodeEscapeSequence}
			
			CharacterEscapeSequence = {SingleEscapeCharacter} | {NonEscapeCharacter}
			
			SingleEscapeCharacter = ['"\\bfnrtv]
			
			NonEscapeCharacter = ^((?![{LineTerminator}{EscapeCharacter}]){SourceCharacter})$
			
			EscapeCharacter = {SingleEscapeCharacter} | {DecimalDigit} | "x" | "u"
			
			HexEscapeSequence = x {HexDigit}{HexDigit}
			
			UnicodeEscapeSequence = "u"{Hex4Digits} | {HexDigits}
			
			Hex4Digits ={HexDigit}{HexDigit}{HexDigit}{HexDigit}

/* Regular Expression */


	RegularExpressionLiteral =/{RegularExpressionBody}/{RegularExpressionFlags}
		
		RegularExpressionBody ={RegularExpressionFirstChar}{RegularExpressionChars}
		
			RegularExpressionChars ="[]" | {RegularExpressionChars}{RegularExpressionChar}

			RegularExpressionFirstChar = ^((?![\*\\\/\[]){RegularExpressionNonTerminator})$ | {RegularExpressionBackslashSequence} | {RegularExpressionClass}
		
			RegularExpressionChar =^((?![\\\/\[]){RegularExpressionNonTerminator})$ | {RegularExpressionBackslashSequence} | {RegularExpressionClass}
			
			RegularExpressionBackslashSequence = \{RegularExpressionNonTerminator}
			
			RegularExpressionNonTerminator = ^((?![{LineTerminator}]){SourceCharacter})$
			
			RegularExpressionClass = [ {RegularExpressionClassChars} ]
			
			RegularExpressionClassChars = "[]" | {RegularExpressionClassChars}{RegularExpressionClassChar}
			
			RegularExpressionClassChar = ^((?![\]\\){RegularExpressionNonTerminator})$ | {RegularExpressionBackslashSequence}
			
			RegularExpressionFlags = "[]" | {RegularExpressionFlags}{IdentifierPart}


/* Template Literal */

	Template ={NoSubstitutionTemplate} | {TemplateHead}
		
		NoSubstitutionTemplate = `{TemplateCharacters}*`
		
		TemplateHead = `{TemplateCharacters}*${
		
		TemplateSubstitutionTail = {TemplateMiddle} | {TemplateTail}
		
		TemplateMiddle =}{TemplateCharacters}*${
		
		TemplateTail = }{TemplateCharacters}*`
		
		TemplateCharacters = {TemplateCharacter}{TemplateCharacters}*
		
		TemplateCharacter = $ | \{EscapeSequence} | {LineContinuation} | {LineTerminatorSequence} | ^((?![[`\\\$]|{LineTerminator}]){SourceCharacter})$



%%
/* keywords */
<YYINITIAL>{
		"break"				{return symbol(sym.BREAK); }
		"do"				{return symbol(sym.DO); }
		"in"				{return symbol(sym.IN); }
		"typeof"			{return symbol(sym.TYPEOF); }
		"case"				{return symbol(sym.CASE); }
		"else"				{return symbol(sym.ELSE); }
		"instanceof"		{return symbol(sym.INSTANCEOF); }
		"var"				{return symbol(sym.VAR); }
		"catch"				{return symbol(sym.CATCH); }
		"export"			{return symbol(sym.EXPORT); }
		"new"				{return symbol(sym.NEW); }
		"void"				{return symbol(sym.VOID); }
		"class"				{return symbol(sym.CLASS); }
		"extends"			{return symbol(sym.EXTENDS); }
		"return"			{return symbol(sym.RETURN); }
		"while"				{return symbol(sym.WHILE); }
		"const"				{return symbol(sym.CONST); }
		"finally"			{return symbol(sym.FINALLY); }
		"super"				{return symbol(sym.SUPER); }
		"with"				{return symbol(sym.WITH); }
		"continue"			{return symbol(sym.CONTINUE); }
		"for"				{return symbol(sym.FOR); }
		"switch"			{return symbol(sym.SWITCH); }
		"yield"				{return symbol(sym.YIELD); }
		"debugger"			{return symbol(sym.DEBUGGER); }
		"function"			{return symbol(sym.FUNCTION); }
		"this"				{return symbol(sym.THIS); }
		"default"			{return symbol(sym.DEFAULT); }
		"if"				{return symbol(sym.IF); }
		"throw"				{return symbol(sym.THROW); }
		"delete"			{return symbol(sym.DELETE); }
		"import"			{return symbol(sym.IMPORT); }
		"try"				{return symbol(sym.TRY); }


		{Punctuator}		{return symbol(sym.PUNCTUATOR, yytext());}


		{WhiteSpace}		{ }

}







