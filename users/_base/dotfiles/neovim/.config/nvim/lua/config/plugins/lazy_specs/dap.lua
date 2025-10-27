return {
  "nvim-dap",
  keys = {
    { "<Down>", "<cmd>lua require('dap').step_over()<CR>", desc = "Dap: Step Over" },
    { "<S-Down>", "<cmd>lua require('dap').step_out()<CR>", desc = "Dap: Step Out" },

    { "<Right>", "<cmd>lua require('dap').step_into()<CR>", desc = "Dap: Step Into" },
    { "<S-Right>", "<cmd>lua require('dap').continue()<CR>", desc = "Dap: Continue" },

    { "<Left>", "<cmd>lua require('dap').step_back()<CR>", desc = "Dap: Step Back" },
    { "<S-Left>", "<cmd>lua require('dap').reverse_continue()<CR>", desc = "Dap: Reverse Continue" },

    {
      "<Up>",
      function()
        if require("dap").session() then
          require("dap").repl.toggle()
        end
      end,
      desc = "Dap: Toggle REPL",
    },
    { "<S-Up>", "<cmd>lua require('dap').terminate()<CR>", desc = "Dap: Terminate" },

    { "<C-'>", "<cmd>lua require('dap').toggle_breakpoint()<CR>", desc = "Dap: Toggle Breakpoint" },
    {
      "<C-S-'>",
      "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint Condition: '))<CR>",
      desc = "Dap: Toggle Conditional Breakpoint",
    },
  },
  after = function()
    vim.api.nvim_exec_autocmds("User", { pattern = "DapLoadPost", modeline = false })
  end,
}
