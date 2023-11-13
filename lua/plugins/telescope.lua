local builtin = require("telescope.builtin")
local lazy_util = require("lazyvim.util")

local telescope_path_display = function(opts, path)
  local tail = require("telescope.utils").path_tail(path)
  return string.format("%s - %s", tail, path), { { { 1, #tail }, "Constant" } }
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "debugloop/telescope-undo.nvim",
  },
  keys = {
    {
      "<leader>/",
      desc = "Grep (cwd)",
      function()
        builtin.live_grep({ cwd = vim.loop.cwd(), path_display = telescope_path_display })
      end,
    },
    {
      "<leader>.",
      desc = "Grep (root dir)",
      function()
        builtin.live_grep({ cwd = lazy_util.root(), path_display = telescope_path_display })
      end,
    },
    {
      "<leader>ff",
      desc = "Find files (root dir)",
      function()
        builtin.find_files({
          cwd = lazy_util.root(),
          path_display = telescope_path_display,
        })
      end,
    },
    {
      "<leader>fF",
      desc = "Find files (cwd)",
      function()
        builtin.find_files({
          cwd = vim.loop.cwd(),
          path_display = telescope_path_display,
        })
      end,
    },
  },
  opts = function(plugin, opts)
    opts.defaults.layout_strategy = "flex"
    opts.defaults.layout_config = {
      vertical = { width = 0.9 },
    }
    local actions = require("telescope.actions")

    opts.defaults.mappings.i["<C-j>"] = actions.move_selection_next
    opts.defaults.mappings.i["<C-k>"] = actions.move_selection_previous

    opts.defaults.file_ignore_patterns = { "node_modules", ".git", "dist", "^DEPRECATED", "^deprecated" }
    local icons = require("nvim-nonicons")
    opts.defaults.prompt_prefix = "  " .. icons.get("telescope") .. "  "
    -- local telescope = require("telescope")
    -- telescope.load_extension("undo")
  end,
}
