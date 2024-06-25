-- configuration gets merged on multiple levels (highest priority first):
--  (1) user configuration, i.e. the one we assign to when we execute e.g. require("lspconfig")["lua_ls"].setup(<config>)
--  (2) server-specific default configuration, located in e.g. require("lspconfig.server_configurations.lua_ls").default_config
--  (3) global default configuration, located in require("lspconfig.util").default_config

return {
  ["clangd"] = require("plugin.lsp._configurations.clangd"),
  ["lua_ls"] = require("plugin.lsp._configurations.lua_ls"),
  ["nil_ls"] = require("plugin.lsp._configurations.nil_ls"),
  ["pyright"] = require("plugin.lsp._configurations.pyright"),
  ["texlab"] = require("plugin.lsp._configurations.texlab"),
}
