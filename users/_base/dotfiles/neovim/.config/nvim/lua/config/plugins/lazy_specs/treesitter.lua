return {
  "nvim-treesitter",
  event = "DeferredUIEnter",
  after = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "TreesitterLoadPost", modeline = false })
  end,
}
