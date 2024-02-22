--- @type LazySpec
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = true,
  keys = function()
    local harpoon = require("harpoon")

    return {
      {
        "<leader>hh",
        function()
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Toggle [H]arpoon",
      },
      {
        "<leader>ha",
        function()
          harpoon:list():append()
        end,
        desc = "Toggle [H]arpoon",
      },
    }
  end,
}
