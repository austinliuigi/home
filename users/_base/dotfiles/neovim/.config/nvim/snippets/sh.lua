---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

table.insert(snippets, s("shebang",
  fmt([[
    #!{}
  ]], {
    c(1, { t("/usr/bin/env bash"), t("/bin/bash"), t("") }),
  })
))

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "pgrep", desc = "Grep for a process"},
  fmt(
    [[
      ps -e -o pid,cmd | grep '{}' # {}
    ]],
    {
      f(function(argnode_texts)
        return string.format("[%s]%s", argnode_texts[1][1]:sub(1, 1), argnode_texts[1][1]:sub(2))
      end, {1}, {}),
      i(1, "pattern")
    }
  )
))

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

return snippets
