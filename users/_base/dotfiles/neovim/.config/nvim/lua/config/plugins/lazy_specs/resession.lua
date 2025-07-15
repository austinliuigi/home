return {
  "resession.nvim",
  cmd = "ResessionSave",
  keys = {
    { "<BS>", "<cmd>lua require('resession').load()<CR>" },
    { "<C-BS>", "<cmd>ResessionSave<CR>" },
  },
}
