return {
  "nvim-dap",
  keys = {
    { "<Up>", "<cmd>lua require('dap').step_over()<CR>" },
    { "<Down>", "<cmd>lua require('dap').step_out()<CR>" },
    { "<Left>", "<cmd>lua require('dap').step_back()<CR>" },
    { "<Right>", "<cmd>lua require('dap').step_into()<CR>" },
    { "<S-Up>", "<cmd>lua require('dap').repl.toggle()<CR>" },
    { "<S-Down>", "<cmd>lua require('dap').terminate()<CR>" },
    { "<S-Left>", "<cmd>lua require('dap').reverse_continue()<CR>" },
    { "<S-Right>", "<cmd>lua require('dap').continue()<CR>" },
    { "<CR>", "<cmd>lua require('dap').toggle_breakpoint()<CR>" },
    { "<S-CR>", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>" },
  },
  after = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "DapLoadPost", modeline = false })
  end,
}
