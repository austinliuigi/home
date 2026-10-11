---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

----------------------------------------------------------------------------------------------------

table.insert(snippets, s({trig = "tcpdump", desc = "Capture packets on a given interface"},
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

return snippets
