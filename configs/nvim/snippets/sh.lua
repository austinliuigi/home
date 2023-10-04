local snippets = {
  s("shebang", fmt([[
    #!{}
  ]], {
    c(1, { t("/bin/bash"), t("/usr/bin/env bash"), t("") }),
  })),
}

return snippets
