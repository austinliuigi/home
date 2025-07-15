return {
  "codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
  keys = {
    { "+", "<cmd>CodeCompanionChat Toggle<CR>" },
    { "<leader>+", "<cmd>CodeCompanionActions<CR>" },
  },
  before = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "CodeCompanionLoadPre", modeline = false })
  end,
}
