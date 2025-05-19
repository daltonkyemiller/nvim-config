---@type LazySpec
return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("dbee").setup({
      drawer = {
        mappings = {
          -- manually refresh drawer
          { key = "r", mode = "n", action = "refresh" },
          -- actions perform different stuff depending on the node:
          -- action_1 opens a note or executes a helper
          { key = "<CR>", mode = "n", action = "action_1" },
          -- action_2 renames a note or sets the connection as active manually
          { key = "cw", mode = "n", action = "action_2" },
          -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
          { key = "dd", mode = "n", action = "action_3" },
          -- these are self-explanatory:
          { key = "h", mode = "n", action = "collapse" },
          { key = "l", mode = "n", action = "expand" },
          -- { key = "o", mode = "n", action = "toggle" },
          -- mappings for menu popups:
          { key = "<CR>", mode = "n", action = "menu_confirm" },
          { key = "y", mode = "n", action = "menu_yank" },
          { key = "<Esc>", mode = "n", action = "menu_close" },
          { key = "q", mode = "n", action = "menu_close" },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>db",
      function()
        require("dbee").toggle()
      end,
      desc = "Toggle DBee",
    },
  },
}
