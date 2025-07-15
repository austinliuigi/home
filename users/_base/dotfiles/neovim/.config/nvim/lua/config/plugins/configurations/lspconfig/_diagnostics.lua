local diagnostic_config = {
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    scope = "line",
    border = "rounded",
    header = "",
    source = true,
    prefix = "",
  },
}

vim.diagnostic.config(diagnostic_config)
