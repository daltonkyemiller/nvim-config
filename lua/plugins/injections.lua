--- @type LazySpec
return {
  "dariuscorvus/tree-sitter-language-injection.nvim",
  opts = {
    lua = {
      comment = {
        langs = {
          { name = "typescript", match = "^--+( )*{lang}( )*" },
          { name = "typescriptreact", match = "^--+( )*{lang}( )*" },
        },
        query = [[
; query
;; comment {name} injection
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
 (#match? @comment "{match}")
 (#set! injection.language "{name}")
)
          ]],
      },
    },
  },
}
