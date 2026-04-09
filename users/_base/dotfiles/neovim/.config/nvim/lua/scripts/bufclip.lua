local bufclip = {}

function bufclip.yank()
  bufclip.register = vim.api.nvim_get_current_buf()
  vim.notify("Saved current buffer to register", vim.log.levels.INFO, { title = "Bufclip" })
end

function bufclip.paste()
  if bufclip.register then
    vim.cmd("b " .. bufclip.register)
  else
    vim.notify("No buffer in register", vim.log.levels.INFO, { title = "Bufclip" })
  end
end

vim.keymap.set("n", "<leader><leader>y", function()
  bufclip.yank()
end, { desc = "Copy buffer number" })
vim.keymap.set("n", "<leader><leader>p", function()
  bufclip.paste()
end, { desc = "Paste buffer number" })

return bufclip
