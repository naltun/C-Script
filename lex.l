%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "y.tab.h"

static char *
unquote(const char *yytext)
{
    size_t n = strlen(yytext);
    char *out = malloc(n);
    size_t j = 0;

    for(int i = 1; i + 1 < n; ++i) {
        if (yytext[i] == '\\' && i + 1 < n - 1) {
            ++i;
            switch (yytext[i]) {
                case 'n': out[j++] = '\n'; break;
                case 't': out[j++] = '\t'; break;
                case 'r': out[j++] = '\r'; break;
                case '"': out[j++] = '"'; break;
                case '\\': out[j++] = '\\'; break;
                default: out[j++] = yytext[i]; break;
            }
        } else
            out[j++] = yytext[i];
    }
    out[j] = '\0';
    return out;
}
%}

%%

[ \t\r\n]+ ;  /* whitespace */
^"#!".*    ;  /* shebang */
"//".*     ;  /* comment */

"void"   { return T_VOID; }
"int"    { return T_INT; }
"str"    { return T_STR; }
"if"     { return IF; }
"else"   { return ELSE; }
"return" { return RETURN; }

"=="        { return EQEQ; }
[{}() ;,:=] { return yytext[0]; }

[0-9]+               { yylval.ival = strtol(yytext, NULL, 10); return INT_LIT; }
\"([^\"\\\n]|\\.)*\" { yylval.sval = unquote(yytext); return STR_LIT; }

[A-Za-z_][A-Za-z0-9_]* { yylval.sval = strdup(yytext); return IDENT; }

%%

int
yywrap(void)
{
    return 1;
}
