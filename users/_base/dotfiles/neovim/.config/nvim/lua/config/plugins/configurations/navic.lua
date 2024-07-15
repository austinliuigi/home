require("nvim-navic").setup({
  icons = {
    Array = "󰅪 ",
    Boolean = "◩ ",
    Class = "󰠱 ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = "󰈙 ",
    Function = "󰊕 ",
    Interface = "󰕘 ",
    Key = " ",
    Keyword = "",
    Method = "󰊕 ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = "󰎠 ",
    Object = "󱢩 ",
    Operator = "󰆕 ",
    Package = " ",
    Property = " ",
    String = " ",
    Struct = " ",
    TypeParameter = "󰓼 ",
    Variable = "󰀫 ",
  },
  highlight = true,
  separator = " » ",
  depth_limit = 0,
  depth_limit_indicator = "..",
})

local navic_icon_kinds = {
  "Array",
  "Boolean",
  "Class",
  "Constant",
  "Constructor",
  "Enum",
  "EnumMember",
  "Event",
  "Field",
  "File",
  "Function",
  "Interface",
  "Key",
  "Method",
  "Module",
  "Namespace",
  "Null",
  "Number",
  "Object",
  "Operator",
  "Package",
  "Property",
  "String",
  "Struct",
  "TypeParameter",
  "Variable",
}

-- -- TODO: migrate this to palette
-- local set_navic_icon_highlights = function()
--   for _, kind in ipairs(navic_icon_kinds) do
--     -- Link navic highlight to corresponding cmp highlight if possible
--     if vim.fn.hlexists("CmpItemKind" .. kind) ~= 0 then
--       vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = "CmpItemKind" .. kind })
--     -- Link navic highlight to corresponding builtin highlight if possible
--     elseif vim.fn.hlexists(kind) ~= 0 then
--       vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = kind })
--     -- Default to linking to special
--     else
--       vim.api.nvim_set_hl(0, "NavicIcons" .. kind, { link = "Special" })
--     end
--   end
--   vim.api.nvim_set_hl(0, "NavicText", { link = "Comment" })
--   vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Normal" })
-- end
--
-- -- Set navic highlights after changing colorschemes
-- vim.api.nvim_create_augroup("NavicHighlights", { clear = true })
-- vim.api.nvim_create_autocmd("ColorScheme", {
--   group = "NavicHighlights",
--   pattern = { "*" },
--   callback = set_navic_icon_highlights,
-- })
-- -- Set navic highlights after loading nvim-cmp
-- vim.api.nvim_create_autocmd("User", {
--   group = "NavicHighlights",
--   pattern = "CmpConfigLoaded",
--   callback = set_navic_icon_highlights,
-- })
