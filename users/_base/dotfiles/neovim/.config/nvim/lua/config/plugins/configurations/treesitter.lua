local parsers = require("nvim-treesitter.parsers")

require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = {},
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
