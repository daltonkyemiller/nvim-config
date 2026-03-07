;extends

; String content injections (language marker inside the string)

; -- sql
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*-{2,}( )*[sS][qQ][lL]")
 (#set! injection.language "sql"))

; // javascript
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*/{2,}( )*[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]")
 (#set! injection.language "javascript"))

; // typescript
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)//+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]")
 (#set! injection.language "typescript"))

; <!-- html -->
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)\\<\\!-{2,}( )*[hH][tT][mM][lL]( )*-{2,}\\>")
 (#set! injection.language "html"))

; /* css */
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)/\\*+( )*[cC][sS][sS]( )*\\*+/")
 (#set! injection.language "css"))

; # python
((string_fragment) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*#+( )*[pP][yY][tT][hH][oO][nN]")
 (#set! injection.language "python"))

; Comment-based injections (comment before variable declaration)

; // lua
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*lua( )*")
 (#set! injection.language "lua"))

; // sql
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*sql( )*")
 (#set! injection.language "sql"))

; // typescript
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "typescript"))

; // javascript
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "javascript"))

; // python
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*[pP][yY][tT][hH][oO][nN]( )*")
 (#set! injection.language "python"))

; // css
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*[cC][sS][sS]( )*")
 (#set! injection.language "css"))

; // html
((comment) @comment .
 (lexical_declaration
   (variable_declarator
     value: [(string (string_fragment) @injection.content)
             (template_string (string_fragment) @injection.content)
             (call_expression (template_string (string_fragment) @injection.content))]))
 (#match? @comment "^//+( )*[hH][tT][mM][lL]( )*")
 (#set! injection.language "html"))
