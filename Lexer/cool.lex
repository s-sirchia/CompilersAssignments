
/*
 *  The scanner definition for COOL.
 *
 *  Scott McPeak (sm) 1/11/01:
 *    - changed to student-implemented line counting
 *    - fixed another \v bug (jlex doesn't interpret \v)
 *
 * sm 1/27/01:
 *    - error characters are now *not* coalesced (see src/cool.flex)
 */

import java_cup.runtime.Symbol;

%%

%{
    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    int comment_nesting = 0;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    Symbol check_string_overflow() {
        // sm: fixed another off-by-one: this used to say '>'
	if (string_buf.length() >= MAX_STR_CONST) {
	    yybegin(STRING_RECOVER);
	    return new Symbol(TokenConstants.ERROR, "String constant too long");
	}
	return null;
    }

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{
    // empty now
%init}

%eofval{
    switch(zzLexicalState) {
    case YYINITIAL:
	break;
    case COMMENT:
	yybegin(YYINITIAL);
	return new Symbol(TokenConstants.ERROR, "EOF in comment");
    case LINE_COMMENT:
	break;
    case STRING:
	yybegin(YYINITIAL);
	return new Symbol(TokenConstants.ERROR, "EOF in string constant");
    case STRING_RECOVER:
	break;
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup


NEWLINE		= \n
WHITESPACE	= [ \t\f\r\xob]

TYPESYM		= [A-Z][_A-Za-z0-9]*
OBJECTSYM	= [a-z][_A-Za-z0-9]*

SINGLE          = [+/\-*=<.~,;:()@\}\{]

ILLEGAL	        = [^\n \t\f\x0b\rA-Za-z0-9+/\-*=<.~,;:()@\}\{\"]

%state COMMENT, LINE_COMMENT, STRING, STRING_RECOVER

%%

<YYINITIAL>{NEWLINE}	 { curr_lineno++; }
<YYINITIAL>{WHITESPACE}+ {}

<YYINITIAL>"--"         { yybegin(LINE_COMMENT); }
<LINE_COMMENT>.*        {}
<LINE_COMMENT>\r        {}
<LINE_COMMENT>\n        { curr_lineno++; yybegin(YYINITIAL); }


<YYINITIAL>"(*"		{ yybegin(COMMENT);
			  comment_nesting++;
			}
<YYINITIAL>"*)"		{ /* error - unmatched comment */
			  return new Symbol(TokenConstants.ERROR, "Unmatched *)");
                	}

<COMMENT>"(*"		{ comment_nesting++; }
<COMMENT>"*)"		{ comment_nesting--;
                          if (comment_nesting == 0) yybegin(YYINITIAL); }
<COMMENT>[^(\*\n]+	{}
<COMMENT>"("		{}
<COMMENT>"*"		{}
<COMMENT>{NEWLINE}	{ curr_lineno++; }

<YYINITIAL>"=>"		{ return new Symbol(TokenConstants.DARROW); }
<YYINITIAL>"<="		{ return new Symbol(TokenConstants.LE); }
<YYINITIAL>"<-"		{ return new Symbol(TokenConstants.ASSIGN); }
<YYINITIAL>[0-9][0-9]*  { return new Symbol(TokenConstants.INT_CONST,
					    AbstractTable.inttable.addString(yytext())); }

<YYINITIAL>[Cc][Aa][Ss][Ee]	{ return new Symbol(TokenConstants.CASE); }
<YYINITIAL>[Cc][Ll][Aa][Ss][Ss] { return new Symbol(TokenConstants.CLASS); }
<YYINITIAL>[Ee][Ll][Ss][Ee]  	{ return new Symbol(TokenConstants.ELSE); }
<YYINITIAL>[Ee][Ss][Aa][Cc]	{ return new Symbol(TokenConstants.ESAC); }
<YYINITIAL>f[Aa][Ll][Ss][Ee]	{ return new Symbol(TokenConstants.BOOL_CONST, Boolean.FALSE); }
<YYINITIAL>[Ff][Ii]             { return new Symbol(TokenConstants.FI); }
<YYINITIAL>[Ii][Ff]  		{ return new Symbol(TokenConstants.IF); }
<YYINITIAL>[Ii][Nn]             { return new Symbol(TokenConstants.IN); }
<YYINITIAL>[Ii][Nn][Hh][Ee][Rr][Ii][Tt][Ss] { return new Symbol(TokenConstants.INHERITS); }
<YYINITIAL>[Ii][Ss][Vv][Oo][Ii][Dd] { return new Symbol(TokenConstants.ISVOID); }
<YYINITIAL>[Ll][Ee][Tt]         { return new Symbol(TokenConstants.LET); }
<YYINITIAL>[Ll][Oo][Oo][Pp]  	{ return new Symbol(TokenConstants.LOOP); }
<YYINITIAL>[Nn][Ee][Ww]		{ return new Symbol(TokenConstants.NEW); }
<YYINITIAL>[Nn][Oo][Tt] 	{ return new Symbol(TokenConstants.NOT); }
<YYINITIAL>[Oo][Ff]		{ return new Symbol(TokenConstants.OF); }
<YYINITIAL>[Pp][Oo][Oo][Ll]  	{ return new Symbol(TokenConstants.POOL); }
<YYINITIAL>[Tt][Hh][Ee][Nn]   	{ return new Symbol(TokenConstants.THEN); }
<YYINITIAL>t[Rr][Uu][Ee]	{ return new Symbol(TokenConstants.BOOL_CONST, Boolean.TRUE); }
<YYINITIAL>[Ww][Hh][Ii][Ll][Ee] { return new Symbol(TokenConstants.WHILE); }

<YYINITIAL>{TYPESYM}	{ return new Symbol(TokenConstants.TYPEID,
					    AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>{OBJECTSYM}	{ return new Symbol(TokenConstants.OBJECTID,
					    AbstractTable.idtable.addString(yytext())); }

<YYINITIAL>"+"			{ return new Symbol(TokenConstants.PLUS); }
<YYINITIAL>"/"			{ return new Symbol(TokenConstants.DIV); }
<YYINITIAL>"-"			{ return new Symbol(TokenConstants.MINUS); }
<YYINITIAL>"*"			{ return new Symbol(TokenConstants.MULT); }
<YYINITIAL>"="			{ return new Symbol(TokenConstants.EQ); }
<YYINITIAL>"<"			{ return new Symbol(TokenConstants.LT); }
<YYINITIAL>"."			{ return new Symbol(TokenConstants.DOT); }
<YYINITIAL>"~"			{ return new Symbol(TokenConstants.NEG); }
<YYINITIAL>","			{ return new Symbol(TokenConstants.COMMA); }
<YYINITIAL>";"			{ return new Symbol(TokenConstants.SEMI); }
<YYINITIAL>":"			{ return new Symbol(TokenConstants.COLON); }
<YYINITIAL>"("			{ return new Symbol(TokenConstants.LPAREN); }
<YYINITIAL>")"			{ return new Symbol(TokenConstants.RPAREN); }
<YYINITIAL>"@"			{ return new Symbol(TokenConstants.AT); }
<YYINITIAL>"}"			{ return new Symbol(TokenConstants.RBRACE); }
<YYINITIAL>"{"			{ return new Symbol(TokenConstants.LBRACE); }

<YYINITIAL>\"           { string_buf.setLength(0); yybegin(STRING); }
<STRING>\"              { yybegin(YYINITIAL);
                          Symbol res = check_string_overflow();
			  if (res != null) return res;
			  return new Symbol(TokenConstants.STR_CONST,
				            AbstractTable.stringtable.addString(string_buf.toString()));
                        }

<STRING>\n              { curr_lineno++;
                          yybegin(YYINITIAL);
			  return new Symbol(TokenConstants.ERROR,
					    "Unterminated string constant"); }

<STRING>\\              { yybegin(YYINITIAL);
			  return new Symbol(TokenConstants.ERROR,
					    "backslash at end of file"); }

<STRING>\\n             { Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append('\n'); }

<STRING>\\t             { Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append('\t'); }

<STRING>\\b             { Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append('\b'); }

<STRING>\\f             { Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append('\f'); }

<STRING>\\\0            { yybegin(STRING_RECOVER);
                          return new Symbol(TokenConstants.ERROR,
					    "String contains escaped null character"); }

<STRING>\0              { yybegin(STRING_RECOVER);
			  return new Symbol(TokenConstants.ERROR,
					    "String contains null character");}

<STRING>\\.             { Symbol res = check_string_overflow();
                          if (res != null) return res;
                          // sm: fixed off-by-one bug: was (1,1)
                          string_buf.append(yytext().substring(1, 2)); }

<STRING>\\\n	        { curr_lineno++;
                          Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append('\n'); }

<STRING>.               { // sm: previously, the regexp here was [^\\\n\"\0]+
                          // the problem is that inside [] jlex doesn't recognize
                          // metacharacters like \n or \0, so this doesn't do the
                          // right thing.  so while it's inefficient, a correct
                          // implementation is obtained with '.'
                          Symbol res = check_string_overflow();
                          if (res != null) return res;
                          string_buf.append(yytext()); }


<STRING_RECOVER>\"      { yybegin(YYINITIAL); }
<STRING_RECOVER>\n      { curr_lineno++; yybegin(YYINITIAL); }
<STRING_RECOVER>\\.     {}
<STRING_RECOVER>\\\n    { curr_lineno++; }
<STRING_RECOVER>[^\\\n\"]+ {}
<STRING_RECOVER>\\      {}

<YYINITIAL>{ILLEGAL} 	{ return new Symbol(TokenConstants.ERROR, yytext()); }


.                       { System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }
