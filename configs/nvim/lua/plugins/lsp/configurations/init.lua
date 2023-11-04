-- configuration gets merged on multiple levels (highest priority first):
--  (1) user configuration, i.e. the one we assign to when we execute e.g. require("lspconfig")["lua_ls"].setup(<config>)
--  (2) server-specific default configuration, located in e.g. require("lspconfig.server_configurations.lua_ls").default_config
--  (3) global default configuration, located in require("lspconfig.util").default_config

return {
  ["clangd"] = require("plugins.lsp.configurations.clangd"),
  ["lua_ls"] = require("plugins.lsp.configurations.lua_ls"),
  ["pyright"] = require("plugins.lsp.configurations.pyright"),
}
