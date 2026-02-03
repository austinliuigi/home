--==============================================================================
-- LIST CONTINUATION
--==============================================================================

local function newline_list(before)
  local cursor_linenr = vim.api.nvim_win_get_cursor(0)[1]
  local new_linenr = before and cursor_linenr or cursor_linenr + 1
  local preceding_line_str = ""
  if new_linenr > 1 then
    preceding_line_str = vim.api.nvim_buf_get_lines(0, new_linenr - 2, new_linenr - 1, true)[1]
  end

  local list_start_str = preceding_line_str:match("^%s*%- %[.%]") and "- [ ]" or "-"

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(
      string.format("<ESC>%s%s ", before and "O" or "o", list_start_str),
      true,
      false,
      true
    ),
    "n",
    true
  )
end

vim.keymap.set("i", "<C-CR>", function()
  newline_list()
end, { buffer = 0, noremap = true })

vim.keymap.set("n", "<leader>o", function()
  newline_list()
end, { buffer = 0, noremap = true })

vim.keymap.set("n", "<leader>O", function()
  newline_list(true)
end, { buffer = 0, noremap = true })

--==============================================================================
-- LIST MARKERS
--==============================================================================

-- TODO: allow for dot repeat
local function mark_list(marker, linenr)
  linenr = linenr or vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]

  if line:match("^%s*%- %[.%]") then
    local replacement_line = line:gsub("%- %[.%]", string.format("- [%s]", marker), 1)
    if line ~= replacement_line then
      vim.api.nvim_buf_set_lines(0, linenr - 1, linenr, false, { replacement_line })
    end
  end
end

vim.keymap.set({ "n" }, "<CR>", function()
  mark_list("x")
end, { buffer = 0, noremap = true })

vim.keymap.set({ "x" }, "<CR>", function()
  -- exit visual mode to set the visual marks
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", true)

  local start_linenr = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_linenr = vim.api.nvim_buf_get_mark(0, ">")[1]

  for linenr = start_linenr, end_linenr do
    mark_list("x", linenr)
  end
end, { buffer = 0, noremap = true })

vim.keymap.set({ "n" }, "<leader><CR>", function()
  mark_list(" ")
end, { buffer = 0, noremap = true })

vim.keymap.set({ "x" }, "<leader><CR>", function()
  -- exit visual mode to set the visual marks
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), "nx", true)

  local start_linenr = vim.api.nvim_buf_get_mark(0, "<")[1]
  local end_linenr = vim.api.nvim_buf_get_mark(0, ">")[1]

  for linenr = start_linenr, end_linenr do
    mark_list(" ", linenr)
  end
end, { buffer = 0, noremap = true })
