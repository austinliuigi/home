local wezterm = require("wezterm")

local font_ok, font = pcall(dofile, os.getenv("HOME") .. "/.local/share/wezterm/font.lua")
if not font_ok then
  print("config: font config not found")
  return wezterm.font("Inconsolata") -- fallback
end

return wezterm.font(font.mono .. " Mono")
