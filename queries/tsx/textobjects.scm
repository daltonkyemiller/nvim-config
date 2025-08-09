((jsx_element) @tag.outer)

((jsx_self_closing_element) @tag.outer)

((jsx_element (jsx_opening_element) . (_) @tag.inner . (_) @_end . (jsx_closing_element)))

(
 (jsx_element  (jsx_opening_element (jsx_attribute) @parameters.outer . (jsx_attribute)))
)

(
 (jsx_element  (jsx_opening_element (jsx_attribute) @parameter.outer))
)


(
 (jsx_self_closing_element (jsx_attribute) @parameters.outer . (jsx_attribute))
)

(
 (jsx_self_closing_element (jsx_attribute) @parameter.outer)
)
