return {
  'ThePrimeagen/refactoring.nvim',
  event = 'BufRead',
  config = function()
    require('refactoring').setup({})
    -- load refactoring Telescope extension
    require("telescope").load_extension("refactoring")

    -- remap to open the Telescope refactoring menu in visual mode
    vim.api.nvim_set_keymap(
      "v",
      "<leader>rr",
      "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
      { noremap = true }
    )
    vim.keymap.set('n', "<leader>rv", function()
      require('refactoring').debug.print_var({ normal = true })
    end, { noremap = true, desc = "Refactoring print variable" })
  end

}
