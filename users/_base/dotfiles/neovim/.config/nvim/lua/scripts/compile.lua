-- TODO: make this async by using vim.system
--   - need to manually populate quickfix list (use :cgfile)
--   - allow viewing output like portal.nvim

local history_file = vim.fn.stdpath("cache") .. "/.compilehist"

local parent_bufnr
local winid

local compile_buf = vim.api.nvim_create_buf(false, false)

-- NOTE: we need to open the history file in the buffer before setting keymaps
--       otherwise they get cleared if we set buflocal keymaps first then edit the
--       histfile in the buffer even though they have the same bufnr before and after editing
--       - same for buffer options
vim.api.nvim_buf_call(compile_buf, function()
  vim.cmd("edit " .. history_file)
end)

vim.bo[compile_buf].buftype = "nowrite"
vim.bo[compile_buf].filetype = vim.fs.basename(vim.o.shell)

vim.keymap.set({ "n", "i" }, "<CR>", function()
  local selected_line = vim.api.nvim_get_current_line()
  if not selected_line:match("^%s$") then
    if not vim.api.nvim_buf_is_valid(parent_bufnr) then
      vim.notify(string.format("Parent buffer (%s) is not valid", parent_bufnr))
    end

    -- set makeprg in parent buffer
    vim.bo[parent_bufnr].makeprg = selected_line:gsub("|", "\\|")

    -- restore state (we read the file on disk so that it works with multiple nvim processes)
    vim.api.nvim_buf_set_lines(compile_buf, 0, -1, true, vim.fn.readfile(history_file))

    -- append current line
    vim.cmd("normal! G")
    local last_line = vim.api.nvim_get_current_line()
    if selected_line ~= last_line then
      vim.api.nvim_buf_set_lines(compile_buf, -1, -1, true, { selected_line })
    end

    -- run :make in parent buffer
    vim.api.nvim_buf_call(parent_bufnr, function()
      vim.cmd("make")
    end)

    -- enter normal mode if not already
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "n", false)

    -- write to disk
    vim.bo[compile_buf].buftype = ""
    vim.cmd("silent w " .. history_file)
    vim.bo[compile_buf].buftype = "nowrite"
  end

  vim.api.nvim_win_close(0, false)
end, { buffer = compile_buf })

local function open()
  parent_bufnr = vim.api.nvim_get_current_buf()

  -- close compiler window if it already exists
  if winid and vim.api.nvim_win_is_valid(winid) then
    vim.api.nvim_win_close(winid, true)
  end

  -- create new compiler window
  winid = vim.api.nvim_open_win(compile_buf, true, {
    split = "below",
  })
  vim.cmd("wincmd J")
  vim.api.nvim_win_set_height(winid, math.floor(vim.o.lines / 4))
  vim.wo[winid].winbar = "%#Bold#   Compile"
  vim.wo[winid].statuscolumn = "%#String#  $" -- TODO: dynamically adapt to column width (see :h 'statuscolumn'

  vim.cmd("e") -- sync state of the buffer to that of the history file on disk
  vim.cmd("normal! Go")
end

vim.api.nvim_create_user_command("Compile", function()
  open()
end, { nargs = 0 })

vim.keymap.set("n", "<leader>:", function()
  open()
end, {})
