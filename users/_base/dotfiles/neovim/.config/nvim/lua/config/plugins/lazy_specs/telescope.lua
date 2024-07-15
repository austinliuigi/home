return {
  "telescope.nvim",
  cmd = "Telescope",
  keys = {
    { "<leader>f", "<cmd>lua require('telescope.builtin').find_files({hidden = true, follow=true})<CR>" },
    { "<C-/>", "<cmd>lua require('telescope.builtin').builtin()<CR>" },
  },
  before = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "TelescopeLoadPre", modeline = false })
  end,
}
