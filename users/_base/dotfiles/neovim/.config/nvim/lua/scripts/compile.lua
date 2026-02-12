local history_file = vim.fn.stdpath("cache") .. "/.compilehist"

local parent_bufnr
local lines

local bufnr = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_call(bufnr, function()
  vim.cmd("edit " .. history_file)
end)
vim.bo[bufnr].buftype = "nowrite"
vim.bo[bufnr].filetype = vim.fs.basename(vim.o.shell)

vim.keymap.set({ "n", "i" }, "<CR>", function()
  local selected_line = vim.api.nvim_get_current_line()
  if not selected_line:match("^%s$") then
    -- set makeprg in parent buffer
    vim.bo[parent_bufnr].makeprg = selected_line:gsub("|", "\\|")

    -- restore state
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)

    -- append current line
    vim.cmd("normal! G")
    local last_line = vim.api.nvim_get_current_line()
    if selected_line ~= last_line then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, true, { selected_line })
    end

    -- run :make in parent buffer
    vim.api.nvim_buf_call(parent_bufnr, function()
      vim.cmd("make")
    end)

    -- enter normal mode if not already
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "n", false)

    vim.bo[bufnr].buftype = ""
    vim.cmd("silent w " .. history_file)
    vim.bo[bufnr].buftype = "nowrite"
  end

  vim.api.nvim_win_close(0, false)
end, { buffer = bufnr })

local function open()
  parent_bufnr = vim.api.nvim_get_current_buf()

  local winid = vim.api.nvim_open_win(bufnr, true, {
    split = "below",
  })
  vim.cmd("wincmd J")
  vim.api.nvim_win_set_height(winid, math.floor(vim.o.lines / 4))

  -- remove empty lines
  vim.cmd("silent g/^\\s*$/d")
  vim.cmd("nohl")

  lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

  vim.cmd("normal! Go")
end

vim.api.nvim_create_user_command("Compile", function()
  open()
end, { nargs = 0 })

vim.keymap.set("n", "<leader>:", function()
  open()
end, {})
