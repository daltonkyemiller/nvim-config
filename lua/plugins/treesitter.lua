--- @type LazySpec
return {
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({})

    require("nvim-treesitter").install({
      "prisma",
      "caddy",
      "regex",
      "astro",
      "c",
      "cpp",
      "go",
      "lua",
      "python",
      "rust",
      "tsx",
      "html",
      "json",
      "css",
      "javascript",
      "glsl",
      "typescript",
      "markdown",
      "markdown_inline",
      "prisma",
      "vimdoc",
      "vim",
      "bash",
      "sql",
      "dockerfile",
    })

    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
      },
      swap = {
        enable = true,
      },
    })

    -- Text object selections
    vim.keymap.set({ "x", "o" }, "aA", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@parameters.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "iA", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@parameters.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "aa", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ia", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "af", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "if", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ac", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
    end)
    vim.keymap.set({ "x", "o" }, "ic", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ab", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@block.outer", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ib", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@block.inner", "textobjects")
    end)

    -- Movement keymaps
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "][", function()
      require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer")
    end)
    vim.keymap.set({ "n", "x", "o" }, "[]", function()
      require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer")
    end)

    -- Swap keymaps
    vim.keymap.set("n", "<leader>a", function()
      require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
    end)
    vim.keymap.set("n", "<leader>A", function()
      require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
    end)
  end,
}
