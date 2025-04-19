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
  },
  --- @param _ LazyPlugin
  --- @return table
  opts = function(_, opts)
    local non_icons = require("nvim-nonicons")

    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")

    opts.event_handlers = opts.event_handlers or {}

    vim.list_extend(opts.event_handlers, {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
      {
        event = events.NEO_TREE_BUFFER_ENTER,
        handler = function(_)
          vim.opt_local.signcolumn = "auto"
          vim.opt_local.relativenumber = true
        end,
      },
    })

    opts.auto_clean_after_session_restore = true
    opts.default_source = "filesystem"
    opts.close_if_last_window = true
    opts.sources = { "filesystem", "buffers" }
    opts.source_selector = {
      winbar = true,
      content_layout = "center",
      sources = {
        { source = "filesystem" },
        { source = "buffers" },
        -- { source = "git_status" },
        -- { source = "diagnostics" },
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
      rename_ts = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        local file_name = vim.fn.fnamemodify(path, ":t")
        local path_without_file_name = vim.fn.fnamemodify(path, ":h")
        vim.ui.input({ prompt = "Rename to: ", default = file_name }, function(input)
          if input == nil or input == "" or input == file_name then return end
          vim.cmd("VtsRename" .. path .. " " .. path_without_file_name .. "/" .. input)
        end)
      end,
      system_open = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        -- macOs: open file in default application in the background.
        vim.fn.jobstart({ "open", path }, { detach = true })
      end,
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
      copy_selector = function(state)
        local node = state.tree:get_node()
        local filepath = node:get_id()
        local filename = node.name
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
        vim.ui.select(options, {
          prompt = "Choose to copy to clipboard:",
          format_item = function(item)
            return ("%s: %s"):format(item, vals[item])
          end,
        }, function(choice)
          local result = vals[choice]
          if result then
            vim.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
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
        ["?"] = false,
        ["O"] = "system_open",
        ["l"] = "child_or_open",
        ["h"] = "parent_or_close",
        ["Y"] = "copy_selector",
        ["R"] = "rename_ts",
      },
    }
    -- opts.default_source = "filesystem"

    opts.filesystem = {
      hijack_netrw_behavior = "disabled",
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    }
    opts.use_popups_for_input = false

    return opts
  end,
}
