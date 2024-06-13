local wezterm = require("wezterm")

wezterm.on("open-scrollback-in-editor", function(window, pane)
  -- Retrieve the current viewport's text.
  -- Pass an optional number of lines (eg: 2000) to retrieve
  -- that number of lines starting from the bottom of the viewport
  local scrollback = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

  -- Create a temporary file to pass to vim
  local name = os.tmpname()
  local f = io.open(name, "w+")
  f:write(scrollback)
  f:flush()
  f:close()

  -- Open nvim with the scrollback in a new tab
  window:perform_action(
    wezterm.action({ SpawnCommandInNewTab = {
      args = { "nvim", name, "-c set nowrap" },
    } }),
    pane
  )

  -- wait "enough" time for vim to read the file before we remove it.
  -- The window creation and process spawn are asynchronous
  -- wrt. running this script and are not awaitable, so we just pick
  -- a number.
  wezterm.sleep_ms(1000)
  os.remove(name)
end)

local keybinds = {
  -- PANES
  {
    key = "h",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "k",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "j",
    mods = "ALT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  -- TABS
  { key = ",", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = ".", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
  { key = "<", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
  { key = ">", mods = "ALT|SHIFT", action = wezterm.action.MoveTabRelative(1) },
  { key = "w", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
  {
    key = "r",
    mods = "ALT",
    action = wezterm.action.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },

  { key = "e", mods = "ALT", action = wezterm.action({ EmitEvent = "open-scrollback-in-editor" }) },
  { key = "/", mods = "ALT", action = wezterm.action.ActivateCommandPalette },
}

return keybinds
