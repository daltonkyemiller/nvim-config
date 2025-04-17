local telescope_layout = {
  reverse = true,
  layout = {
    box = "horizontal",
    backdrop = false,
    width = 0.8,
    height = 0.9,
    border = "none",
    {
      box = "vertical",
      { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
      { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
    },
    {
      win = "preview",
      title = "{preview:Preview}",
      width = 0.45,
      border = "rounded",
      title_pos = "center",
    },
  },
}

local dropdown_layout = {
  layout = {
    backdrop = false,
    row = 1,
    width = 0.4,
    min_width = 80,
    height = 0.9,
    border = "none",
    box = "vertical",
    { win = "preview", title = "{preview}", height = 0.5, border = "rounded" },
    {
      box = "vertical",
      border = "rounded",
      title = "{title} {live} {flags}",
      title_pos = "center",
      { win = "input", height = 1, border = "bottom" },
      { win = "list", border = "none" },
    },
  },
}
--- @type LazySpec
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    -- bigfile = { enabled = true },
    -- dashboard = { enabled = true },
    -- indent = { enabled = true },
    -- input = { enabled = true },
    picker = {
      enabled = true,
      layout = dropdown_layout,

      win = {
        keys = {
          ["<CR>"] = { "confirm", mode = { "n", "i" } },
        },
      },
    },
    -- notifier = { enabled = true },
    -- quickfile = { enabled = true },
    -- scroll = { enabled = true },
    -- statuscolumn = { enabled = true },
    -- words = { enabled = true },
  },
  keys = function()
    local snacks = require("snacks")
    return {
      {
        "<leader><space>",
        function()
          snacks.picker.smart()
        end,
        desc = "Find Files Smart",
      },

      {
        "<leader>fr",
        function()
          snacks.picker.resume()
        end,
        desc = "[F]ind [R]esume",
      },
      {
        "<leader>fh",
        function()
          snacks.picker.search_history()
        end,
        desc = "[F]ind [H]istory",
      },

      {
        "<leader>fs",
        function()
          snacks.picker.lsp_workspace_symbols()
        end,
        desc = "[F]ind Workspace [S]ymbols",
      },

      {
        "<leader>fe",
        function()
          snacks.picker.explorer()
        end,
        desc = "[F]ind [E]xplorer",
      },
      {
        "<leader>ff",
        function()
          snacks.picker.smart()
        end,
        desc = "[F]ind [F]iles",
      },
      { "<leader>fb", snacks.picker.buffers, desc = "[F]ind [B]uffers" },
      {
        "<leader>/",
        function()
          snacks.picker.grep()
        end,
        desc = "Find grep [/] in cwd",
      },
    }
  end,
}
