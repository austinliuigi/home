require("indent_blankline").setup {
  show_current_context = false, -- color line cursor is highlighted differently
  show_current_context_start = false, -- underline beginning of context
  show_end_of_line = false,
}

vim.api.nvim_create_augroup('IndentBlanklineCustomHighlight', {clear = true})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'IndentBlanklineCustomHighlight',
  pattern = {'*'},
  callback = function()
    vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", {link = "Type"})
    vim.api.nvim_set_hl(0, "IndentBlanklineChar", {link = "Whitespace"})
  end
})

vim.cmd('hi! link IndentBlanklineContextChar Type')
