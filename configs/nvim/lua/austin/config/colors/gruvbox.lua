require("gruvbox").setup({
  undercurl = true,
  underline = true,
  bold = true,
  italic = true,
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  dim_inactive = false,
  transparent_mode = require("austin.colors").transparent,
  overrides = {
    -- Normal = require("gruvbox").config.transparent_mode and { fg = "#fbf1c7", bg = nil } or { fg = "#fbf1c7", bg = "#282828" },
  }
})
