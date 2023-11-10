vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = {'*'},
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", {link = "Type"})
  end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = {"*"},
  callback = function()
    if vim.o.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end
})

vim.api.nvim_create_autocmd({ "LspAttach" }, {
  pattern = {'*'},
  callback = function()
    local root = vim.lsp.buf.list_workspace_folders()
    if (#root > 0) then
      vim.notify("LSP attached to "..root[1])
    else
      vim.notify("LSP running in single-file mode")
    end
  end,
})
