;extends

; String content injections (language marker inside the string)

; -- sql
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*-{2,}( )*[sS][qQ][lL]")
 (#set! injection.language "sql"))

; // javascript
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*/{2,}( )*[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]")
 (#set! injection.language "javascript"))

; // typescript
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)//+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]")
 (#set! injection.language "typescript"))

; <!-- html -->
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)\\<\\!-{2,}( )*[hH][tT][mM][lL]( )*-{2,}\\>")
 (#set! injection.language "html"))

; /* css */
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)/\\*+( )*[cC][sS][sS]( )*\\*+/")
 (#set! injection.language "css"))

; # python
((string_content) @injection.content
 (#match? @injection.content "^(\r\n|\r|\n)*#+( )*[pP][yY][tT][hH][oO][nN]")
 (#set! injection.language "python"))

; Comment-based injections (comment before let declaration with raw string)

; // sql
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[sS][qQ][lL]( )*")
 (#set! injection.language "sql"))

; // javascript
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[jJ][aA][vV][aA][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "javascript"))

; // typescript
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "typescript"))

; // html
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[hH][tT][mM][lL]( )*")
 (#set! injection.language "html"))

; // css
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[cC][sS][sS]( )*")
 (#set! injection.language "css"))

; // python
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[pP][yY][tT][hH][oO][nN]( )*")
 (#set! injection.language "python"))

; // lua
((line_comment) @comment .
 (let_declaration
   value: (raw_string_literal
     (string_content) @injection.content))
 (#match? @comment "^//+( )*[lL][uU][aA]( )*")
 (#set! injection.language "lua"))
