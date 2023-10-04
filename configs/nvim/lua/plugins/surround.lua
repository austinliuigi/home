return {
  {
    'kylechui/nvim-surround',
    keys = {
      {"gs", mode = {"n", "x"}},
      {"gS", mode = {"n", "x"}},
      {"gsd", mode = {"n"}},
      {"gsc", mode = {"n"}},
    },
    opts = {
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
        duration = 0
      },
      move_cursor = false,
    },
  },
}
