local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
  defaults = {
    prompt_prefix = 'ᛋ ',
    selection_caret = '❯ ',
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      n = {
        ['q'] = 'close',
        ['<C-w><C-l>'] = require('telescope.actions').select_vertical
      }
    }
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}

require('telescope').load_extension('fzf')
