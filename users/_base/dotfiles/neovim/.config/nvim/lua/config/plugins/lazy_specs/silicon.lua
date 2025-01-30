return {
  "nvim-silicon",
  cmd = "Silicon",
  keys = {
    { "<leader>y", "<cmd>lua require('nvim-silicon').clip()<CR>", mode = { "n", "x" } },
  },
}
