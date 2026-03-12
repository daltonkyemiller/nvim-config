; extends

((comment) @injection.content
  (#set! injection.language "comment"))

; bun -e "js", node -e "js", deno eval "js"
(command
  name: (command_name
    (word) @_cmd
    (#any-of? @_cmd "node" "bun" "deno"))
  argument: (string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "javascript"))
