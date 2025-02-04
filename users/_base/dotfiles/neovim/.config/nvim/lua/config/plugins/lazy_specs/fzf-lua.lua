local find_leader = "g/"

return {
  "fzf-lua",
  cmd = "FzfLua",
  keys = {
    { find_leader .. "f", "<cmd>lua require('fzf-lua').files()<CR>" },
    { find_leader .. "/", "<cmd>lua require('fzf-lua').builtin()<CR>" },
    { "<C-/>", "<cmd>lua require('fzf-lua').builtin()<CR>" },
  },
}
