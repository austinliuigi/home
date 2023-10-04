local lspconfig = require("lspconfig")
local util = lspconfig.util

local servers = {}

local installed_servers = {
  "clangd",
  "pyright",
  "lua_ls",
  "yamlls",
  "tsserver",
}

for _, server in ipairs(installed_servers) do
  local has_config, config = pcall(require, 'plugins.lsp.configurations.'..server)
  if has_config and type(config) == "table" then
    servers[server] = config
  else
    servers[server] = {}
  end
end

return servers
