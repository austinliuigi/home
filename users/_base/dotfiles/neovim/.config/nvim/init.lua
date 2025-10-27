--------------------------------------------------------------------------------
-- PROFILING
--   - https://github.com/nvim-lua/plenary.nvim#plenaryprofile
--------------------------------------------------------------------------------
local is_recording = false
local profiling_file = vim.uv.os_tmpdir() .. "/nvim_profile.log"
local function toggle_profile()
  if is_recording then
    is_recording = false
    vim.notify(
      string.format(
        "Logged profile to %s. You can view a flamegraph with 'nix shell nixpkgs#inferno --command inferno-flamegraph %s > flame.svg && firefox flame.svg'",
        profiling_file,
        profiling_file
      )
    )
    require("plenary.profile").stop()
  else
    is_recording = true
    vim.notify("Logging profile to " .. profiling_file)
    require("plenary.profile").start(profiling_file, { flame = true })
  end
end
vim.keymap.set("", "<f1>", toggle_profile)

--------------------------------------------------------------------------------
-- EXPERIMENTAL LUA MODULE LOADER
--------------------------------------------------------------------------------
if vim.loader then
  vim.loader.enable() -- builtin bytecode cache for loaded modules
end

--------------------------------------------------------------------------------
-- DISABLE BUILTIN PLUGINS
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- CUSTOM CONFIG
--------------------------------------------------------------------------------
require("config.autocmds")
require("config.commands")
require("config.functions")
require("config.keybinds")
require("config.options")
require("config.diagnostics")
require("config.lsp")
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
