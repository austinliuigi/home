require("nvim-navic").setup {
  icons = {
      File          = " ",
      Module        = " ",
      Namespace     = " ",
      Package       = " ",
      Class         = " ",
      Method        = " ",
      Property      = " ",
      Field         = " ",
      Constructor   = " ",
      Enum          = "練",
      Interface     = "練",
      Function      = " ",
      Variable      = " ",
      Constant      = " ",
      String        = " ",
      Number        = " ",
      Boolean       = "◩ ",
      Array         = " ",
      Object        = " ",
      Key           = " ",
      Null          = "ﳠ ",
      EnumMember    = " ",
      Struct        = " ",
      Event         = " ",
      Operator      = " ",
      TypeParameter = " ",
  },
  highlight = true,
  separator = " » ",
  depth_limit = 0,
  depth_limit_indicator = "..",
}

local navic_icon_kinds = {
  "File",
  "Module",
  "Namespace",
  "Package",
  "Class",
  "Method",
  "Property",
  "Field",
  "Constructor",
  "Enum",
  "Interface",
  "Function",
  "Variable",
  "Constant",
  "String",
  "Number",
  "Boolean",
  "Array",
  "Object",
  "Key",
  "Null",
  "EnumMember",
  "Struct",
  "Event",
  "Operator",
  "TypeParameter",
}

local set_navic_icon_highlights = function()
  for _, kind in ipairs(navic_icon_kinds) do
    -- Link navic highlight to corresponding cmp highlight if possible
    if vim.fn.hlexists("CmpItemKind" .. kind) ~= 0 then
      vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = "CmpItemKind" .. kind })
    -- Link navic highlight to corresponding builtin highlight if possible
    elseif vim.fn.hlexists(kind) ~= 0 then
      vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = kind })
    -- Default to linking to special
    else
      vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = "Special" })
    end
  end
  vim.api.nvim_set_hl(0, "NavicText", { link = "Comment" })
  vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Normal" })
end

-- Set navic highlights after changing colorschemes
vim.api.nvim_create_augroup("NavicHighlights", {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {
  group   = "NavicHighlights",
  pattern = {'*'},
  callback = set_navic_icon_highlights
})
-- Set navic highlights after loading nvim-cmp
vim.api.nvim_create_autocmd("User", {
  group   = "NavicHighlights",
  pattern = "CmpConfigLoaded",
  callback = set_navic_icon_highlights
})
