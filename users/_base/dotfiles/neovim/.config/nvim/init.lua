require("config.keybinds")
require("config.options")
require("config.autocmds")
-- require("config.colors")
-- require("config.lazy")
require("config.rocks")
require("scripts.lastplace")
require("scripts.quarter")
require("scripts.text-objects")

vim.cmd([[packadd rocks-dev.nvim]]) -- temporary fix until https://github.com/nvim-neorocks/rocks-dev.nvim/issues/8 gets fixed
