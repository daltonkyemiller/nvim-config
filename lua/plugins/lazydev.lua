--- @type LazySpec
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = function()
    local library = {
      "~/dev/nvim-plugins/claude-code.nvim",
      "~/.config/nvim/lua/daltonkyemiller/globals",
      "kanagawa.nvim",
      "lazy.nvim",
      "flash.nvim",
      "mini.test",
      "noice.nvim",
      "nvim-treesitter.configs",
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    }

    local tests_lazy_dir = vim.fn.getcwd() .. "/.tests/data/nvim/lazy"
    if vim.fn.isdirectory(tests_lazy_dir) == 1 then
      for _, dir in ipairs(vim.fn.readdir(tests_lazy_dir)) do
        local path = tests_lazy_dir .. "/" .. dir
        if vim.fn.isdirectory(path) == 1 and not vim.tbl_contains(library, dir) then table.insert(library, path) end
      end
    end

    return {
      library = library,
    }
  end,
}
