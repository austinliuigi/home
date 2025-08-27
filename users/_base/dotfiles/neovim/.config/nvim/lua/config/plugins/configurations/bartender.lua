local providers = require("bartender.providers")
local utils = require("bartender.utils")

-- stylua: ignore start
--==================================================================================================
-- Custom Providers
--==================================================================================================

local head = function(fg, bg)
  fg = fg or utils.hl_attr_wrap("Normal", "fg")
  bg = bg or utils.hl_attr_wrap("Comment", "fg")

  return {
    { " ", hl = { bg = bg } },
    { providers.lsp_root, hl = { fg = fg, bg = bg } },
    { " ", hl = { bg = bg } },
    { "", hl = { fg = bg } },
  }, {}
end

local tail = function(fg, bg)
  fg = fg or "transparent"
  bg = bg or utils.hl_attr_wrap("Comment", "fg")

  return {
    { "", hl = { fg = "transparent", bg = bg } },
    { " ", hl = { bg = bg } },
    { providers.bufnr, hl = { fg = fg, bg = bg, bold = true } },
    { " ", hl = { bg = bg } },
  }, {}
end

--==================================================================================================
-- Config
--==================================================================================================

require("bartender").setup({
  winbar = {
    active = {
      { head },
      { " " },
      { providers.groups.buffer },
      { "%=" },
      { providers.navic },
      { " " },
      { tail },
    },
    inactive = {
      { head, args = function() return { utils.hl_attr_wrap("Comment", "fg"), utils.hl_attr_wrap("TabLine", "bg") } end, },
      { " " },
      { providers.groups.buffer },
      { "%=" },
      { tail, args = function() return { utils.hl_attr_wrap("Comment", "fg"), utils.hl_attr_wrap("TabLine", "bg") } end, },
    },
  },
  statusline = {
    global = {
      { providers.groups.mode },
      { "", hl = function() return { fg = providers.mode.current_mode_hl().bg, bg = utils.hl_attr("Comment", "fg") } end },
      { "  " .. vim.fn.getpid(), hl = utils.hl_attrs_wrap({ fg = { "Normal", "bg" }, bg = { "Comment", "fg" }}) },
      { "█", hl = { fg = utils.hl_attr_wrap("Comment", "fg") } },
      { "%=" },
      { providers.groups.cwd },
      { "%=" },
      { providers.groups.pos },
      {
        { "", hl = { fg = "transparent", bg = utils.hl_attr_wrap("Normal", "fg") } },
        { " ", hl = { bg = utils.hl_attr_wrap("Normal", "fg") } },
        { providers.fileformat, hl = utils.hl_attrs_wrap({ fg = { "Comment", "fg" }, bg = { "Normal", "fg" } }), },
        { " ", hl = { bg = utils.hl_attr_wrap("Normal", "fg") } },
      },
    },
  },
  tabline = {
    global = {
      { providers.groups.tabs },
    },
  },
  statuscolumn = {
    active = {
      { "%s" },
      { providers.statuscolumn.fold, args = { 99 } },
      { " %l " },
    },
    inactive = {
      { "%s" },
      { "%l " },
    },
  },
})
