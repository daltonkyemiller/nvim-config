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
    notifier = { enabled = true, top_down = false },
    lazygit = { enabled = true },
    image = { enabled = true },
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      right = { "fold", "git" }, -- priority of signs on the right (high to low)
      folds = {
        open = false, -- show open fold icons
        git_hl = false, -- use Git Signs hl for fold icons
      },
      git = {
        -- patterns to match Git signs
        patterns = { "GitSign", "MiniDiffSign" },
      },
      refresh = 50, -- refresh at most every 50ms
    },
    scroll = {
      enabled = false,
      animate = {
        animate = {
          duration = { step = 10, total = 100 },
          easing = "linear",
        },
        -- faster animation when repeating scroll after delay
        animate_repeat = {
          delay = 100, -- delay in ms before using the repeat animation
          duration = { step = 5, total = 50 },
          easing = "linear",
        },
      },
    },
    words = { enabled = true },
    indent = { enabled = true },
  },
  keys = function()
    local snacks = require("snacks")
    return {
      {
        "gr",
        function()
          snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = "[G]oto [R]eferences",
      },
      {
        "]w",
        function()
          snacks.words.jump(1, true)
        end,
        desc = "Next [W]ord",
      },
      {
        "[w",
        function()
          snacks.words.jump(-1, true)
        end,
        desc = "Previous [W]ord",
      },
      {
        "<leader>gb",
        function()
          snacks.gitbrowse.open()
        end,
        desc = "[G]it [B]rowse",
      },
      {
        "<leader>gg",
        snacks.lazygit.open,
        desc = "Open Lazy[G]it",
      },
      {
        "<leader>nd",
        function()
          snacks.notifier.hide()
        end,
        desc = "[N]otify [D]ismiss All",
      },
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
