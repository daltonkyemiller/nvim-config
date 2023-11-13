return {
  'mizlan/iswap.nvim',
  event = "VeryLazy",
  config = function()
    local iswap = require('iswap')
    iswap.setup()

    vim.keymap.set("n", "<leader>a", function() iswap.iswap_with("left") end, { desc = "Swap with left" })
    vim.keymap.set("n", "<leader>A", function() iswap.iswap_with("right") end, { desc = "Swap with right" })
    vim.keymap.set("n", "<leader>is", iswap.iswap_with, { desc = "Swap with selection" })
  end
}
