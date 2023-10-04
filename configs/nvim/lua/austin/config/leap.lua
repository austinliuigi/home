-- Leap
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
  repeat_search = '<C-.>',
  next_phase_one_target = '<C-n>', -- go to next target in phase 1 (after pressing <char1>)
  next_target = '<C-n>', -- go to next target in phase 2 (after pressing <char2>)
  prev_target = '<C-p>', -- reverse last "next_phase_one_target or next target" jump
  next_group = '<Tab>',
  prev_group = '<S-Tab>',
  multi_accept = '',
  multi_revert = '',
}

-- Mappings
vim.keymap.set({'n'}, 's', '<Plug>(leap-forward-to)', { noremap = true })
vim.keymap.set({'n'}, 'S', '<Plug>(leap-backward-to)', { noremap = true })
vim.keymap.set({'x', 'o'}, 's', function() require('leap').leap({ offset = 0, inclusive_op = true }) end, { noremap = true })
vim.keymap.set({'x', 'o'}, 'S', function() require('leap').leap({ offset = 0, inclusive_op = true, backward = true }) end, { noremap = true })
vim.keymap.set({'x', 'o'}, 'x', function() require('leap').leap({ offset = -1, inclusive_op = true }) end, { noremap = true })
vim.keymap.set({'x', 'o'}, 'X', function() require('leap').leap({ offset = 1, inclusive_op = true, backward = true }) end, { noremap = true })

-- vim.keymap.set({'n', 'x'}, 's', function()
--   require("leap").leap({
--     target_windows = { vim.fn.win_getid() },
--     inclusive_op = true
--   })
-- end, { noremap = true })
--
-- vim.keymap.set({'o'}, 's', function()
--   local pre_leap_pos = vim.fn.getpos(".")
--   require("leap").leap({
--     target_windows = { vim.fn.win_getid() },
--     inclusive_op = true
--   })
--   local post_leap_pos = vim.fn.getpos(".")
--
--   -- If jumping behind original position
--   if (pre_leap_pos[2] > post_leap_pos[2]) or ((pre_leap_pos[2] == post_leap_pos[2]) and (pre_leap_pos[3] > post_leap_pos[3])) then
--     vim.cmd("normal! h")
--   end
-- end, { remap = false })
--
-- vim.keymap.set({'x'}, 'x', function()
--   local pre_leap_pos = vim.fn.getpos(".")
--   require("leap").leap({
--     target_windows = { vim.fn.win_getid() },
--     inclusive_op = true
--   })
--   local post_leap_pos = vim.fn.getpos(".")
--
--   -- If jumping behind original position
--   if (pre_leap_pos[2] > post_leap_pos[2]) or ((pre_leap_pos[2] == post_leap_pos[2]) and (pre_leap_pos[3] > post_leap_pos[3])) then
--     vim.cmd("normal! l")
--   else
--     vim.cmd("normal! h")
--   end
-- end, { remap = false })
--
-- vim.keymap.set({'o'}, 'x', function()
--   local pre_leap_pos = vim.fn.getpos(".")
--   require("leap").leap({
--     target_windows = { vim.fn.win_getid() },
--     inclusive_op = true
--   })
--   local post_leap_pos = vim.fn.getpos(".")
--
--   -- If jumping forward from original position
--   if (pre_leap_pos[2] > post_leap_pos[2]) or ((pre_leap_pos[2] == post_leap_pos[2]) and (pre_leap_pos[3] < post_leap_pos[3])) then
--     vim.cmd("normal! h")
--   end
-- end, { remap = false })
--
-- vim.keymap.set({'n', 'x', 'o'}, 'S', '<Plug>(leap-cross-window)', { noremap = true })



vim.api.nvim_create_augroup("LeapHighlights", {clear = true})
vim.api.nvim_create_autocmd({ "Colorscheme" }, {
  group   = "LeapHighlights",
  pattern = {'*'},
  callback = function()
    -- vim.api.nvim_set_hl(0, 'LeapLabelPrimary', { link = "Search" })
    vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = "Comment" })
  end,
})


-- Leap-spooky
require('leap-spooky').setup {
  affixes = {
    -- These will generate mappings for all native text objects, like:
    -- (ir|ar|iR|aR|im|am|iM|aM){obj}.
    -- Special line objects will also be added, by repeating the affixes.
    -- E.g. `yrr<leap>` and `ymm<leap>` will yank a line in the current
    -- window.
    -- You can also use 'rest' & 'move' as mnemonics.
    remote   = { window = 'r', cross_window = 'R' },
    magnetic = { window = 'm', cross_window = 'M' },
  },
  -- If this option is set to true, the yanked text will automatically be pasted
  -- at the cursor position if the unnamed register is in use.
  paste_on_remote_yank = false,
}
