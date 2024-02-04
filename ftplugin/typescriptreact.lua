local moves = { "d", "c", "v", "y" }

local jsx_tag_motion = require("daltonkyemiller.jsx_tag_motion").jsx_tag_motion


for _, value in pairs(moves) do
  vim.keymap.set("n", value .. "it", function()
    jsx_tag_motion(value, "i")
  end, { remap = true, buffer = 0, desc = "Tag" })

  -- I wrote the logic for outer as well, but mini.ai does it properly when I specify the custom query
  -- vim.keymap.set("n", value .. "at", function()
  --   jsx_tag_motion(value, "a")
  -- end, { remap = true, buffer = 0, desc = "Tag" })
end
