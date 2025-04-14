;extends

; query
;; comment typescript injection
((comment)
 @comment .
 (variable_declaration 
   (assignment_statement 
     (expression_list 
       (string 
         (string_content) @injection.content)
       )
     )
   )
 (#match? @comment "^--+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT]( )*")
 (#set! injection.language "typescript")
)
          
; query
;; comment typescriptreact injection
((comment)
 @comment .
 (variable_declaration 
   (assignment_statement 
     (expression_list 
       (string 
         (string_content) @injection.content)
       )
     )
   )
 (#match? @comment "^--+( )*[tT][yY][pP][eE][sS][cC][rR][iI][pP][tT][rR][eE][aA][cC][tT]( )*")
 (#set! injection.language "typescriptreact")
)
          
; query
;; comment lua injection
((comment)
 @comment .
 (variable_declaration 
   (assignment_statement 
     (expression_list 
       (string 
         (string_content) @injection.content)
       )
     )
   )
 (#match? @comment "^--+( )*[lL][uU][aA]( )*")
 (#set! injection.language "lua")
)
          