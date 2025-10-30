--- @type LazySpec
return {
  "folke/sidekick.nvim",
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
          width = 100,
          height = 20,
        },
        --- CLI Tool Keymaps
        --- default mode is `t`
        ---@type table<string, sidekick.cli.Keymap|false>
        keys = {
          stopinsert = { "<esc><esc>", "stopinsert", mode = "t" }, -- enter normal mode
          hide_n = { "q", "hide", mode = "n" }, -- hide from normal mode
          hide_t = { "<M-c>", "hide" }, -- hide from terminal mode
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
              local snacks_picker = require("snacks.picker")
              snacks_picker.files({
                on_show = function()
                  vim.api.nvim_feedkeys("i", "n", false)
                end,
                confirm = function(picker, item)
                  t:send("@" .. item.file .. "\n")
                  picker:close()
                  t:focus()
                  vim.api.nvim_feedkeys("i", "n", false)
                end,
              })
            end,
            expr = true,
          },
          -- example of custom keymap:
          -- say_hi = {
          --   "<c-h>",
          --   function(t)
          --     t:send("hi!")
          --   end,
          -- },
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
        claude = { cmd = { "claude" }, url = "https://github.com/anthropics/claude-code" },
        codex = { cmd = { "codex", "--search" }, url = "https://github.com/openai/codex" },
        copilot = { cmd = { "copilot", "--banner" }, url = "https://github.com/github/copilot-cli" },
        crush = {
          cmd = { "crush" },
          url = "https://github.com/charmbracelet/crush",
          keys = {
            -- crush uses <a-p> for its own functionality, so we override the default
            prompt = { "<a-p>", "prompt" }, -- insert prompt or context
          },
        },
        cursor = { cmd = { "cursor-agent" }, url = "https://cursor.com/cli" },
        gemini = { cmd = { "gemini" }, url = "https://github.com/google-gemini/gemini-cli" },
        grok = { cmd = { "grok" }, url = "https://github.com/superagent-ai/grok-cli" },
        opencode = {
          cmd = { "opencode" },
          -- HACK: https://github.com/sst/opencode/issues/445
          env = { OPENCODE_THEME = "system" },
          url = "https://github.com/sst/opencode",
        },
        qwen = { cmd = { "qwen" }, url = "https://github.com/QwenLM/qwen-code" },
      },
      ---@type table<string, sidekick.Prompt|string|fun(ctx:sidekick.context.ctx):(string?)>
      prompts = {
        changes = "Can you review my changes?",
        diagnostics = "Can you help me fix the diagnostics in {file}?\n{diagnostics}",
        diagnostics_all = "Can you help me fix these diagnostics?\n{diagnostics_all}",
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
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if require("sidekick").nes_jump_or_apply() then
          return -- jumped or applied
        end

        local supermaven_completion_preview = require("supermaven-nvim.completion_preview")

        if supermaven_completion_preview.has_suggestion() then
          vim.schedule(function()
            supermaven_completion_preview.on_accept_suggestion()
          end)

          return
        end

        -- if you are using Neovim's native inline completions
        -- if vim.lsp.inline_completion.get() then return end

        -- any other things (like snippets) you want to do on <tab> go here.

        -- fall back to normal tab
        return "<tab>"
      end,
      mode = { "i", "n" },
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
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

        sidekick_cli.send({ prompt = "position", name = "claude" })
      end,
      desc = "Sidekick Claude Toggle",
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
