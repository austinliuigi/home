local config = {
  -- string: keys to press in normal mode to visually select region
  -- table: list of strings that are consecutive viml commands; visually selects region
  -- function: return string type
  motions = {
    ["f"] = {
      inside = {
        "lua require('scripts.text-objects').MoveToFirstNonBlankLine()",
        "normal! V",
        "lua require('scripts.text-objects').MoveToLastNonBlankLine()",
        -- "execute(nextnonblank(1))",
        -- "normal! V",
        -- "execute(prevnonblank(line('$')))",
      },
      around = "ggVG"
    },
    ["l"] = {
      inside = "^vg_",
      around = "0v$h"
    },
    ["z"] = {
      inside = function()
        if vim.o.foldmethod == "marker" then
          return "[zjV]zk"
        else
          return "[zV]z"
        end
      end,
      around = "[zV]z",
    },
  },
  literals = {
    '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
    '`', '~',
    '!', '@', '#', '$', '%', '^', '&', '*',
    '-', '_',
    '=', '+',
    '\\', '|',
    ':', ';',
    '"', "'",
    '.', ',',
    '/', '?',
  }
}



--[[ Motions ]]
local ConvertToString = function(input)
  local type = type(input)
  if type == "string" then
    return "normal! " .. input
  elseif type == "table" then
    local wrapped_input = {}
    for _, command in ipairs(input) do
      table.insert(wrapped_input, string.format('execute "%s"', command))
    end
    return table.concat(wrapped_input, "|")
  elseif type == "function" then
    return "normal! " .. input()
  end
end

-- Note: making the mappings silent eliminates CursorLine flicker
for char, selection in pairs(config.motions) do
  vim.keymap.set({"x", "o"}, "i"..char, function()
    return string.format(":<C-u>%s<CR>", ConvertToString(selection.inside))
  end, { remap = false, silent = true, expr = true })
  vim.keymap.set({"x", "o"}, "a"..char, function()
    return string.format(":<C-u>%s<CR>", ConvertToString(selection.around))
  end, { remap = false, silent = true, expr = true })
end



--[[ Literals ]]
-- Note: empty capture () captures the current string position
local SelectBetweenLiterals = function(type, char)
  local escaped_char = char:gsub("([^%w])", "%%%1")
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.fn.getcurpos()[3]
  local first_char = string.find(line, escaped_char)
  local last_char = string.match(line, ".*()"..escaped_char)

  if first_char == nil then return "" end
  if first_char >= cursor_col and last_char ~= first_char then
    if type == "inside" then
      return string.format(":<C-u>normal! 0f%slvt%s<CR>", char, char)
    elseif type == "around" then
      return string.format(":<C-u>normal! 0f%svf%s<CR>", char, char)
    end
  elseif first_char < cursor_col and last_char >= cursor_col then
    if type == "inside" then
      return string.format(":<C-u>normal! T%svt%s<CR>", char, char)
    elseif type == "around" then
      return string.format(":<C-u>normal! F%svf%s<CR>", char, char)
    end
  end
  return ""
end

-- Note: Need to use expr mapping to stay in visual mode
-- Using <cmd>, vim.cmd, vim.fn.execute leaves visual mode
for _,char in ipairs(config.literals) do
  -- "inside"
  vim.keymap.set({"x", "o"}, "i"..char, function()
    return SelectBetweenLiterals("inside", char)
  end, { noremap = true, silent = true, expr = true })
  -- "around"
  vim.keymap.set({"x", "o"}, "a"..char, function()
    return SelectBetweenLiterals("around", char)
  end, { noremap = true, silent = true, expr = true })
end


local M = {}

M.MoveToFirstNonBlankLine = function()
  vim.cmd("normal! gg")
  if string.find(vim.fn.getline("."), "%S") == nil then
    vim.fn.search('^\\s*\\S\\+')
  end
end

M.MoveToLastNonBlankLine = function()
  vim.cmd("normal! G")
  if string.find(vim.fn.getline("."), "%S") == nil then
    vim.fn.search('^\\s*\\S\\+', 'b')
  end
end

return M
