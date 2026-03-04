---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "fonts", desc = "List available fonts"},
  fmt(
    [[
      fc-list : {} | fzf
    ]],
    {
      c(1, { t("family style"), t("family style file"), t("family style file spacing") }),
    }
  )
))

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = ".desktops", desc = "List available .desktop files"},
  fmt(
    [[
      echo -e "$(find /run/current-system/sw/share/applications -name '*.desktop')\n$(find ~/.local/state/nix/profiles/home-manager/home-path/share/applications -name '*.desktop')" | fzf
    ]],
    {}
  )
))

----------------------------------------------------------------------------------------------------

return snippets
