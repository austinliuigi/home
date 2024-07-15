local lspconfig = require("lspconfig")
require("config.plugins.configurations.lspconfig._ui")
require("config.plugins.configurations.lspconfig._diagnostics")

local global_config = {
  on_attach = require("config.plugins.configurations.lspconfig._attach"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

for server, config in pairs(require("config.plugins.configurations.lspconfig._configurations")) do
  lspconfig[server].setup(vim.tbl_deep_extend("keep", config, global_config))
end
