---@diagnostic disable: undefined-global
-- stylua: ignore start
local snippets = {}


table.insert(snippets, s(
  {
    trig = "img",
    desc = "Input a centered image",
  },
  fmt(
    [[
      <div align="center">

      ![{}]({})
      *{}*

      </div>
      {}
    ]],
    {
      i(1, "caption"),
      i(2, "path/to/image"),
      rep(1),
      i(0)
    })
  )
)

return snippets
