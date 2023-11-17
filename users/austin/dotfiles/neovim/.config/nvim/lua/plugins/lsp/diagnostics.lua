local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local diagnostic_config = {
  underline = false,
  virtual_text = false,
  virtual_lines = false,
  signs = { priority = 8 },
  update_in_insert = false,
  severity_sort = true,
  float = {
    scope = 'line',
    border = 'rounded',
    header = '',
    source = true,
    prefix = '',
  }
}

vim.diagnostic.config(diagnostic_config)

return diagnostic_config
