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
