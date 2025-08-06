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

return snippets
