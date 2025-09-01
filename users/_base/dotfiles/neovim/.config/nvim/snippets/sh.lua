---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {
  s(
    "shebang",
    fmt(
      [[
    #!{}
  ]],
      {
        c(1, { t("/usr/bin/env bash"), t("/bin/bash"), t("") }),
      }
    )
  ),
}

table.insert(snippets, s("pgrep",
  fmt([[
    ps -e -o pid,sid,stat,cmd | grep '{}'
  ]], {
    i(0, "<pattern>")
  }), {}
))

return snippets
