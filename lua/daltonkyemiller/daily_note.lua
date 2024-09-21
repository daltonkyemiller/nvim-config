local M = {}

--- @param options {day: 'tomorrow' | 'yesterday'} | nil
M.create_daily_note = function(options)
  options = options or {
    day = false,
  }

  local cwd = vim.loop.cwd()

  if not cwd then
    vim.notify("Could not get current working directory", vim.log.levels.ERROR)
    return
  end

  local offset = options.day == "tomorrow" and 86400 or options.day == "yesterday" and -86400 or 0

  local date_string = os.date("%Y-%m-%d %a", os.time() + offset)

  local daily_note_path = cwd .. "/daily-notes/" .. date_string .. ".md"

  local file_exists = vim.fn.filereadable(daily_note_path) == 1

  if file_exists then
    vim.cmd("e " .. daily_note_path)
    return
  end

  local daily_note_file = io.open(daily_note_path, "w")

  if not daily_note_file then
    vim.notify("Could not create daily note file", vim.log.levels.ERROR)
    return
  end

  local note_template_content = string.format(
    [[
---
date: %s
---
]],
    date_string
  )

  daily_note_file:write(note_template_content)

  daily_note_file:close()
  vim.cmd("e " .. daily_note_path)
end

return M
