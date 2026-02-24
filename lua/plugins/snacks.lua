local dropdown_layout = {
  --- @type snacks.picker.layout.Config
  layout = {
    backdrop = true,
    row = 1,
    width = 0.4,
    min_width = 80,
    height = 0.9,
    border = "none",
    box = "vertical",
    { win = "preview", title = "{preview}", height = 0.5, border = false },
    { win = "input", height = 1, border = "rounded" },
    { win = "list", border = "hpad" },
    -- {
    --   box = "vertical",
    --   border = "top",
    --   title = nil,
    --   -- title = "{title} {live} {flags}",
    --   title_pos = "center",
    --   { win = "input", height = 1, border = "bottom" },
    --   { win = "list", border = false },
    -- },
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
      sources = {
        select = {
          layout = { hidden = { "preview" } },
        },
        gh_issue = {},
        gh_pr = {},
        ---@class snacks.picker.explorer.Config
        explorer = {
          auto_close = true,
          actions = {
            ---@param picker snacks.picker
            ---@param item snacks.picker.Item
            yank_choice = function(picker, item)
              local filepath = item.file
              if not filepath then return end
              local filename = vim.fn.fnamemodify(filepath, ":t")
              local modify = vim.fn.fnamemodify

              local vals = {
                ["BASENAME"] = modify(filename, ":r"),
                ["EXTENSION"] = modify(filename, ":e"),
                ["FILENAME"] = filename,
                ["PATH (CWD)"] = modify(filepath, ":."),
                ["PATH (HOME)"] = modify(filepath, ":~"),
                ["PATH"] = filepath,
                ["URI"] = vim.uri_from_fname(filepath),
              }

              local options = vim.tbl_filter(function(val)
                return vals[val] ~= ""
              end, vim.tbl_keys(vals))
              if vim.tbl_isempty(options) then
                vim.notify("No values to copy", vim.log.levels.WARN)
                return
              end
              table.sort(options)
              picker:close()
              vim.ui.select(options, {
                prompt = "Choose to copy to clipboard:",
                format_item = function(choice)
                  return ("%s: %s"):format(choice, vals[choice])
                end,
              }, function(choice)
                local result = vals[choice]
                if result then
                  vim.notify(("Copied: `%s`"):format(result))
                  vim.fn.setreg("+", result)
                end
              end)
            end,
          },
          win = {
            list = {
              keys = {
                ["Y"] = "yank_choice",
              },
            },
          },
        },
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
        "<leader>gi",
        function()
          snacks.picker.gh_issue()
        end,
        desc = "GitHub Issues (open)",
      },
      {
        "<leader>gI",
        function()
          snacks.picker.gh_issue({ state = "all" })
        end,
        desc = "GitHub Issues (all)",
      },
      {
        "<leader>gp",
        function()
          snacks.picker.gh_pr()
        end,
        desc = "GitHub Pull Requests (open)",
      },
      {
        "<leader>gP",
        function()
          snacks.picker.gh_pr({ state = "all" })
        end,
        desc = "GitHub Pull Requests (all)",
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
      {
        "<leader>e",
        function()
          require("snacks.explorer").open()
        end,
        desc = "[E]xplorer",
      },
    }
  end,
}
