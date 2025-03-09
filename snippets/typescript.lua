---@diagnostic disable: undefined-global

local barrel_snippet = s({
  trig = "expb",
  name = "Barrel File",
  desc = "Generates an index.ts file exporting all modules in the same directory",
}, {
  f(function()
    local buf_path = vim.api.nvim_buf_get_name(0)
    local buf_dir = buf_path:match("(.*/)") or ""
    if buf_dir == "" then return "" end
    local handle = io.popen(
      "cd "
        .. vim.fn.shellescape(buf_dir)
        .. " && ls *.ts *.tsx 2>/dev/null | grep -v '^index\\.ts[x]*$' | sed 's/\\.[tj]sx?$//'"
    )
    if not handle then return "" end
    local result = handle:read("*a")
    handle:close()
    local lines = {}
    for filename in result:gmatch("[^\n]+") do
      -- remove .tsx or .ts extension
      local filename_no_ext = filename:match("^(.*)%.ts[x]?$")
      table.insert(lines, 'export * from "./' .. filename_no_ext .. '";')
    end
    return lines
  end, {}),
})

return {
  barrel_snippet,
}
