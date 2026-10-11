---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "git-log-filterfile", desc = "List only commits that changed a specific file"},
  fmt(
    [[
      git log -- {}
    ]],
    {
      i(0, "path/to/file"),
    }
  )
))

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "git-log-grepmsg", desc = "List only commits that included code changes matching the given pattern"},
  fmt(
    [[
      git log -S '{}' --oneline
    ]],
    {
      i(0, "regex"),
    }
  )
))

----------------------------------------------------------------------------------------------------

return snippets
