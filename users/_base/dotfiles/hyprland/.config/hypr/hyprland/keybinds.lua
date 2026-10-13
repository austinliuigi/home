local mainMod = "SUPER"
local secondMod = "SHIFT"
local thirdMod = "ALT"

local function keys(key_list)
	return table.concat(key_list, " + ")
end

--===============================================================================
-- GENERAL
--   - https://wiki.hyprland.org/Configuring/Binds/ for more
--===============================================================================

---------------------------------------------------
-- Applications
---------------------------------------------------
hl.bind(keys({ mainMod, "slash" }), hl.dsp.exec_cmd("menu"))
hl.bind(keys({ mainMod, "semicolon" }), hl.dsp.exec_cmd("ghostty"))
hl.bind(keys({ mainMod, "backspace" }), hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(keys({ mainMod, "C" }), hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(keys({ mainMod, secondMod, "1" }), hl.dsp.exec_cmd("pypr toggle todo"))
hl.bind(keys({ mainMod, "W" }), hl.dsp.window.close())

---------------------------------------------------
-- Screenshot
---------------------------------------------------
hl.bind(keys({ mainMod, secondMod, "S" }), hl.dsp.exec_cmd("screenshot"))
-- hl.bind(keys({ mainMod, secondMod, "S" }), hl.dsp.exec_cmd("pkill -SIGINT wl-screenrec"))

---------------------------------------------------
-- Fullscreen and floating
---------------------------------------------------
hl.bind(keys({ mainMod, "F" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/fullscreen-scroll.sh"))
hl.bind(keys({ mainMod, secondMod, "F" }), hl.dsp.window.float({ action = "toggle" }))

---------------------------------------------------
-- Volume
---------------------------------------------------
hl.bind(keys({ "Xf86AudioLowerVolume" }), hl.dsp.exec_cmd("volume decrease"))
hl.bind(keys({ "Xf86AudioRaiseVolume" }), hl.dsp.exec_cmd("volume increase"))
hl.bind(keys({ "Xf86AudioMute" }), hl.dsp.exec_cmd("volume mute"))

---------------------------------------------------
-- Brightness
---------------------------------------------------
hl.bind(keys({ "XF86MonBrightnessDown" }), hl.dsp.exec_cmd("brightness decrease"))
hl.bind(keys({ "XF86MonBrightnessUp" }), hl.dsp.exec_cmd("brightness increase"))

--===============================================================================
-- WINDOWS
--===============================================================================

---------------------------------------------------
-- Change focus
---------------------------------------------------
hl.bind(keys({ mainMod, "H" }), hl.dsp.focus({ direction = "l" }))
hl.bind(keys({ mainMod, "L" }), hl.dsp.focus({ direction = "r" }))
hl.bind(keys({ mainMod, "K" }), hl.dsp.focus({ direction = "u" }))
hl.bind(keys({ mainMod, "J" }), hl.dsp.focus({ direction = "d" }))
hl.bind(keys({ mainMod, "tab" }), hl.dsp.focus({ last = true }))

---------------------------------------------------
-- Resize window
---------------------------------------------------
hl.bind(keys({ mainMod, "mouse:273" }), hl.dsp.window.resize())

---------------------------------------------------
-- Move window
---------------------------------------------------
-- hl.bind(keys({ mainMod, secondMod, "H" }), hl.dsp.window.swap({ direction = "l" }))
-- hl.bind(keys({ mainMod, secondMod, "L" }), hl.dsp.window.swap({ direction = "r" }))
hl.bind(keys({ mainMod, secondMod, "H" }), hl.dsp.layout("swapcol l"))
hl.bind(keys({ mainMod, secondMod, "L" }), hl.dsp.layout("swapcol r"))
hl.bind(keys({ mainMod, secondMod, "K" }), hl.dsp.window.swap({ direction = "u" }))
hl.bind(keys({ mainMod, secondMod, "J" }), hl.dsp.window.swap({ direction = "d" }))

hl.bind(keys({ mainMod, "mouse:272" }), hl.dsp.window.drag())

---------------------------------------------------
-- Move window to workspace
---------------------------------------------------
hl.bind(keys({ mainMod, thirdMod, "comma" }), hl.dsp.window.move({ workspace = "r-1" }))
hl.bind(keys({ mainMod, thirdMod, "period" }), hl.dsp.window.move({ workspace = "r+1" }))

hl.bind(keys({ mainMod, thirdMod, "1" }), hl.dsp.window.move({ workspace = "1" }))
hl.bind(keys({ mainMod, thirdMod, "2" }), hl.dsp.window.move({ workspace = "2" }))
hl.bind(keys({ mainMod, thirdMod, "3" }), hl.dsp.window.move({ workspace = "3" }))
hl.bind(keys({ mainMod, thirdMod, "4" }), hl.dsp.window.move({ workspace = "4" }))
hl.bind(keys({ mainMod, thirdMod, "5" }), hl.dsp.window.move({ workspace = "5" }))
hl.bind(keys({ mainMod, thirdMod, "6" }), hl.dsp.window.move({ workspace = "6" }))
hl.bind(keys({ mainMod, thirdMod, "7" }), hl.dsp.window.move({ workspace = "7" }))
hl.bind(keys({ mainMod, thirdMod, "8" }), hl.dsp.window.move({ workspace = "8" }))
hl.bind(keys({ mainMod, thirdMod, "9" }), hl.dsp.window.move({ workspace = "9" }))
hl.bind(keys({ mainMod, thirdMod, "0" }), hl.dsp.window.move({ workspace = "10" }))

---------------------------------------------------
-- Move window to monitor
---------------------------------------------------
hl.bind(keys({ mainMod, secondMod, thirdMod, "left" }), hl.dsp.window.move({ monitor = "l" }))
hl.bind(keys({ mainMod, secondMod, thirdMod, "right" }), hl.dsp.window.move({ monitor = "r" }))
hl.bind(keys({ mainMod, secondMod, thirdMod, "up" }), hl.dsp.window.move({ monitor = "u" }))
hl.bind(keys({ mainMod, secondMod, thirdMod, "down" }), hl.dsp.window.move({ monitor = "d" }))

--===============================================================================
-- WORKSPACES
--===============================================================================

---------------------------------------------------
-- Change focus
---------------------------------------------------
hl.bind(keys({ mainMod, "comma" }), hl.dsp.focus({ workspace = "r-1" }))
hl.bind(keys({ mainMod, "period" }), hl.dsp.focus({ workspace = "r+1" }))

hl.bind(keys({ mainMod, "1" }), hl.dsp.focus({ workspace = "1" }))
hl.bind(keys({ mainMod, "2" }), hl.dsp.focus({ workspace = "2" }))
hl.bind(keys({ mainMod, "3" }), hl.dsp.focus({ workspace = "3" }))
hl.bind(keys({ mainMod, "4" }), hl.dsp.focus({ workspace = "4" }))
hl.bind(keys({ mainMod, "5" }), hl.dsp.focus({ workspace = "5" }))
hl.bind(keys({ mainMod, "6" }), hl.dsp.focus({ workspace = "6" }))
hl.bind(keys({ mainMod, "7" }), hl.dsp.focus({ workspace = "7" }))
hl.bind(keys({ mainMod, "8" }), hl.dsp.focus({ workspace = "8" }))
hl.bind(keys({ mainMod, "9" }), hl.dsp.focus({ workspace = "9" }))
hl.bind(keys({ mainMod, "0" }), hl.dsp.focus({ workspace = "10" }))

---------------------------------------------------
-- Move workspace
---------------------------------------------------
hl.bind(
	keys({ mainMod, secondMod, "comma" }),
	hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapworkspace.sh r-1")
)
hl.bind(
	keys({ mainMod, secondMod, "period" }),
	hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapworkspace.sh r+1")
)

---------------------------------------------------
-- Move workspace to monitor
---------------------------------------------------
hl.bind(keys({ mainMod, thirdMod, "left" }), hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(keys({ mainMod, thirdMod, "right" }), hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(keys({ mainMod, thirdMod, "up" }), hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(keys({ mainMod, thirdMod, "down" }), hl.dsp.workspace.move({ monitor = "d" }))

---------------------------------------------------
-- Create/remove workspace
---------------------------------------------------
hl.bind(keys({ mainMod, "T" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/insertworkspace.sh"))
-- hl.bind(keys({ mainMod, "W" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/removeworkspace.sh"))

--===============================================================================
-- MONITORS
--===============================================================================

---------------------------------------------------
-- Change focus
---------------------------------------------------
hl.bind(keys({ mainMod, "left" }), hl.dsp.focus({ monitor = "l" }))
hl.bind(keys({ mainMod, "right" }), hl.dsp.focus({ monitor = "r" }))
hl.bind(keys({ mainMod, "up" }), hl.dsp.focus({ monitor = "u" }))
hl.bind(keys({ mainMod, "down" }), hl.dsp.focus({ monitor = "d" }))

---------------------------------------------------
-- Move monitor
---------------------------------------------------
hl.bind(keys({ mainMod, secondMod, "left" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapmonitor.sh l"))
hl.bind(keys({ mainMod, secondMod, "right" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapmonitor.sh r"))
hl.bind(keys({ mainMod, secondMod, "up" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapmonitor.sh u"))
hl.bind(keys({ mainMod, secondMod, "down" }), hl.dsp.exec_cmd("$HOME/.local/share/hyprland/scripts/swapmonitor.sh d"))
