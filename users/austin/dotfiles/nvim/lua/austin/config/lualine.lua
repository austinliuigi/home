local navic = require("nvim-navic")

-- Return nerdfont mushroom
local function shroom()
  return 'ﳞ'
end

-- Winbar right center padding (left component length)
local function winbar_right_padding()
  return string.rep(' ', 1)
end

-- Winbar left center padding (right component length)
local function winbar_left_padding()
  if navic.is_available() then
    -- Calculate length
    -- Note: A simple string.len(navic.get_location()) overcounts because a nerd font symbol is > 1 byte
    local length = 0
    for k, _ in ipairs(navic.get_data()) do
      length = length + string.len(navic.get_data()[k].name) + 2    -- 2 is hardcoded length of navic icon (nerd font symbol plus 1 space padding)
      if k > 1 then
        length = length + 3   -- account for separator between sections (' > ')
      end
    end
    return string.rep(' ', length)
  end
  return ''
end

-- Return current directory
local function cwd()
  return string.gsub(vim.fn.getcwd(), vim.env.HOME, '~')
end

-- Use shorthand filepath when vim is narrower than trunc_width
local function trunc_path(trunc_width)
  return function(str)
    local current_width = vim.o.columns
    if trunc_width and current_width < trunc_width then
      return vim.fn.pathshorten(str)
    end
    return str
  end
end

-- Truncate to trunc_len when vim is narrower than trunc_width
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local current_width = vim.o.columns
    if hide_width and current_width < hide_width then return ''
    elseif trunc_width and trunc_len and current_width < trunc_width and #str > trunc_len then
       return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

-- local empty = require('lualine.component'):extend()
-- function empty:draw(default_highlight)
--   self.status = ''
--   self.applied_separator = ''
--   self:apply_highlights(default_highlight)
--   self:apply_section_separators()
--   return self.status
-- end
--
-- -- Put proper separators and gaps between components in sections
-- local function process_sections(sections)
--   for name, section in pairs(sections) do
--     local left = name:sub(9, 10) < 'x'
--     for pos = 1, name ~= 'lualine_z' and #section or #section - 1 do
--       table.insert(section, pos * 2, { empty, color = { fg = "#ffffff", bg = "#ffffff" } })
--     end
--     for id, comp in ipairs(section) do
--       if type(comp) ~= 'table' then
--         comp = { comp }
--         section[id] = comp
--       end
--       comp.separator = left and { right = '' } or { left = '' }
--     end
--   end
--   return sections
-- end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' }, -- { left = '', right = '' } { left = '', right = '' } { left = '', right = '' }
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    always_divide_middle = true, -- prevent a,b,c from leaking to the right side
    globalstatus = true, -- global statusline
  },
  sections = {
    lualine_a = {{'mode', fmt=trunc(80, 1, nil, false), color={gui='bold'}}},
    lualine_b = {'branch'},
    lualine_c = {'%=', { cwd, fmt=trunc_path(80) }},
    lualine_x = {'fileformat'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  -- winbar = {
  --   -- lualine_a = { {shroom, separator = {''}} },
  --   lualine_c = {
  --     {
  --       shroom,
  --       -- color = {
  --       --   bg = '#46693A'
  --       -- },
  --     },
  --     winbar_left_padding,
  --     '%=',
  --     {
  --       'filetype',
  --       icon_only = true
  --     },
  --     {
  --       'filename',
  --       symbols = {
  --         modified = '*'
  --       },
  --       color = {
  --         gui = 'bold,italic'
  --       },
  --       padding = 0
  --     },
  --     '%=',
  --     winbar_right_padding,
  --     {
  --       navic.get_location,
  --       cond = navic.is_available
  --     }
  --   },
  -- },
  -- inactive_winbar = {
  --   lualine_c = {
  --     {
  --       shroom,
  --     },
  --     winbar_left_padding,
  --     '%=',
  --     {
  --       'filetype',
  --       icon_only = true
  --     },
  --     {
  --       'filename',
  --       symbols = {
  --         modified = '*'
  --       },
  --       padding = 0
  --     },
  --     '%=',
  --     winbar_right_padding,
  --     {
  --       navic.get_location,
  --       cond = navic.is_available
  --     }
  --   },
  -- },
  tabline = {},
  extensions = {}
}
