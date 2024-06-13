-- this module contains a number of default definitions
local rainbow_delimiters = require("rainbow-delimiters")

vim.g.rainbow_delimiters = {
  -- :h rb-delimiters-strategy
  strategy = {
    [""] = rainbow_delimiters.strategy["global"], -- :h rb-delimiters.strategy.global
    vim = rainbow_delimiters.strategy["local"], -- :h rb-delimiters.strategy.local
  },
  -- :h rb-delimiters-query
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  -- :h treesitter-highlight-priority
  priority = {
    [""] = 110,
  },
  -- :h rb-delimiters-colors
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterOrange",
    "RainbowDelimiterYellow",
    "RainbowDelimiterGreen",
    "RainbowDelimiterCyan",
    "RainbowDelimiterBlue",
    "RainbowDelimiterViolet",
  },
}
