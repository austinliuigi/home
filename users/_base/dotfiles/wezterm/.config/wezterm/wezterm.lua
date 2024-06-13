local wezterm = require("wezterm")
local config = {}

config.colors = require("colors")
config.font = require("font")
config.window_frame = require("titlebar")

config.disable_default_key_bindings = false
config.keys = require("keybinds")
config.debug_key_events = false

require("tabtitles")

return config
