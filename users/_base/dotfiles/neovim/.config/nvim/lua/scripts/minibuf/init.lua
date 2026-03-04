--==============================================================================
-- EXECUTE BUF
--==============================================================================
vim.keymap.set("n", "<leader>:", function()
  require("scripts.minibuf.ExecuteBuf"):create()
end, {})

--==============================================================================
-- COMMAND BUF
--==============================================================================
vim.keymap.set("n", "q:", function()
  require("scripts.minibuf.CommandBuf"):create()
end, {})

-- vim.keymap.set("n", ":", function()
--   M:create()
--   vim.api.nvim_win_set_height(0, 2)
--   vim.cmd("startinsert")
-- end, {})

--==============================================================================
-- SEARCH BUF
--==============================================================================
vim.keymap.set("n", "q/", function()
  require("scripts.minibuf.SearchBuf"):create(true)
end, {})

vim.keymap.set("n", "q?", function()
  require("scripts.minibuf.SearchBuf"):create(false)
end, {})

-- vim.keymap.set("n", "/", function()
--   M:create(true)
--   vim.api.nvim_win_set_height(0, 2)
--   vim.cmd("startinsert")
-- end, {})

-- vim.keymap.set("n", "?", function()
--   M:create(false)
--   vim.api.nvim_win_set_height(0, 2)
--   vim.cmd("startinsert")
-- end, {})

--==============================================================================
-- COMMAND MODE MAPPINGS
--==============================================================================
vim.keymap.set("c", "<C-f>", function()
  local cmdtype = vim.fn.getcmdtype()

  if cmdtype == ":" then
    require("scripts.minibuf.CommandBuf"):create()
  elseif cmdtype == "/" then
    require("scripts.minibuf.SearchBuf"):create(true)
  elseif cmdtype == "?" then
    require("scripts.minibuf.SearchBuf"):create(false)
  end

  local cmdline = vim.fn.getcmdline()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, true, true), "nit", false)
  vim.api.nvim_buf_set_lines(0, -2, -1, true, { cmdline })
  vim.cmd("normal! $")
end, {})
