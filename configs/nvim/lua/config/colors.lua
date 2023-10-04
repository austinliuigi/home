-- TODO: Generalize to different terminals
local is_kitty = os.getenv("TERM") == "xterm-kitty"
local is_wezterm = os.getenv("TERM_PROGRAM") == "WezTerm"

-- TODO: Generalize to multiple terminals
local function reload_term_config()
  if is_kitty then
    -- Note: os.execute doesn't work for some reason
    -- TODO: Check if works on linux
    vim.fn.system("kill -SIGUSR1 $(pgrep -a kitty)")
  end
end

-- TODO: Exit early if in windows or config file doesn't exist

local M = {
  default_theme = "smoke",
  term_theme = "",
  transparent = false,
}

-- Map of neovim colorscheme names(g:colors_name) to kitty theme names (## name:)
local nvim_to_kitty = {
  ['carbonfox']        = { dark = 'carbonfox',        light = 'carbonfox' },
  ['codedark']         = { dark = 'vscode-dark',      light = 'vscode-dark' },
  ['dawnfox']          = { dark = 'dawnfox',          light = 'dawnfox' },
  ['dayfox']           = { dark = 'dayfox',           light = 'dayfox' },
  ['duskfox']          = { dark = 'duskfox',          light = 'duskfox' },
  ['gruvbox']          = { dark = 'gruvbox-dark',     light = 'gruvbox-light' },
  ['kanagawa']         = { dark = 'kanagawa-dark',    light = 'kanagawa-light' },
  ['material']         = { dark = 'palenight',        light = 'palenight' },
  ['nightfox']         = { dark = 'nightfox',         light = 'nightfox' },
  ['nord']             = { dark = 'nord-dark',        light = 'nord-light' },
  ['nordfox']          = { dark = 'nordfox',          light = 'nordfox' },
  ['onedark']          = { dark = 'onedark',          light = 'onelight' },
  ['rose-pine']        = { dark = 'rosepine-moon',    light = 'rosepine-dawn' },
  ['seoul256']         = { dark = 'seoul256',         light = 'seoul256' },
  ['terafox']          = { dark = 'terafox',          light = 'terafox' },
  ['tokyonight-night'] = { dark = 'tokyonight-night', light = 'tokyonight-day' },
  ['everforest']       = { dark = 'everforest-dark',  light = 'everforest-light'},
  ['smoke']            = { dark = 'smoke-dark',       light = 'smoke-light'},
  -- ['vscode']     = { dark = 'vscode-dark',      light = 'vscode-light' },
}
-- Map of kitty theme names to neovim colorscheme names
local kitty_to_nvim = { dark = {}, light = {} }
for nvim_color, kitty in pairs(nvim_to_kitty) do
  kitty_to_nvim.dark[kitty.dark] = nvim_color
  kitty_to_nvim.light[kitty.light] = nvim_color
end

-- TODO: Generalize to multiple terminals
-- Current kitty theme; Note: $1 is '##' and $2 is 'name:' and $3 is the kitty theme name
local kitty_theme = nil
if is_kitty and vim.fn.filereadable(vim.fn.expand("~/.config/kitty/current-theme.conf")) then
  kitty_theme = vim.fn.trim(vim.fn.system("awk '/name/ {print substr($0, index($0,$3))}' ~/.config/kitty/current-theme.conf"))
end

-- TODO: Get term transparency for initial transparency setting
local kitty_transparency = nil
if is_kitty and vim.fn.filereadable(vim.fn.expand("~/.config/kitty/current-theme.conf")) then
  kitty_transparency = vim.fn.trim(vim.fn.system("awk '/background_opacity/ {print $2}' ~/.config/kitty/kitty.conf"))
  M.transparent = kitty_transparency ~= "1"
end



--[[ Config Options ]]

local function refresh_colorscheme_configs()
  vim.api.nvim_exec_autocmds("User", { pattern = "RefreshColorschemeConfigs" })
end



--[[ Toggle Transparency ]]

-- TODO: Generalize to multiple terminals
local function change_term_transparency()
  -- local kitty_config
  -- vim.fn.system("[ -L ~/.config/kitty/kitty.conf ]")
  -- if vim.v.shell_error == 0 then
  --   kitty_config = vim.fn.trim(vim.fn.system("readlink -f ~/.config/kitty/kitty.conf"))
  -- else
  --   kitty_config = "~/.config/kitty/kitty.conf"
  -- end

  -- print(string.format("sed -i%s '/^background_opacity/ s/[^ ][^ ]*$/%s/' %s", vim.fn.has("mac") == 1 and " ''" or '', term_opacity, kitty_config))
  -- TODO: check if works on linux
  -- os.execute(string.format("sed -i%s '/^background_opacity/ s/[^ ][^ ]*$/%s/' %s", vim.fn.has("mac") == 1 and " ''" or '', term_opacity, kitty_config))
  local term_opacity = M.transparent and 0.92 or 1.00

  local tempfile = vim.fn.tempname()
  os.execute(string.format("sed '/^background_opacity/ s/[^ ][^ ]*$/%s/' ~/.config/kitty/kitty.conf > %s", term_opacity, tempfile))
  vim.cmd("vsp "..tempfile)
  vim.cmd("w! ~/.config/kitty/kitty.conf | q")

  reload_term_config()
end

vim.api.nvim_create_user_command("ToggleTransparency", function()
  M.transparent = not M.transparent
  change_term_transparency()
  refresh_colorscheme_configs()
  vim.cmd('colorscheme ' .. vim.g.colors_name)
end, { nargs = 0 })

vim.keymap.set('n', toggle_key..'tr', '<cmd>ToggleTransparency<CR>')



--[[ Set Kitty Theme ]]

-- TODO: Generalize to multiple terminals
-- Set kitty theme if colorscheme is in nvim_to_kitty table and if in kitty terminal
-- Look at :h nvim_create_autocmd and scroll down to parameters
vim.api.nvim_create_augroup('SetKittyTheme', {clear = true})
vim.api.nvim_create_autocmd('ColorScheme', {
  group = 'SetKittyTheme',
  pattern = {'*'},
  callback = function(arg)
    local nvim_colorscheme = arg.match
    if nvim_colorscheme ~= kitty_to_nvim[vim.o.background][kitty_theme] and is_kitty and nvim_to_kitty[nvim_colorscheme] ~= nil then
      kitty_theme = nvim_to_kitty[nvim_colorscheme][vim.o.background]
      os.execute('kitty +kitten themes --reload-in=all ' .. kitty_theme)
    end
  end,
  desc = 'Set kitty theme based on current neovim colorscheme'
})



--[[ Set Initial Colorscheme ]]

-- TODO: Generalize to multiple terminals
-- Set colorscheme to kitty theme if possible, otherwise set to nord
local SetInitialColorscheme = function()
  refresh_colorscheme_configs()
  if kitty_to_nvim["light"][kitty_theme] ~= nil then
    vim.o.background = "light"
    vim.cmd('colorscheme ' .. kitty_to_nvim[vim.o.background][kitty_theme])
  elseif kitty_to_nvim["dark"][kitty_theme] ~= nil then
    vim.o.background = "dark"
    vim.cmd('colorscheme ' .. kitty_to_nvim[vim.o.background][kitty_theme])
  else
    vim.cmd('colorscheme ' .. M.default_theme)
  end
end
-- vim.schedule(SetInitialColorscheme)

vim.api.nvim_create_augroup('InitialColorscheme', {clear = true})
vim.api.nvim_create_autocmd('VimEnter', {
  group = 'InitialColorscheme',
  pattern = {'*'},
  nested = true,
  callback = SetInitialColorscheme,
  desc = "Set initial colorscheme based on kitty theme; setting on 'VimEnter' allows for highlights set by 'Colorscheme' autocmd to fire"
})

return M
