---@diagnostic disable: undefined-global
-- stylua: ignore start

local snippets = {}

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

return snippets
