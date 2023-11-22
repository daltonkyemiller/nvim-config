((jsx_element) @tag.outer)
((jsx_self_closing_element) @tag.outer)


(
 (jsx_element  (jsx_opening_element (jsx_attribute) @_start . (jsx_attribute) @_end))
 (#make-range! "parameters.outer" @_start @_end)
)

(
 (jsx_self_closing_element (jsx_attribute) @_start . (jsx_attribute) @_end)
 (#make-range! "parameters.outer" @_start @_end)
)
