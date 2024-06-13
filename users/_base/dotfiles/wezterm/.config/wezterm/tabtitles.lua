local wezterm = require("wezterm")

local function basename(s)
  s = s:gsub("[\\/]$", "")
  return s:gsub("(.*[/\\])(.*)", "%2")
end

local function tab_title(tab)
  local title = tab.tab_title
  if title and #title > 0 then
    return "󰓹  " .. title
  end

  local pane = tab.active_pane
  if pane.current_working_dir == nil then -- e.g. debug overlay
    return ""
  end

  local cwd = basename(pane.current_working_dir.file_path)
  local proc = basename(pane.foreground_process_name)

  return "  " .. cwd
  -- return "  " .. proc
  -- return "[   " .. cwd .. "      " .. proc .. " ]"
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)

  return {
    { Text = title },
  }
end)
