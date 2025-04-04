--- @type LazySpec
return {
  enabled = false,
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },
  opts = function()
    local icons = require("nvim-nonicons")
    return {
      defaults = {
        path_display = {
          "filename_first",
        },
        layout_strategy = "flex",
        layout_config = {
          vertical = { width = 0.9 },
          horizontal = { width = 0.9 },
        },
        prompt_prefix = "  " .. icons.get("telescope") .. "  ",
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
        file_ignore_patterns = { "node_modules", ".git", "dist", "^DEPRECATED", "^deprecated" },
      },
    }
  end,
  keys = function()
    local tel_builtin = require("telescope.builtin")
    local telescope = require("telescope")
    local live_grep_args = require("telescope").extensions.live_grep_args.live_grep_args

    return {
      {
        "<leader>fr",
        function()
          tel_builtin.resume()
        end,
        desc = "[F]ind [R]esume",
      },
      {
        "<leader>/",
        function()
          live_grep_args()

          -- tel_builtin.live_grep({
          --   path_display = telescope_path_display,
          -- })
        end,
        desc = "Find [/] in cwd",
      },
      {
        "<leader>ff",
        function()
          tel_builtin.find_files()
        end,
        desc = "[F]ind [F]iles",
      },
      {
        "<leader>fF",
        function()
          tel_builtin.find_files({
            no_ignore = true,
            hidden = true,
          })
        end,
        desc = "[F]ind [F]iles (include hidden)",
      },
      {
        "<leader>fb",
        function()
          tel_builtin.buffers()
        end,
        desc = "[F]ind [B]uffers",
      },
      {
        "<leader>fs",
        function()
          tel_builtin.lsp_dynamic_workspace_symbols()
        end,
        desc = "[F]ind [S]ymbols",
      },
      {
        "<leader>fn",
        function()
          telescope.extensions.notify.notify()
        end,
        desc = "[F]ind [N]otifications",
      },
    }
  end,
  init = function()
    local telescope = require("telescope")
    telescope.load_extension("fzf")
  end,
}

-- -- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = '[/] Fuzzily search in current buffer' })
--
-- local function telescope_live_grep_open_files()
--   require('telescope.builtin').live_grep {
--     grep_open_files = true,
--     prompt_title = 'Live Grep in Open Files',
--   }
-- end
-- -- vim.keymap.set('n', '<leader>/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
-- vim.keymap.set('n', '<leader>fs', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
-- -- vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- -- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>/', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })
--
