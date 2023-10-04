return {
  {
    'nvim-telescope/telescope.nvim',
    version = '0.1.*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    keys = {
      { '<leader>f', '<cmd>lua require("telescope.builtin").find_files({hidden = true, follow=true})<CR>' },
      -- { '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep({})<CR>' },
      -- { '<leader>f/', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find({})<CR>' },
      { '<C-/>', '<cmd>lua require("telescope.builtin").builtin()<CR>' },
    },
    config = function()
      local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments
      table.insert(vimgrep_arguments, "--hidden")
      table.insert(vimgrep_arguments, "--glob")
      table.insert(vimgrep_arguments, "!**/.git/*")

      require('telescope').setup({
        defaults = {
          prompt_prefix = 'ᛋ ',
          selection_caret = '❯ ',
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            n = {
              ['q'] = 'close',
            },
            i = {
              ['<C-h>'] = 'file_split',
              ['<C-c>'] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
              ['<C-x>'] = false,
              ['<C-q>'] = false,
            }
          }
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--glob", "!**/node_modules/*" }
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
      })

      require('telescope').load_extension('fzf')

      vim.api.nvim_create_augroup("TelescopeHighlights", {clear = true})
      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        group   = "TelescopeHighlights",
        pattern = {'*'},
        callback = function()
          -- vim.api.nvim_set_hl(0, "TelescopeMatching", {underline = true})
          vim.api.nvim_set_hl(0, "TelescopeMatching", {link = "Type"})
        end,
      })
      vim.api.nvim_exec_autocmds("ColorScheme", {group = "TelescopeHighlights"})
    end
  }
}
