if vim.loader then
  vim.loader.enable() -- builtin bytecode cache for loaded modules
end

local builtin_plugins = {
  "gzip",
  "matchit",
  "matchparen",
  "netrwPlugin",
  "tarPlugin",
  "tutor_mode_plugin",
  "zipPlugin",
  "2html_plugin",
}

for i = 1, #builtin_plugins do
  vim.g["loaded_" .. builtin_plugins[i]] = true
end

require("config.autocmds")
require("config.commands")
require("config.functions")
require("config.keybinds")
require("config.options")
require("config.rocks")

require("scripts.dashboard")
require("scripts.diff")
require("scripts.lastplace")
require("scripts.quarter")
require("scripts.text-objects")
require("scripts.highlighter")
require("scripts.pasterator")
require("scripts.tree")
require("scripts.waldo")
require("scripts.todo")
