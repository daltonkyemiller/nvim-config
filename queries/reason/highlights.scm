;; (call (expression (_) @function))
;;
;; (type_identifier) @type
;; (type_variant_identifier) @constructor
;; (variant_identifier) @constructor
;; (constructor_name) @constructor
;; (module_name) @module
;;
;; (comment) @comment
;;
;; (number) @string
;;
;; ["open" "module"
;;  "let"
;;  "type"
;;  "switch"] @keyword
;;
;; ["?"] @operator
;; "." @punctuation
;;
;; ; ["+" "/" "*" "-"] @operator
;;
;; ["if" "else"] @keyword.conditional

;; OCAML

; Modules
;--------
[(module_name)
 (module_type_name)] @module

; Types
;------
((type_constructor) @type.builtin
  (#any-of? @type.builtin
    "int" "char" "bytes" "string" "float" "bool" "unit" "exn" "array" "list" "option" "int32"
    "int64" "nativeint" "format6" "lazy_t"))

[(class_name)
 (class_type_name)
 (type_constructor)] @type

[(constructor_name)
 (tag)] @constructor

; Variables
;----------
[(value_name)
 (type_variable)] @variable

(value_pattern) @variable.parameter

; Functions
;----------

; (let_binding
;   pattern: (value_name) @function
;   (parameter))

; (let_binding
;   pattern: (value_name) @function
;   body:
;     [(fun_expression)
;      (function_expression)])


(value_specification
  (value_name) @function)

(external
  (value_name) @function)

(method_name) @function.method

; Application
;------------
(infix_expression
  left:
    (value_path
      (value_name) @function.call)
  operator: (concat_operator) @_operator
  (#eq? @_operator "@@"))

(infix_expression
  operator: (rel_operator) @_operator
  right:
    (value_path
      (value_name) @function.call)
  (#eq? @_operator "|>"))

; (application_expression
;   function:
;     (value_path
;       (value_name) @function.call))

((value_name) @function.builtin
  (#any-of? @function.builtin "raise" "raise_notrace" "failwith" "invalid_arg"))

; Fields
;-------
[(field_name)
 (instance_variable_name)] @variable.member

; Labels
; ------
(label_name) @label

; Constants
;----------
; Don't let normal parens take priority over this
((unit) @constant.builtin
  (#set! "priority" 105))

(boolean) @boolean

[(number)
 (signed_number)] @number

(character) @character

(string) @string

(quoted_string
  "{" @string
  "}" @string) @string

(escape_sequence) @string.escape

[(conversion_specification)
 (pretty_printing_indication)] @string.special

; Keywords
;---------
[
  "and"
  "as"
  "assert"
  "begin"
  "class"
  "constraint"
  "end"
  "external"
  "in"
  "inherit"
  "initializer"
  "let"
  "match"
  "method"
  "module"
  "new"
  "object"
  "of"
  "sig"
  "struct"
  "type"
  "val"
  "when"
  "with" ] @keyword

[
  "lazy"
  "mutable"
  "nonrec"
  "rec"
  "private"
  "virtual" ] @type.qualifier

; [
;   "fun"
;   "function"
;   "functor" ] @keyword.function

[
  "if"
  "then"
  "else"] @keyword.conditional

[
  "exception"
  "try" ] @keyword.exception

[
  "include"
  "open" ] @keyword.import

[
  "for"
  "to"
  "downto"
  "while"
  "do"
  "done" ] @keyword.repeat

; Punctuation
;------------

; (attribute
;   [
;     "[@"
;     "]" ] @punctuation.special)

(item_attribute
  ["[@@" "]"] @punctuation.special)

(floating_attribute
  ["[@@@" "]"] @punctuation.special)

(extension
  ["[%" "]"] @punctuation.special)

(item_extension
  ["[%%" "]"] @punctuation.special)

(quoted_extension
  ["{%" "}"] @punctuation.special)

(quoted_item_extension
  ["{%%" "}"] @punctuation.special)

"%" @punctuation.special

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "[|"
  "|]"
  "[<"
  "[>" ] @punctuation.bracket

(object_type
  ["<" ">"] @punctuation.bracket)

[
  ","
  "."
  ";"
  ":"
  "="
  "|"
  "~"
  "?"
  "+"
  "-"
  "!"
  ">"
  "&"
  "->"
  ";;"
  ":>"
  ; "+="
  ":="
  ".." ] @punctuation.delimiter

; Operators
;----------
[
  (prefix_operator)
  (sign_operator)
  (pow_operator)
  (mult_operator)
  (add_operator)
  (concat_operator)
  (rel_operator)
  (and_operator)
  (or_operator)
  (assign_operator)
  (hash_operator)
  (indexing_operator)
  (let_operator)
  (and_operator)
  (match_operator)] @operator

; (match_expression
;   (match_operator)) @keyword

(value_definition
  [(let_operator)
   (let_and_operator)] @keyword)

[
  "*"
  "#"
  "::"
  "<-" ] @operator

; Attributes
;-----------
(attribute_id) @attribute

; Comments
;---------
[
  (comment)
  (line_number_directive)
  (directive)] @comment @spell

(shebang) @keyword.directive


;; JSX

(jsx_element
  open_tag:
    (jsx_opening_element
      ["<" ">"] @tag.delimiter))

(jsx_element
  close_tag:
    (jsx_closing_element
      ["</" ">"] @tag.delimiter))

(jsx_self_closing_element
  ["<" "/>"] @tag.delimiter)

(jsx_attribute
  (property_identifier) @tag.attribute)

(jsx_opening_element
  name: (identifier) @tag.builtin)

(jsx_closing_element
  name: (identifier) @tag.builtin)

(jsx_self_closing_element
  name: (identifier) @tag.builtin)

(jsx_opening_element
  ((identifier) @tag
    (#lua-match? @tag "^[A-Z]")))

; ; Handle the dot operator effectively - <My.Component>
; (jsx_opening_element
;   (member_expression
;     (identifier) @tag.builtin
;     (property_identifier) @tag))

(jsx_closing_element
  ((identifier) @tag
    (#lua-match? @tag "^[A-Z]")))

; ; Handle the dot operator effectively - </My.Component>
; (jsx_closing_element
;   (member_expression
;     (identifier) @tag.builtin
;     (property_identifier) @tag))

(jsx_self_closing_element
  ((identifier) @tag
    (#lua-match? @tag "^[A-Z]")))

; ; Handle the dot operator effectively - <My.Component />
; (jsx_self_closing_element
;   (member_expression

