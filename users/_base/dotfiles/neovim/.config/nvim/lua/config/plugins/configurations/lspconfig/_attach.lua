local diagnostic_config = require("config.plugins.configurations.lspconfig._diagnostics")
local nvim_navic_ok, nvim_navic = pcall(require, "nvim-navic")
if not nvim_navic_ok then
  vim.notify("plugins(lspconfig.attach): unable to load nvim-navic", vim.log.levels.ERROR)
end

local diagnostic_index = 1
local diagnostic_toggle_order = {
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

local function toggle_diagnostics()
  diagnostic_index = (diagnostic_index % #diagnostic_toggle_order) + 1
  diagnostic_config.underline = diagnostic_toggle_order[diagnostic_index]["underline"]
  diagnostic_config.virtual_text = diagnostic_toggle_order[diagnostic_index]["virtual_text"]

  vim.diagnostic.config(diagnostic_config)
end

local function on_attach(client, bufnr)
  local bufopts = { remap = false, silent = true, buffer = bufnr }
  vim.lsp.inlay_hint.enable(false, {})

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "<leader>K", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
  vim.keymap.set("n", toggle_key .. "d", vim.diagnostic.open_float, bufopts)
  vim.keymap.set("n", toggle_key .. "D", toggle_diagnostics, bufopts)
  vim.keymap.set("n", toggle_key .. "H", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(not enabled, {})
  end, bufopts)

  if nvim_navic_ok then
    nvim_navic.attach(client, bufnr)
  end
end

return on_attach
