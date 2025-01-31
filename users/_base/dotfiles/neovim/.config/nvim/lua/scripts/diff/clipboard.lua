vim.api.nvim_create_user_command("DiffClipboard", function(attrs)
  local lines = vim.api.nvim_buf_get_lines(0, attrs.line1 - 1, attrs.line2, true)
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd("tab split")
  end

  local selection_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(selection_buf)
  vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
  vim.cmd("diffthis")

  local clip_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(clip_buf, true, { split = "right" }) -- use vim api call to force split to be on the right; :bottomright will cause window to take full height
  vim.cmd("put | normal! VP")
  vim.cmd("diffthis")
end, { nargs = 0, range = "%" })
