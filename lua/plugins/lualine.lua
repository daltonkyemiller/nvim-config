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
        lualine_c = {
          {
            function()
              return " "
            end,
            color = function()
              local status = require("sidekick.status").get()
              if status then
                return status.kind == "Error" and "DiagnosticError" or status.busy and "DiagnosticWarn" or "Special"
              end
            end,
            cond = function()
              local status = require("sidekick.status")
              return status.get() ~= nil
            end,
          },
        },
      },
    }
  end,
}
