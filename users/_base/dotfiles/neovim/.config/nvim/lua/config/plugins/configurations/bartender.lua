local providers = require("bartender.providers")
local utils = require("bartender.utils")

local dye = require("dye")
local hl_attr = utils.hl_attr
local hl_wrap = utils.hl_attrs_wrap
local f = function(ret)
  return function()
    return ret
  end
end
local fwrap = function(func, ...)
  local args = { ... }
  return function()
    return func(unpack(args))
  end
end
local t = function(tbl)
  return function()
    local res = {}
    for k, v in pairs(tbl) do
      local func = v[1]
      res[k] = func(select(2, unpack(v)))
    end
    return res
  end
end

-- stylua: ignore start
--==================================================================================================
-- Custom Providers
--==================================================================================================

local winbar_left = function(fg, bg)
  fg = fg or utils.hl_attr_wrap("Normal", "fg")
  bg = bg or utils.hl_attr_wrap("Comment", "fg")

  return {
    { " ",                hl = { bg = bg } },
    { providers.lsp_root, hl = { fg = fg, bg = bg } },
    { " ",                hl = { bg = bg } },
    { "",                hl = { fg = bg } },
  }, {}
end

local winbar_right = function(fg, bg)
  fg = fg or "transparent"
  bg = bg or utils.hl_attr_wrap("Comment", "fg")

  return {
    { "",             hl = { fg = "transparent", bg = bg } },
    { " ",             hl = { bg = bg } },
    { providers.bufnr, hl = { fg = fg, bg = bg, bold = true } },
    { " ",             hl = { bg = bg } },
  }, {}
end

local statusline_left = function()
  return {
    { providers.groups.mode },
    { "",                     hl = function() return { fg = providers.mode.current_mode_hl().bg, bg = utils.hl_attr_wrap("Comment", "fg") } end },
    { " %l : %v ",           hl = hl_wrap({ fg = {"Normal", "bg"}, bg = { "Comment", "fg"}}) },
    { "",                     hl = hl_wrap({ fg = { "Comment", "fg"}}) },
  }, {}
end

local statusline_center = function()
  local left_width = utils.get_cached_component_width("BartenderStatusline", 1)
  local right_width = utils.get_cached_component_width("BartenderStatusline", 3)
  return {
    { "%=" },
    { string.rep(" ", math.max(0, right_width - left_width)) },
    { providers.groups.cwd },
    { string.rep(" ", math.max(0, left_width - right_width)) },
    { "%=" },
  }
end

local statusline_right = function()
  return {
    { " 󱡶 "..vim.uv.os_gethostname().." ", hl = vim.env.SSH_TTY and hl_wrap({ fg = {"Error", "fg"} }) or hl_wrap({ fg = {"Comment", "fg"} }) },
    { "",                               hl = hl_wrap({ fg = {"Base02", "fg"} }) },
    { "  "..vim.v.servername.." ",        hl = hl_wrap({ fg = {"Base00", "fg"}, bg = {"Base02", "fg"} }) },
    { "",                               hl = hl_wrap({ fg = {"Base02", "fg"}, bg = {"Base03", "fg"} }) },
    { " $ "..vim.fn.getpid().." ",         hl = hl_wrap({ fg = {"Base00", "fg"}, bg = {"Base03", "fg"} }) },
  }, {}
end

--==================================================================================================
-- Config
--==================================================================================================

require("bartender").setup({
  winbar = {
    active = {
      { winbar_left },
      { " " },
      { providers.groups.buffer },
      { "%=" },
      { providers.navic },
      { " " },
      { winbar_right },
    },
    inactive = {
      { winbar_left, args = function() return { utils.hl_attr_wrap("Comment", "fg"), utils.hl_attr_wrap("TabLine", "bg") } end, },
      { " " },
      { providers.groups.buffer },
      { "%=" },
      { winbar_right, args = function() return { utils.hl_attr_wrap("Comment", "fg"), utils.hl_attr_wrap("TabLine", "bg") } end, },
    },
  },
  statusline = {
    global = {
      { statusline_left },
      { statusline_center },
      { statusline_right },
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
