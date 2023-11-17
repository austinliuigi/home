return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      'nvim-treesitter/playground',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'JoosepAlviste/nvim-ts-context-commentstring',
      'windwp/nvim-ts-autotag',
      'mrjones2014/nvim-ts-rainbow',
    },
    config = function()
      local parsers = require("nvim-treesitter.parsers")
      local rainbow_filetypes = { "fennel", "commonlisp", "html", "xml" }

      require("nvim-treesitter.configs").setup({
        auto_install = true,
        ensure_installed = { "markdown", "norg", "org", "python", "vim", },
        sync_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["ia"] = "@parameter.inner",
              ["aa"] = "@parameter.outer",
              -- ["if"] = "@function.inner",
              -- ["af"] = "@function.outer",
            },
            selection_modes = {
              ['@parameter.inner'] = 'v', -- charwise
              ['@parameter.outer'] = 'v', -- charwise
              -- ['@function.inner'] = 'V', -- linewise
              -- ['@function.outer'] = 'V', -- linewise
              -- ['@class.outer'] = '<c-v>', -- blockwise
            },
            include_surrounding_whitespace = false,
          },
        },
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        },
        autotag = {
          enable = true,
        },
        -- rainbow = {
        --   enable = true,
        --   -- Enable only for lisp like languages
        --   disable = vim.tbl_filter(
        --     function(p)
        --       local disable = true
        --       for _, lang in pairs(rainbow_filetypes) do
        --         if p==lang then disable = false end
        --       end
        --       return disable
        --     end,
        --     parsers.available_parsers()
        --   )
        -- },
      })
    end
  }
}
