-- local find_leader = "g/"

return {
  "fzf-lua",
  event = "DeferredUIEnter", -- ensure that fzf-lua loads for vim.ui.select
  -- cmd = "FzfLua",
  -- keys = {
  --   { find_leader .. "f", "<cmd>lua require('fzf-lua').files()<CR>" },
  --   { find_leader .. "/", "<cmd>lua require('fzf-lua').builtin()<CR>" },
  --   { "<C-/>", "<cmd>lua require('fzf-lua').builtin()<CR>" },
  -- },
  after = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "FzfLuaLoadPost", modeline = false })
  end,
}
