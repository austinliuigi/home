---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

table.insert(snippets, s(
  {
    trig = "note",
    desc = "Boilerplate for notes"
  },
  fmt(
    [[
      #import "@local/notes:1.0.0"
      #show: notes.style

      = {}

      #outline(title: none)
    ]],
    {
      i(0)
    }
  )
))

return snippets
