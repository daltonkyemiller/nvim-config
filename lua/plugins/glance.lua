function read_file_line(file_name, line_nr)
  local line = 0
  for l in io.lines(file_name) do
    line = line + 1
    if line == line_nr then return l end
  end
end

--- @type LazySpec
return {
  enabled = false,
  "dnlhc/glance.nvim",
  event = "BufRead",
  config = true,
  --- @type GlanceOpts
  opts = {
    list = {
      position = "left",
      width = 30,
    },
    hooks = {
      before_open = function(results, open, jump, method)
        local final_results = {}
        for _, val in ipairs(results) do
          local target_uri = val.uri or val.targetUri
          local target_line = val.range.start.line
          local target_file_path = vim.uri_to_fname(target_uri)
          local line_text = read_file_line(target_file_path, target_line)
          -- if it begins with "import", ignore
          if line_text and not line_text:find("^import") then table.insert(final_results, val) end
        end

        open(final_results)

        -- local uri = vim.uri_from_bufnr(0)
        -- if #results == 1 then
        --   local target_uri = results[1].uri or results[1].targetUri
        --
        --   if target_uri == uri then
        --     jump(results[1])
        --   else
        --     open(results)
        --   end
        -- else
        --   open(results)
        -- end
      end,
    },
  },
  keys = {
    -- { "gr", "<CMD>Glance references<CR>", desc = "[G]oto [R]eferences" },
  },
}

-- {
--   range = {
--     ["end"] = {
--       character = 25,
--       line = 18
--     },
--     start = {
--       character = 16,
--       line = 18
--     }
--   },
--   uri = "file:///Users/daltonkyemiller/dev/bbkabacus/App/FrontEnd/src/%40AppRoot/Navigation/Root/HeaderBar/HeaderBar.tsx"
-- }
