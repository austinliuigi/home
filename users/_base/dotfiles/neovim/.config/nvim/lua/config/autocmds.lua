-- Highlight yanked text
vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "HighlightYank",
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
  end,
})

-- Immediately enter terminal mode when focusing terminal buffers
vim.api.nvim_create_autocmd({ "TermOpen", "BufEnter" }, {
  pattern = { "*" },
  callback = function()
    if vim.o.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- Immediately cd to buffer directory when opening terminal
-- vim.api.nvim_create_autocmd("TermOpen", {
--   callback = function()
--     local bufdir = vim.fn.expand("#:p:h")
--     local term_buf = vim.api.nvim_get_current_buf()
--     local term_win = vim.api.nvim_get_current_win()
--     if vim.fn.isdirectory(bufdir) == 1 then
--       -- interval
--       local timer = vim.uv.new_timer()
--       timer:start(
--         100,
--         100,
--         vim.schedule_wrap(function()
--           -- if terminal prompt is visible (heuristic that shell loaded)
--           if not string.match(table.concat(vim.api.nvim_buf_get_lines(term_buf, 0, -1, true)), "^%s*$") then
--             timer:stop()
--             timer:close()
--             local curr_win = vim.api.nvim_get_current_win()
--             vim.api.nvim_set_current_win(term_win)
--             vim.api.nvim_feedkeys(
--               vim.api.nvim_replace_termcodes("cd " .. vim.fn.shellescape(bufdir) .. "<CR>", true, true, true),
--               "ni",
--               false
--             )
--             vim.defer_fn(function()
--               vim.api.nvim_set_current_win(curr_win)
--             end, 500)
--           end
--         end)
--       )
--     end
--   end,
-- })

-- Make terminals fixed sizes
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.o.winfixheight = true
    vim.o.winfixwidth = true
  end,
})

-- LSP attach notifications
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  pattern = { "*" },
  callback = function()
    local root = vim.lsp.buf.list_workspace_folders()
    if #root > 0 then
      vim.notify("LSP attached to " .. root[1])
    else
      vim.notify("LSP running in single-file mode")
    end
  end,
})

-- Remove cursorline from unfocused windows
vim.api.nvim_create_augroup("Cursorline", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter" }, {
  group = "Cursorline",
  pattern = { "*" },
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group = "Cursorline",
  pattern = { "*" },
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Set relative line numbers for help windows
vim.api.nvim_create_augroup("HelpWindowNumLine", { clear = true })
vim.api.nvim_create_autocmd("BufWinEnter", {
  command = 'if &buftype == "help" | setlocal relativenumber | endif',
  group = "HelpWindowNumLine",
  pattern = { "*" },
  desc = "Set relative number line for help windows",
})
