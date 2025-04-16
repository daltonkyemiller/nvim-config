--- @type LazySpec
return {
  "saghen/blink.cmp",
  lazy = false,
  -- optional: provides snippets for the snippet source
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      keys = {
        {
          "<C-c>",
          function()
            return require("luasnip.extras.select_choice")()
          end,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
          end,
          expr = true,
          silent = true,
          mode = "i",
        },
        {
          "<Tab>",
          function()
            require("luasnip").jump(1)
          end,
          mode = "s",
        },
        {
          "<S-tab>",
          function()
            require("luasnip").jump(-1)
          end,
          mode = { "i", "s" },
        },
      },
      init = function()
        require("luasnip.loaders.from_snipmate").load({
          paths = { "~/.config/nvim/snippets" },
        })
        require("luasnip.loaders.from_lua").load({
          paths = { "~/.config/nvim/snippets" },
        })
      end,
    },
    "Kaiser-Yang/blink-cmp-avante",
  },

  -- use a release tag to download pre-built binaries
  version = "*",
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
          },
        },
      },

      keymap = {
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_menu_visible() then return cmp.accept() end
          end,
          "fallback",
        },
      },
    },

    snippets = { preset = "luasnip" },
    signature = { enabled = true },
    completion = {
      documentation = {
        auto_show = true,
      },

      menu = {
        max_height = 20,
      },

      list = {
        selection = {
          preselect = false,
        },
      },
    },
    -- Enable

    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = "default",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.is_menu_visible() then return cmp.accept() end
        end,
        "fallback",
      },
    },

    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "mono",
    },

    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "claude_code", "lazydev", "avante", "snippets", "lsp", "path", "buffer" },
      providers = {
        lsp = {
          transform_items = function(_, items)
            return vim.tbl_filter(function(item)
              return not (
                item.labelDetails
                and item.labelDetails.description
                and string.find(item.labelDetails.description, "lucide")

              )
            end, items)
          end,
          async = true,
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          -- max_items = 20,
        },
        -- codecompanion = {
        --   name = "CodeCompanion",
        --   module = "codecompanion.providers.completion.blink",
        --   enabled = true,
        -- },
        claude_code = {
          name = "Claude Code",
          module = "claude-code.integrations.blink",
          enabled = true,
        },
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {
            -- options for blink-cmp-avante
          },
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },
  },
  opts_extend = { "sources.default" },
}
