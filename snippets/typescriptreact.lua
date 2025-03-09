---@diagnostic disable: undefined-global

local to_pascal_case = function(str)
  -- Function to capitalize the first letter of a word
  local capitalize = function(word)
    return word:sub(1, 1):upper() .. word:sub(2):lower()
  end

  -- Convert kebab-case or snake_case to space-separated words
  str = str:gsub("-", " "):gsub("_", " ")

  -- Convert camelCase to space-separated words
  str = str:gsub("(%l)(%u)", "%1 %2")

  -- Capitalize each word and concatenate them
  local result = str:gsub("(%S+)", capitalize):gsub(" ", "")

  return result
end

local file_name_to_pascal = function()
  local file_name = vim.fn.expand("%:t:r")
  return to_pascal_case(file_name)
end

local props_function = function(args)
  local lines = args[1]
  local props = {}
  for _, line in ipairs(lines) do
    if line:find("^  %S") then
      local prop_name = line:match("(%S+):")
      table.insert(props, prop_name)
    end
  end
  return table.concat(props, ", ")
end

local file_name_function = function()
  return sn(nil, {
    i(1, file_name_to_pascal()),
  })
end

local dynamic_name_function = function(args)
  local name = args[1]
  return sn(1, {
    i(1, name),
  })
end

local react_component_snippet_template = [[
type {}Props = {{{}}}

export function {}(props: {}Props){{
  const {{ {} }} = props;

  return (<section>{}</section>)
}}
]]

local react_component_snippet = s(
  {
    trig = "rc",
    name = "React Component",
    desc = "Creates a React component from file name",
  },
  fmt(react_component_snippet_template, {
    d(1, file_name_function),
    i(2),
    rep(1),
    rep(1),
    f(props_function, { 2 }),
    d(3, dynamic_name_function, { 1 }),
  })
)

local expo_react_component_snippet_template = [[
import { SafeAreaView } from "react-native-safe-area-context";

export default function <>(){

  return (
    <<SafeAreaView>>
      <>
    <</SafeAreaView>>
  )
}
]]

local expo_react_component_snippet = s(
  {
    trig = "erc",
    name = "Expo React Component",
    desc = "Creates a Expo React component from file name",
  },
  fmta(expo_react_component_snippet_template, {
    d(1, file_name_function),
    i(2),
  })
)

local remix_component_snippet_template = [[
import type { ActionFunctionArgs, LoaderFunctionArgs } from "@remix-run/node";

<>

<>

export default function <>(){

  return (<<main>><><</main>>)
}
]]

local remix_component_snippet = s(
  {
    trig = "rmr",
    name = "Remix Route",
    desc = "Creates a Remix route from file name",
  },
  fmta(remix_component_snippet_template, {
    c(1, {
      fmta("export const action = async ({ <> }: ActionFunctionArgs) =>> {}", {
        i(1, "request"),
      }),
      t(""),
    }),
    c(2, {
      fmta("export const loader = async ({ <> }: LoaderFunctionArgs) =>> {}", {
        i(1, "request"),
      }),
      t(""),
    }),
    d(3, file_name_function),
    d(4, dynamic_name_function, { 3 }),
  })
)

return {
  react_component_snippet,
  remix_component_snippet,
  expo_react_component_snippet,
}
