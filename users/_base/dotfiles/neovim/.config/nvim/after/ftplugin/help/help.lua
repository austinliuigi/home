-- Open help vertically on right side
vim.api.nvim_create_augroup("VerticalHelp", {clear = false})
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  group   = "VerticalHelp",
  callback = function()
    vim.cmd("wincmd L")
  end,
  buffer = 0,
})
