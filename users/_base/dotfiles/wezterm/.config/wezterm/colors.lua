local colors = {}

local palette_ok, palette = pcall(dofile, os.getenv("HOME") .. "/.local/share/wezterm/palette.lua")
if not palette_ok then
  print("config: palette config not found")
  return "Batman" -- fallback
end

local cursor_color = palette.base13 -- TODO: make random color

return {

  -- The default text color
  foreground = palette.base05,

  -- The default background color
  background = palette.base00,

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = cursor_color,

  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = palette.base00,

  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = cursor_color,

  -- the foreground color of selected text
  selection_fg = palette.base02,

  -- the background color of selected text
  selection_bg = palette.base00,

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = palette.base03,

  -- The color of the split lines between panes
  split = palette.base15,

  ansi = {
    palette.base00, -- "black"
    palette.base08, -- "maroon"
    palette.base0B, -- "green"
    palette.base0A, -- "olive"
    palette.base0D, -- "navy"
    palette.base0E, -- "purple"
    palette.base0C, -- "teal"
    palette.base07, -- "silver"
  },

  brights = {
    palette.base01, -- "grey"
    palette.base12, -- "red"
    palette.base14, -- "lime"
    palette.base13, -- "yellow"
    palette.base16, -- "blue"
    palette.base17, -- "fuchsia"
    palette.base15, -- "aqua"
    palette.base07, -- "white"
  },

  -- Arbitrary colors of the palette in the range from 16 to 255
  indexed = { [136] = "#af8700" },

  -- Since: 20220319-142410-0fcdea07
  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = "orange",

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = "#000000" },

  -- use `AnsiColor` to specify one of the ansi color palette values
  -- (index 0-15) using one of the names "Black", "Maroon", "Green",
  --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
  -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
  copy_mode_active_highlight_fg = { AnsiColor = "Black" },
  copy_mode_inactive_highlight_bg = { Color = "#52ad70" },
  copy_mode_inactive_highlight_fg = { AnsiColor = "White" },

  quick_select_label_bg = { Color = "peru" },
  quick_select_label_fg = { Color = "#ffffff" },
  quick_select_match_bg = { AnsiColor = "Navy" },
  quick_select_match_fg = { Color = "#ffffff" },

  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = "#0b0022",

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = palette.base00,
      -- The color of the text for the tab
      fg_color = palette.base05,

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = "Bold",

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = "None",

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = palette.base01,
      fg_color = palette.base04,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
      intensity = "Half",
    },

    -- The color of the inactive tab bar edge/divider
    inactive_tab_edge = palette.base02,

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = palette.base02,
      fg_color = palette.base04,
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
      intensity = "Half",
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = palette.base01,
      fg_color = palette.base03,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = palette.base01,
      fg_color = palette.base04,
      italic = true,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}
