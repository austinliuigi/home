local toggle_key = require("austin.keymaps").toggle_key

require("bartender").setup({})
vim.keymap.set({"n"}, toggle_key.."f", function()
  local config = require("bartender.config")
  local next_type = {
    tail = "rel",
    rel = "abs",
    abs = "tail",
  }
  config.filepath_type = next_type[config.filepath_type]
end, {})
