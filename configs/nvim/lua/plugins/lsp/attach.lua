local diagnostic_config = require("plugins.lsp.diagnostics")

local diagnostic_idx = 1
local diagnostic_order = {
  {
    underline = false,
    virtual_text = false,
  },
  {
    underline = false,
    virtual_text = true,
  },
  {
    underline = true,
    virtual_text = false,
  },
}

function toggle_diagnostics()
  diagnostic_idx = (diagnostic_idx % #diagnostic_order) + 1
  diagnostic_config.underline = diagnostic_order[diagnostic_idx]["underline"]
  diagnostic_config.virtual_text = diagnostic_order[diagnostic_idx]["virtual_text"]

  vim.diagnostic.config(diagnostic_config)
end

function on_attach(client, bufnr)
  local bufopts = { remap = false, silent = true, buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', toggle_key..'d', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', toggle_key..'D', toggle_diagnostics, bufopts)

  -- require("nvim-navic").attach(client, bufnr)
end

return on_attach
