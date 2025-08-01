require("nvim-treesitter.configs").setup({
  auto_install = true,
  ensure_installed = { "lua", "markdown", "markdown_inline", "yaml" },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})
