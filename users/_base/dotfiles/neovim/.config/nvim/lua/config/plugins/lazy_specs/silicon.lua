return {
  "nvim-silicon",
  cmd = "Silicon",
  keys = {
    { "gy", "<cmd>lua require('nvim-silicon').clip()<CR>", mode = { "n", "x" } },
  },
}
