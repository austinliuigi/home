require('Comment').setup {
}

vim.keymap.set("x", "gC", ":<C-b>keeppatterns <C-e>g/./normal gcc<CR>", {remap = false})
