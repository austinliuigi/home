return {
  "nvim-lspconfig",
  event = "DeferredUIEnter",
  before = function()
    vim.cmd("packadd! cmp-nvim-lsp") -- for completion capabilities set in config
  end,
  after = function()
    vim.api.nvim_exec_autocmds("FileType", { group = "lspconfig", pattern = vim.o.filetype })
  end,
}
