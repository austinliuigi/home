vim.g.committia_open_only_vim_starting = 0 -- (default: 1)
-- If the value is 0, committia.vim always attempts to open committia's buffer when COMMIT_EDITMSG buffer is opened. If you use vim-fugitive, I recommend to set this value to 1.

vim.g.committia_use_singlecolumn = 'fallback' -- (default: 'fallback')
-- If the value is 'always', committia.vim always employs single column mode.

vim.g.committia_min_window_width = 160 -- (default: 160)
-- If the width of window is narrower than the value, committia.vim employs single column mode.

vim.g.committia_status_window_opencmd = 'belowright split' -- (default: 'belowright split')
-- Vim command which opens a status window in multi-columns mode.

vim.g.committia_diff_window_opencmd = 'botright vsplit' -- (default: 'botright vsplit')
-- Vim command which opens a diff window in multi-columns mode.

vim.g.committia_singlecolumn_diff_window_opencmd = 'belowright split' --(default: 'belowright split')
-- Vim command which opens a diff window in single-column mode.

vim.g.committia_edit_window_width = 80 -- (default: 80)
-- If committia.vim is in multi-columns mode, specifies the width of the edit window.

vim.g.committia_status_window_min_height = 0 -- (default: 0)
-- Minimum height of a status window.
