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

---@type snacks.win | nil
local open_term

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
      exclude = {
        "**/sessions",
      },

      win = {
        keys = {
          ["<CR>"] = { "confirm", mode = { "n", "i" } },
        },
      },
    },
    notifier = { enabled = true, top_down = false },
    lazygit = {
      enabled = true,
      config = {
        os = {
          editPreset = "nvim-remote",
          -- Edit in new buffer, not new tab(the default)
          edit = '[[ -z "$NVIM" ]] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote {{filename}})',
        },
      },
    },
    image = {
      enabled = true,
    },
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
        mode = { "n", "x" },
        "<leader>gbb",
        function()
          snacks.gitbrowse.open({
            what = "branch",
          })
        end,
        desc = "[G]it [B]rowse [B]ranch",
      },
      {
        mode = { "n", "x" },
        "<leader>gbc",
        function()
          snacks.gitbrowse.open({
            what = "commit",
          })
        end,
        desc = "[G]it [B]rowse [C]ommit",
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
          snacks.picker.files()
        end,
        desc = "[F]ind [F]iles",
      },
      {
        "<leader>fn",
        function()
          snacks.picker.notifications()
        end,
        desc = "[F]ind [N]otifications",
      },
      { "<leader>fb", snacks.picker.buffers, desc = "[F]ind [B]uffers" },
      {
        "<leader>/",
        function()
          snacks.picker.grep()
        end,
        desc = "Find grep [/] in cwd",
      },
      {
        "<M-t>",
        function()
          local terminal = require("snacks.terminal")
          terminal.toggle(nil, {
            win = {
              position = "right",
            },
          })
          -- if open_term then
          --   open_term:close()
          --   open_term = nil
          -- else
          --   open_term = terminal.open(nil, {
          --     win = {
          --       position = "right",
          --     }
          --   })
          -- end
        end,
        mode = { "n", "t" },
        desc = "Open [T]erminal",
      },
      {
        "<M-f>",
        function()
          local terminal = require("snacks.terminal")
          local terms = terminal:list()
          local term = terms[1]
          if term then
            local current_win = vim.api.nvim_get_current_win()
            local term_win = term.win
            local last_focused_win = vim.fn.win_getid(vim.fn.winnr("#"))
            if term_win == current_win then
              vim.api.nvim_set_current_win(last_focused_win)
            else
              term:focus()
            end
          end
        end,
        mode = { "n", "t" },
        desc = "Toggle [F]ocus Terminal",
      },
    }
  end,
}
