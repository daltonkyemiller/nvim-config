local ts_js_query = [[
;query
;; comment {name} injection
((comment)
 @comment .
 (lexical_declaration
   (variable_declarator 
     value: [
             (string(string_fragment)@injection.content) 
             (template_string(string_fragment)@injection.content)
             (call_expression(template_string(string_fragment)@injection.content))
             ]@injection.content)  
   )
  (#match? @comment "{match}")
  (#set! injection.language "{name}")
 )
        ]]

--- @type LazySpec
return {
  "dariuscorvus/tree-sitter-language-injection.nvim",
  opts = {
    lua = {
      comment = {
        langs = {
          { name = "typescript", match = "^--+( )*{lang}( )*" },
          { name = "typescriptreact", match = "^--+( )*{lang}( )*" },
          { name = "lua", match = "^--+( )*{lang}( )*" },
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
    typescript = {
      comment = {
        langs = {
          { name = "lua", match = "^//+( )*lua( )*" },
        },
        query = ts_js_query,
      },
    },
    javascript = {
      comment = {
        langs = {
          { name = "lua", match = "^//+( )*lua( )*" },
        },
        query = ts_js_query,
      },
    },
  },
}
