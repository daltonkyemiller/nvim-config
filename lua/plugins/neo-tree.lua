--- @type LazySpec
return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    {
      "<leader>e",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd(), reveal = true })
      end,
      desc = "Explorer Neotree (cwd)",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    { "yamatsum/nvim-nonicons", config = true },
  },
  opts = function(_, opts)
    local non_icons = require("nvim-nonicons")
    opts.auto_clean_after_session_restore = true
    opts.default_source = "filesystem"
    opts.close_if_last_window = true
    opts.sources = { "filesystem", "buffers", "git_status" }
    opts.source_selector = {
      winbar = true,
      content_layout = "center",
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        { source = "git_status" },
        { source = "diagnostics" },
      },
    }
    opts.event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
        end,
      },
    }

    opts.default_component_configs = {
      indent = { padding = 0 },
      icon = {
        folder_closed = non_icons.get("file-directory-fill"),
        folder_open = non_icons.get("file-directory-open-fill"),
      },
      modified = { symbol = "" },
      git_status = {
        symbols = {
          added = "",
          deleted = "",
          modified = "",
          renamed = "➜",
          untracked = "",
          ignored = "",
          unstaged = "",
          staged = "",
          conflict = "",
        },
      },
    }

    opts.commands = {
      child_or_open = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          if not node:is_expanded() then -- if unexpanded, expand
            state.commands.toggle_node(state)
          else -- if expanded and has children, seleect the next child
            require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
          end
        else -- if not a directory just open it
          state.commands.open(state)
        end
      end,
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
      go_to_last_child_in_dir = function(state)
        local node = state.tree:get_node()
        if node.type == "directory" or node:has_children() then
          local children = node:get_child_ids()
          local last_child = children[#children]
          require("neo-tree.ui.renderer").focus_node(state, last_child)
        end
      end,
      go_to_parent = function(state)
        local node = state.tree:get_node()
        require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
      end,
    }
    opts.window = {
      position = "float",
      width = 30,
      -- popup = {
      --   size = { width = '80', height = '60' },
      --   position = '50%',
      -- },
      mappings = {
        ["/"] = false,
        ["z"] = false,
        ["l"] = "child_or_open",
        ["h"] = "parent_or_close",
      },
    }
    -- opts.default_source = "filesystem"

    opts.filesystem = {
      hijack_netrw_behavior = "disabled",
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    }

    opts.event_handlers = {
      {
        event = "neo_tree_buffer_enter",
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
        end,
      },
    }

    return opts
  end,
}
