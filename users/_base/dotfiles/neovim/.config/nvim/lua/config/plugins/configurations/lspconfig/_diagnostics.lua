local diagnostics = {}

diagnostics.base_diagnostic_config = {
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
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

local diagnostic_index = 1
local diagnostic_toggle_order = {
  {
    underline = true,
    virtual_text = false,
  },
  {
    underline = true,
    virtual_text = true,
  },
  {
    underline = false,
    virtual_text = true,
  },
  {
    underline = false,
    virtual_text = false,
  },
}
diagnostics.toggle_diagnostics = function()
  diagnostic_index = (diagnostic_index % #diagnostic_toggle_order) + 1

  vim.diagnostic.config(diagnostic_toggle_order[diagnostic_index])
end

vim.diagnostic.config(vim.tbl_deep_extend("force", diagnostics.base_diagnostic_config, diagnostic_toggle_order[1]))

return diagnostics
