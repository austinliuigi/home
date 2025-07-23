local diagnostics = require("config.plugins.configurations.lspconfig._diagnostics")
local nvim_navic_ok, nvim_navic = pcall(require, "nvim-navic")
if not nvim_navic_ok then
  vim.notify("plugins(lspconfig.attach): unable to load nvim-navic", vim.log.levels.ERROR)
end

local function on_attach(client, bufnr)
  local bufopts = { remap = false, silent = true, buffer = bufnr }
  vim.lsp.inlay_hint.enable(false, {})

  -- Misc
  --------------------------------------------------------------------------------------------
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)

  -- Documentation
  --------------------------------------------------------------------------------------------
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover({ border = "rounded" })
  end, bufopts)
  vim.keymap.set("n", "<leader>K", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, bufopts)

  -- Diagnostics
  --------------------------------------------------------------------------------------------
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, bufopts)
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, bufopts)
  vim.keymap.set("n", vim.g.toggle_key .. "d", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", vim.g.toggle_key .. "D", diagnostics.toggle_diagnostics, bufopts)

  -- Hints
  --------------------------------------------------------------------------------------------
  vim.keymap.set("n", vim.g.toggle_key .. "H", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled, {})
  end, bufopts)

  -- Third-party plugins
  --------------------------------------------------------------------------------------------
  if nvim_navic_ok then
    nvim_navic.attach(client, bufnr)
  end
end

return on_attach
