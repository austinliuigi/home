---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

----------------------------------------------------------------------------------------------------

table.insert(snippets, s("shebang",
  fmt([[
    #!{}
  ]], {
    c(1, { t("/usr/bin/env bash"), t("/bin/bash"), t("") }),
  })
))

----------------------------------------------------------------------------------------------------

return snippets
