vim.g.nvim_surround_no_mappings = true

vim.keymap.set("n", "gs", "<Plug>(nvim-surround-normal)", {
  desc = "Add a surrounding pair around a motion (normal mode)",
})

vim.keymap.set("n", "gS", "<Plug>(nvim-surround-normal-line)", {
  desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
})

vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)", {
  desc = "Add a surrounding pair around a visual selection",
})

vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", {
  desc = "Add a surrounding pair around a visual selection, on new lines",
})

vim.keymap.set("n", "gsd", "<Plug>(nvim-surround-delete)", {
  desc = "Delete a surrounding pair",
})

vim.keymap.set("n", "gsc", "<Plug>(nvim-surround-change)", {
  desc = "Change a surrounding pair",
})

require("nvim-surround").setup({
  surrounds = {},
  aliases = {},
  highlight = {
    duration = 0,
  },
  move_cursor = "sticky",
})
