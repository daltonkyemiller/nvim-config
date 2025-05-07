local M = {}

--- Get the daily note path for a specific day
--- @param day_offset number The offset in days (0 for today, -1 for yesterday, 1 for tomorrow)
--- @return string | nil The path to the daily note
local function get_daily_note_path(day_offset)
  local cwd = vim.uv.cwd()
  if not cwd then
    vim.notify("Could not get current working directory", vim.log.levels.ERROR)
    return nil
  end

  local timestamp = os.time() + (day_offset * 86400)
  local date_string = os.date("%Y-%m-%d %a", timestamp)
  return cwd .. "/daily-notes/" .. date_string .. ".md"
end

--- Parse todos from the given file content
--- @param content string The file content to parse
--- @return table A table of unfinished todos
local function parse_unfinished_todos(content)
  local todos = {}
  local in_todo_section = false

  for line in content:gmatch("[^\r\n]+") do
    if line:match("^#%s+TODO:") or line:match("^##%s+TODOS?:") then
      in_todo_section = true
    elseif in_todo_section and line:match("^#") then
      in_todo_section = false
    elseif in_todo_section then
      local todo_match = line:match("^%s*%-%s%[%s?%]%s*(.*)")
      if todo_match and #todo_match > 0 then
        table.insert(todos, todo_match)
      end
    end
  end

  return todos
end

--- @param options {day: 'tomorrow' | 'yesterday'} | nil
M.create_daily_note = function(options)
  options = options or {
    day = false,
  }

  local cwd = vim.uv.cwd()

  if not cwd then
    vim.notify("Could not get current working directory", vim.log.levels.ERROR)
    return
  end

  local offset = options.day == "tomorrow" and 1 or options.day == "yesterday" and -1 or 0
  local yesterday_offset = offset - 1 -- Get yesterday relative to the requested day
  
  local date_string = os.date("%Y-%m-%d %a", os.time() + (offset * 86400))
  local daily_note_path = get_daily_note_path(offset)

  if not daily_note_path then
    return
  end

  local file_exists = vim.fn.filereadable(daily_note_path) == 1

  if file_exists then
    vim.cmd("e " .. daily_note_path)
    return
  end

  -- Get yesterday's todos
  local unfinished_todos = {}
  local yesterday_path = get_daily_note_path(yesterday_offset)
  
  if yesterday_path and vim.fn.filereadable(yesterday_path) == 1 then
    local yesterday_file = io.open(yesterday_path, "r")
    if yesterday_file then
      local content = yesterday_file:read("*all")
      yesterday_file:close()
      unfinished_todos = parse_unfinished_todos(content)
    end
  end

  -- Create todo items string
  local todos_content = ""
  for _, todo in ipairs(unfinished_todos) do
    todos_content = todos_content .. "- [ ] " .. todo .. "\n"
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

# TODO:
%s
]],
    date_string,
    todos_content
  )

  daily_note_file:write(note_template_content)

  daily_note_file:close()
  vim.cmd("e " .. daily_note_path)
end

return M
