vim.keymap.set("n", "<Up>", function()
  return require("dap").step_over()
end)
vim.keymap.set("n", "<Down>", function()
  return require("dap").step_out()
end)
vim.keymap.set("n", "<Left>", function()
  return require("dap").step_back()
end)
vim.keymap.set("n", "<Right>", function()
  return require("dap").step_into()
end)
vim.keymap.set("n", "<S-Up>", function()
  return require("dap").repl.toggle()
end)
vim.keymap.set("n", "<S-Down>", function()
  return require("dap").terminate()
end)
vim.keymap.set("n", "<S-Left>", function()
  return require("dap").reverse_continue()
end)
vim.keymap.set("n", "<S-Right>", function()
  return require("dap").continue()
end)
vim.keymap.set("n", "<CR>", function()
  return require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<S-CR>", function()
  return require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition: "))
end)

local dap = require("dap")

for lang, configuration in pairs(require("plugin.dap._configurations")) do
  dap.configurations[lang] = configuration
end

for lang, adapter in pairs(require("plugin.dap._adapters")) do
  dap.adapters[lang] = adapter
end

-- TODO: Decouple from wezterm
dap.defaults.fallback.external_terminal = {
  command = tostring(io.popen("command -v wezterm"):read("*line")),
  args = {},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error", linehl = "", numhl = "" }) -- ●      ﴫ
vim.fn.sign_define("DapBreakpointCondition", { text = "ﴫ", texthl = "Special", linehl = "", numhl = "" })
