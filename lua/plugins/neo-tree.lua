return {
  "nvim-neo-tree/neo-tree.nvim",
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
    }
    opts.window.position = "float"
    opts.window.width = 30
    opts.window.mappings["l"] = "child_or_open"
    opts.window.mappings["h"] = "parent_or_close"
    opts.window.mappings["[b"] = "prev_source"
    opts.window.mappings["]b"] = "next_source"

    opts.default_source = "filesystem"

    -- opts.filesystem = {
    --   bind_to_cwd = false,
    --   follow_current_file = { enabled = true },
    --   hijack_netrw_behavior = "open_current",
    --   use_libuv_file_watcher = true,
    -- }
    --
    opts.filesystem.hijack_netrw_behavior = "open_current"
    opts.filesystem.follow_current_file = { enabled = true }
    opts.filesystem.use_libuv_file_watcher = true

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
