;extends

; -- typescript
; comment before variable assignment injects typescript
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "typescript"))

; -- typescriptreact
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT][rR][eE][aA][cC][tT]( )*")
 (#set! injection.language "typescriptreact"))

; -- lua
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[lL][uU][aA]( )*")
 (#set! injection.language "lua"))

; -- sql
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[sS][qQ][lL]( )*")
 (#set! injection.language "sql"))

; -- html
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[hH][tT][mM][lL]( )*")
 (#set! injection.language "html"))

; -- javascript
((comment) @comment .
 (variable_declaration
   (assignment_statement
     (expression_list
       (string
         (string_content) @injection.content))))
 (#match? @comment "^--+( )*[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "javascript"))
