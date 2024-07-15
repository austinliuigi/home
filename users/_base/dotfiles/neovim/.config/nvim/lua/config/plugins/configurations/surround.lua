require("nvim-surround").setup({
  keymaps = {
    insert = false,
    insert_line = false,
    normal = "gs",
    normal_cur = false,
    normal_line = "gS",
    normal_cur_line = "gss",
    visual = "gs",
    visual_line = "gS",
    delete = "gsd",
    change = "gsc",
  },
  surrounds = {},
  aliases = {},
  highlight = {
    duration = 0,
  },
  move_cursor = false,
})
