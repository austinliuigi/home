require("persistence").setup({
  dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
  need = 1, -- minimum number of file buffers that need to be open to save session
  branch = true, -- take into account git branch for session names
})

vim.api.nvim_create_user_command("SessionLoad", function()
  require("persistence").load()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionLoadLast", function()
  require("persistence").load({ last = true })
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionSelect", function()
  require("persistence").select()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SessionStop", function()
  require("persistence").stop()
end, { nargs = 0 })

vim.keymap.set("n", "<BS>", "<cmd>SessionSelect<CR>", { remap = false })
vim.keymap.set("n", "<leader><BS>", "<cmd>SessionLoad<CR>", { remap = false })
