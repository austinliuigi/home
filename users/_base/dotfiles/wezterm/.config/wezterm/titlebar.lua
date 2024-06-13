local wezterm = require("wezterm")

local palette_ok, palette = pcall(dofile, os.getenv("HOME") .. "/.local/share/wezterm/palette.lua")
if not palette_ok then
  print("config: palette config not found")
  return "Batman" -- fallback
end

local font_ok, font = pcall(dofile, os.getenv("HOME") .. "/.local/share/wezterm/font.lua")
if not font_ok then
  print("config: font config not found")
  return wezterm.font("Inconsolata") -- fallback
end

return {
  -- The font used in the tab bar.
  -- Roboto Bold is the default; this font is bundled
  -- with wezterm.
  -- Whatever font is selected here, it will have the
  -- main font setting appended to it to pick up any
  -- fallback fonts you may have used there.
  -- font = wezterm.font(font.monospace .. " Mono"),

  -- The size of the font in the tab bar.
  -- Default to 10.0 on Windows but 12.0 on other systems
  font_size = 12.0,

  -- The overall background color of the tab bar when
  -- the window is focused
  active_titlebar_bg = palette.base01,

  -- The overall background color of the tab bar when
  -- the window is not focused
  inactive_titlebar_bg = palette.base03,
}
