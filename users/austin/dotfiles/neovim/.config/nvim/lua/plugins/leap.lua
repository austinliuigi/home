return {
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', '<Plug>(leap-forward-to)', mode = {'n'} },
      { 'S', '<Plug>(leap-backward-to)', mode = {'n'} },
      { 's', function() require('leap').leap({ offset = 0, inclusive_op = true }) end, mode = {'x'--[[ , 'o' ]]} },
      { 'S', function() require('leap').leap({ offset = 0, inclusive_op = true, backward = true }) end, mode = {'x'--[[ , 'o' ]]} },
      { 'x', function() require('leap').leap({ offset = -1, inclusive_op = true }) end, mode = {'x'--[[ , 'o' ]]} },
      { 'X', function() require('leap').leap({ offset = 1, inclusive_op = true, backward = true }) end, mode = {'x'--[[ , 'o' ]]} },
    },
    config = function()
      local leap = require("leap")
      leap.opts.max_phase_one_targets = nil
      leap.opts.highlight_unlabeled_phase_one_targets = false
      leap.opts.max_highlighted_traversal_targets = 10
      leap.opts.case_sensitive = false
      leap.opts.equivalence_classes = {
        '\r\n',
        '`~', '1!', '2@', '3#', '4$', '5%', '6^', '7&', '8*', '9(', '0)', '-_', '=+',
        '[{', ']}', '\\|', ';:', '\'"', ',<', '.>', '/?',
      }
      leap.opts.safe_labels = {}
      leap.opts.special_keys = {
        repeat_search = '<C-CR>',
        next_phase_one_target = '<C-n>', -- go to next target in phase 1 (after pressing <char1>)
        next_target = '<C-n>', -- go to next target in phase 2 (after pressing <char2>)
        prev_target = '<C-p>', -- reverse last "next_phase_one_target or next target" jump
        next_group = '<Tab>',
        prev_group = '<S-Tab>',
        multi_accept = '',
        multi_revert = '',
      }

      vim.api.nvim_create_augroup("LeapHighlights", {clear = true})
      vim.api.nvim_create_autocmd({ "Colorscheme" }, {
        group   = "LeapHighlights",
        pattern = {'*'},
        callback = function()
          -- vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { link = "Search" })
          vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = "Comment" })
        end,
      })
      vim.api.nvim_exec_autocmds("Colorscheme", {group = "LeapHighlights"})
    end
  },
  {
    'ggandor/leap-spooky.nvim',
    event = "VeryLazy",
    dependencies = {
      'ggandor/leap.nvim',
    },
    opts = {
      affixes = {
        remote   = { window = 'r', cross_window = 'R' },
        magnetic = { window = 'm', cross_window = 'M' },
      },
      paste_on_remote_yank = false,
    }
  },
}
