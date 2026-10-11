return {
  "blink.compat",
  event = "DeferredUIEnter",
  after = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "BlinkCompatLoadPost", modeline = false })
  end,
}
