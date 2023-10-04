vim.g.jupyter_ascending_default_mappings = false

vim.keymap.set({'n'}, "<M-CR>", "<cmd>call jupyter_ascending#execute()<CR>", {remap = true})
vim.keymap.set({'n'}, "<leader><M-CR>", "<cmd>call jupyter_ascending#execute_all()<CR>", {remap = true})
