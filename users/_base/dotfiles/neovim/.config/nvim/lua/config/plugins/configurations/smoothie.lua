vim.keymap.set("n", vim.g.toggle_key .. "s", function()
  vim.g.smoothie_enabled = not vim.g.smoothie_enabled
end, {})
