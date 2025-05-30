--- @type LazySpec
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local noice_api = require("noice.api")
    local kanagawa = require("lualine.themes.kanagawa")
    return {
      options = {
        theme = kanagawa,
        section_separators = { left = "", right = "" },
        -- component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = {
          {
            noice_api.status.mode.get,
            cond = noice_api.status.mode.has,
          },
        },
      },
    }
  end,
}
