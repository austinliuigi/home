local dap = require("dap")

for lang, configuration in pairs(require("config.plugins.configurations.dap._configurations")) do
  dap.configurations[lang] = configuration
end

for lang, adapter in pairs(require("config.plugins.configurations.dap._adapters")) do
  dap.adapters[lang] = adapter
end

-- TODO: Decouple from wezterm
dap.defaults.fallback.external_terminal = {
  command = tostring(io.popen("command -v wezterm"):read("*line")),
  args = {},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "" }) -- ●      ﴫ
vim.fn.sign_define("DapBreakpointCondition", { text = "ﴫ", texthl = "Special", linehl = "", numhl = "" })
