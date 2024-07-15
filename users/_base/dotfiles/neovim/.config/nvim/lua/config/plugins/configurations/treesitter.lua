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
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        ["if"] = "@function.inner",
        ["af"] = "@function.outer",
        ["ic"] = "@class.inner",
        ["ac"] = "@class.outer",
      },
      selection_modes = {
        ["@parameter.inner"] = "v", -- charwise
        ["@parameter.outer"] = "v", -- charwise
        ["@function.inner"] = "V", -- linewise
        ["@function.outer"] = "V", -- linewise
        ["@class.inner"] = "V", -- linewise
        ["@class.outer"] = "V", -- linewise
      },
      include_surrounding_whitespace = false, -- include whitespace in "around" textobjects
    },
  },
})
