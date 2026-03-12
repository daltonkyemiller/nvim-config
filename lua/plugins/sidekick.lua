--- @type LazySpec
return {
  "folke/sidekick.nvim",
  lazy = false,
  ---@class sidekick.Config
  opts = {
    jump = {
      jumplist = true, -- add an entry to the jumplist
    },
    signs = {
      enabled = true, -- enable signs by default
      icon = " ",
    },
    nes = {
      ---@type boolean|fun(buf:integer):boolean?
      enabled = false,
      debounce = 100,
      trigger = {
        -- events that trigger sidekick next edit suggestions
        events = { "InsertLeave", "TextChanged", "User SidekickNesDone" },
      },
      clear = {
        -- events that clear the current next edit suggestion
        events = { "TextChangedI", "TextChanged", "BufWritePre", "InsertEnter" },
        esc = true, -- clear next edit suggestions when pressing <Esc>
      },
      ---@class sidekick.diff.Opts
      ---@field inline? "words"|"chars"|false Enable inline diffs
      diff = {
        inline = "words",
      },
    },
    -- Work with AI cli tools directly from within Neovim
    cli = {
      watch = true, -- notify Neovim of file changes done by AI CLI tools
      win = {
        wo = {}, ---@type vim.wo
        bo = {}, ---@type vim.bo
        layout = "right", ---@type "float"|"left"|"bottom"|"top"|"right"
        --- Options used when layout is "float"
        ---@type vim.api.keyset.win_config
        float = {
          width = 0.9,
          height = 0.9,
        },
        -- Options used when layout is "left"|"bottom"|"top"|"right"
        ---@type vim.api.keyset.win_config
        split = {
          width = 80,
          height = 20,
        },
        --- CLI Tool Keymaps
        --- default mode is `t`
        ---@type table<string, sidekick.cli.Keymap|false>
        keys = {
          stopinsert = { "<esc><esc>", "stopinsert", mode = "t" }, -- enter normal mode
          hide_n = { "q", "hide", mode = "n" }, -- hide from normal mode
          hide_c = { "<M-c>", "hide" }, -- hide from terminal mode
          hide_o = { "<M-o>", "hide" }, -- hide from terminal mode
          -- alt shift + c to copy the response
          copy_response = {
            "<M-y>",
            function(t)
              vim.fn.jobstart({ "/home/dalton/scripts/claude-response.sh", "--copy", "1" })
            end,
          },
          win_p = { "<c-w>p", "blur" }, -- leave the cli window
          blur = { "<M-b>", "blur" }, -- leave the cli window
          prompt = { "<c-p>", "prompt" }, -- insert prompt or context
          send_at = {
            "\\@",
            function(t)
              t:send("@")
            end,
          },
          pick_file = {
            "@",
            function(t)
              local pid = t.pids[1]
              local snacks_picker_proc = require("snacks.picker.source.proc")
              local snacks_picker = require("snacks.picker")
              local devicons = require("nvim-web-devicons")
              local script_location = vim.fn.stdpath("config") .. "/scripts/claude_find.sh"
              local cwd = vim.uv.cwd()
              local session_cwd = t.cwd and vim.fn.resolve(t.cwd) or cwd
              snacks_picker.pick({
                format = function(item, picker)
                  if item.is_file then return snacks_picker.format.file(item, picker) end
                  local agent_icon, icon_hl = devicons.get_icon("ai")
                  return {
                    { agent_icon, icon_hl },
                    { " ", virtual = true },
                    { item.text },
                  }
                end,
                finder = function(opts, ctx)
                  local last_buf_num = vim.fn.bufnr("#")
                  local last_buf_name = last_buf_num and last_buf_num ~= -1 and vim.fn.bufname(last_buf_num) or nil

                  local args = { "-p", tostring(pid) }
                  if last_buf_name then
                    table.insert(args, "-f")
                    table.insert(args, vim.api.nvim_buf_get_name(vim.fn.bufnr("#")))
                  end

                  -- Add all other loaded buffers (excluding terminal buffers)
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) and buf ~= last_buf_num then
                      local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
                      -- Skip terminal and other special buffer types
                      if buf_type == "" or buf_type == "acwrite" then
                        local buf_name = vim.api.nvim_buf_get_name(buf)
                        if buf_name and buf_name ~= "" then
                          table.insert(args, "-b")
                          table.insert(args, buf_name)
                        end
                      end
                    end
                  end

                  return snacks_picker_proc.proc(
                    ctx:opts({
                      cmd = script_location,
                      args = #args > 0 and args or nil,
                      ---@param item snacks.picker.Item
                      transform = function(item)
                        local current_file_path = item.text:match("current%-file://(.*)")
                        local buffer_file_path = item.text:match("buffer://(.*)")
                        local matched_file_path = item.text:match("file://(.*)")
                        local file_path = matched_file_path or current_file_path or buffer_file_path
                        local agent_match = item.text:match("agent://(.+)|(.+)")

                        if file_path then
                          local full_path
                          local display_path = file_path
                          local score_add = 0

                          -- Handle current-file:// - make it relative to cwd
                          if current_file_path then
                            full_path = current_file_path
                            -- Make the absolute path relative to cwd
                            if vim.startswith(full_path, cwd) then
                              display_path = vim.fn.fnamemodify(full_path, ":~:.")
                            else
                              display_path = vim.fn.fnamemodify(full_path, ":~")
                            end
                            score_add = 100
                          elseif buffer_file_path then
                            -- Handle buffer:// - make it relative to cwd
                            full_path = buffer_file_path
                            -- Make the absolute path relative to cwd
                            if vim.startswith(full_path, cwd) then
                              display_path = vim.fn.fnamemodify(full_path, ":~:.")
                            else
                              display_path = vim.fn.fnamemodify(full_path, ":~")
                            end
                            score_add = 50 -- Give buffers higher priority than regular files
                          else
                            -- Regular file:// - already relative
                            full_path = cwd .. "/" .. file_path
                            display_path = file_path
                          end

                          local has_extension = vim.fn.fnamemodify(display_path, ":e") ~= ""
                          local dir = not has_extension and vim.fn.fnamemodify(display_path, ":h") or nil
                          return vim.tbl_extend("force", item, {
                            text = display_path,
                            file = full_path,
                            dir = dir,
                            is_file = true,
                            is_agent = false,
                            score_add = score_add,
                          })
                        elseif agent_match then
                          local agent_name, agent_path = item.text:match("agent://(.+)|(.+)")
                          return vim.tbl_extend("force", item, {
                            text = agent_name,
                            file = agent_path,
                            is_agent = true,
                            is_file = false,
                          })
                        end

                        return item
                      end,
                    }),
                    ctx
                  )
                end,
                on_show = function()
                  vim.api.nvim_feedkeys("i", "n", false)
                end,
                confirm = function(picker, item)
                  local selected = picker:selected()
                  local items_to_send = {}

                  -- Make path relative to the CLI session's cwd
                  local function to_session_path(sel_item)
                    if not sel_item.is_file or not sel_item.file then return sel_item.text end
                    local abs = vim.fn.resolve(sel_item.file)
                    local rel = vim.fn.systemlist({
                      "realpath",
                      "--relative-to=" .. session_cwd,
                      abs,
                    })[1]
                    return rel or sel_item.text
                  end

                  -- Use selected items if any exist, otherwise use the single item
                  if selected and #selected > 0 then
                    for _, sel_item in ipairs(selected) do
                      table.insert(items_to_send, "@" .. to_session_path(sel_item))
                    end
                  else
                    table.insert(items_to_send, "@" .. to_session_path(item))
                  end

                  -- Join with newlines and send
                  t:send(table.concat(items_to_send, "\n") .. "\n")
                  picker:close()
                  t:focus()
                  vim.api.nvim_feedkeys("i", "n", false)
                end,
              })
            end,
            expr = true,
          },
        },
      },
      ---@class sidekick.cli.Mux
      ---@field backend? "tmux"|"zellij" Multiplexer backend to persist CLI sessions
      mux = {
        backend = "tmux",
        enabled = true,
      },
      ---@type table<string, sidekick.cli.Tool.spec>
      tools = {
        claude = {
          cmd = { "claude", "--allow-dangerously-skip-permissions" },
          url = "https://github.com/anthropics/claude-code",
        },
        opencode = {
          cmd = { vim.fn.expand("~/.opencode/bin/opencode") },
          -- HACK: https://github.com/sst/opencode/issues/445
          env = { OPENCODE_THEME = "system" },
          url = "https://github.com/sst/opencode",
        },
      },
      ---@type table<string, sidekick.Prompt|string|fun(ctx:sidekick.context.ctx):(string?)>
      prompts = {
        changes = "Can you review my changes?",
        diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        -- diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
        document = "Add documentation to {position}",
        explain = "Explain {this}",
        fix = "Can you fix {this}?",
        optimize = "How can {this} be optimized?",
        review = "Can you review {file} for any issues or improvements?",
        tests = "Can you write tests for {this}?",
        -- simple context prompts
        buffers = "{buffers}",
        file = "{file}",
        position = "{position}",
        selection = "{selection}",
        ["function"] = "{function}",
        class = "{class}",
      },
    },
    copilot = {
      -- track copilot's status with `didChangeStatus`
      status = {
        enabled = true,
      },
    },
    debug = false, -- enable debug logging
  },
  keys = {
    {
      "<leader>as",
      function()
        require("sidekick.cli").select({ filter = { installed = true } })
      end,
      desc = "Select CLI",
    },
    {
      "<leader>ac",
      function()
        local cli = require("sidekick.cli")
        local State = require("sidekick.cli.state")
        -- Synchronously close any attached claude terminal
        local attached = State.get({ name = "claude", attached = true })
        for _, state in ipairs(attached) do
          State.detach(state)
        end
        -- Show picker for all claude sessions, attach + show the selection
        cli.select({
          filter = { name = "claude" },
          cb = function(state)
            if state then State.attach(state, { show = true, focus = true }) end
          end,
        })
      end,
      desc = "Switch Claude Session",
    },
    {
      "<M-c>",
      function()
        local sidekick_cli = require("sidekick.cli")
        local in_vis_mode = vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22"
        if not in_vis_mode then
          sidekick_cli.toggle({ name = "claude", focus = true })
          return
        end

        sidekick_cli.send({ name = "claude", prompt = "position" })
      end,
      desc = "Sidekick [C]laude",
      mode = { "n", "v" },
    },
    {
      "<M-o>",
      function()
        local sidekick_cli = require("sidekick.cli")
        local in_vis_mode = vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22"
        if not in_vis_mode then
          sidekick_cli.toggle({ name = "opencode", focus = true })
          return
        end

        sidekick_cli.send({ name = "opencode", prompt = "position" })
      end,
      desc = "Sidekick [O]pencode",
      mode = { "n", "v" },
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      desc = "Sidekick Ask Prompt",
      mode = { "n", "v" },
    },
  },
}
