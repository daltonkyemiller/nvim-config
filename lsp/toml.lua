---@type vim.lsp.Config
return {
  filetypes = { "toml" },
  cmd = { "taplo", "lsp", "stdio" },
  -- ---@param fname string
  -- root_dir = function(fname)
  --   return vim.fs.dirname(vim.fs.find(".git", {
  --     follow = true,
  --     upward = true,
  --   })[1])
  -- end,
  settings = {
    evenBetterToml = {
      schema = {
        associations = {
          ["stylua.toml"] = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/stylua.json",
          [".stylua.toml"] = "https://raw.githubusercontent.com/SchemaStore/schemastore/refs/heads/master/src/schemas/json/stylua.json",
        },
      },
    },
  },
}
