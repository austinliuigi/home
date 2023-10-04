local toggle = require("austin.keymaps").toggle_key

vim.keymap.set("n", toggle.."s", function()
  vim.g.smoothie_enabled = not vim.g.smoothie_enabled
end, {})
