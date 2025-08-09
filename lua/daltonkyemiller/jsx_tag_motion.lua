local M = {}

local MAX_NODE_SEARCH = 3

---@param node TSNode | nil
---@param search_node_types Array<string>
local function find_nearest_node(node, search_node_types, search_n)
  search_n = search_n or 0

  if node == nil then return nil end

  local node_type = node:type()

  if vim.tbl_contains(search_node_types, node_type) then return node end

  local parent = node:parent()

  if parent == nil then return nil end

  if search_n > MAX_NODE_SEARCH then return nil end
  return find_nearest_node(parent, search_node_types, search_n + 1)
end

local function get_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
end

local js_nodes = { "jsx_element", "jsx_self_closing_element" }
local astro_nodes = { "element", "self_closing_element" }

local node_map = {
  ["javascriptreact"] = js_nodes,
  ["typescriptreact"] = js_nodes,
  ["astro"] = astro_nodes,
}

---@param type 'd' | 'c' | 'v'
---@param mode 'i' | 'a'
M.jsx_tag_motion = function(type, mode)
  if vim.bo.filetype ~= "typescriptreact" and vim.bo.filetype ~= "javascriptreact" and vim.bo.filetype ~= "astro" then
    return nil
  end

  local node = vim.treesitter.get_node()
  if node == nil then return end

  local search_node_types = node_map[vim.bo.filetype]

  local nearest_node = find_nearest_node(node, search_node_types)

  if nearest_node == nil then return end

  -- if it's outer tag, the range is just the range of the node, easy
  local start_row, start_col, end_row, end_col = nearest_node:range()

  -- if it's inner tag, we need to find the range of the children, unless it's a self closing tag
  if mode == "i" and nearest_node:type() ~= search_node_types[2] then
    local children = {}
    for child in nearest_node:iter_children() do
      if child:named() then
        table.insert(children, child)
      end
    end

    local first_child = children[1]
    local last_child = children[#children]

    if first_child == nil or last_child == nil then return end

    _, _, start_row, start_col = first_child:range()
    end_row, end_col, _, _ = last_child:range()
  end

  -- in visual mode or if we are yanking, we need to highlight the range
  if type == "v" or type == "y" then
    local start_char = get_line(0, start_row):sub(start_col + 1, start_col + 1)

    -- in the case of a multiline tag, we need to move the cursor to the next line
    -- eg:
    -- <body>
    --       ^
    -- </body
    if #start_char == 0 or start_char == ">" then
      start_row = start_row + 1
      start_col = 0

      end_row = end_row - 1
      end_col = #get_line(0, end_row)
    end

    -- set cursor to start of range
    vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })
    -- enter visual mode
    vim.cmd("normal! v")
    -- set cursor to end of range
    vim.api.nvim_win_set_cursor(0, { end_row + 1, end_col - 1 })

    -- yank
    if type == "y" then vim.cmd("normal! y") end

    return
  end

  -- if delete or change, we need to remove the range
  vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, {})
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_col })

  -- enter insert mode
  if type == "c" then vim.cmd("startinsert") end
end

return M
