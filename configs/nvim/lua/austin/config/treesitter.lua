local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
  auto_install = true,
  ensure_installed = { "markdown", "norg", "org", "python", "vim", },
  sync_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = false,
  },
  -- rainbow = {
  --   enable = true,
  --   extended_mode = true,
  --   max_file_lines = nil,
  --   colors = {'#afd7d7', '#87af00', '#d7d75f', '#5f8787', '#d7af00', '#af5f5f'}
  -- }
}

-- vim.cmd('set foldexpr=nvim_treesitter#foldexpr()')
