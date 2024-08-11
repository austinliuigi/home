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
require("scripts.lastplace")
require("scripts.quarter")
require("scripts.text-objects")
require("scripts.highlighter")
require("scripts.waldo")

vim.cmd([[silent! packadd rocks-dev.nvim]]) -- temporary fix until https://github.com/nvim-neorocks/rocks-dev.nvim/issues/8 gets fixed
