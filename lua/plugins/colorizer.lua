---@type LazySpec
return {
  "catgoose/nvim-colorizer.lua",
  event = "BufReadPre",
  -- enabled = false,
  opts = {
    filetypes = { "*" },
    user_default_options = {
      mode = "virtualtext",
      virtualtext = "■",
      virtualtext_inline = true,
      tailwind = true,
      css = true,
    },
  },
}

-- #ef00ff
-- bg-orange-500
-- hsl(0, 100%, 50%)
