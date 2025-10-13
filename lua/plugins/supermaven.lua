--- @type LazySpec
return {
  "supermaven-inc/supermaven-nvim",
  enabled = true,
  config = function()
    require("supermaven-nvim").setup({
      log_level = "off",
      -- disable_keymaps = true,
      keymaps = {
        -- handled in sidekick for next edit suggestions
        accept_suggestion = nil,
        clear_suggestion = "<C-]>",
        accept_word = "<S-Tab>",
      },
    })
  end,
}
