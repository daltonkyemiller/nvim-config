--- @type LazySpec
return {
  "toppair/peek.nvim",
  event = { "VeryLazy" },
  build = "deno task --quiet build:fast",
  config = function()
    local is_linux = vim.fn.has("linux") == 1

    local opts = {}
    if is_linux then opts.app = { "/home/dalton/Applications/Zen.AppImage", "--new-window" } end

    require("peek").setup(opts)
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  end,
}
