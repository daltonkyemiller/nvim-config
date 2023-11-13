return {
  "dnlhc/glance.nvim",
  event = "BufRead",
  init = function()
    local glance = require("glance")
    glance.setup({
      list = {
        position = "left",
        width = 30,
      },
    })

    vim.keymap.set("n", "gD", "<CMD>Glance definitions<CR>", { desc = "Glance Definitions" })
    vim.keymap.set("n", "gR", "<CMD>Glance references<CR>", { desc = "Glance References" })
    vim.keymap.set("n", "gY", "<CMD>Glance type_definitions<CR>", { desc = "Glance Type Definitions" })
    vim.keymap.set("n", "gM", "<CMD>Glance implementations<CR>", { desc = "Glance Implementations" })
  end,
}
