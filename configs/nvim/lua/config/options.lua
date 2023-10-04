-- General {{{
-- Make system clipboard the default
vim.opt.clipboard:append('unnamedplus')

-- Allow use of mouse in all modes
vim.opt.mouse = 'a'

-- Set cursor shapes for each mode
--[[
vim.opt.guicursor = {
  n-v-c = 'block',
  i-ci-ce = 'ver25',
  r-cr = 'hor20',
  o = 'hor50',
  a = 'blinkwait700-blinkoff400-blinkon250-Cursor/lCursor',
  sm = 'block-blinkwait175-blinkoff150-blinkon175'
}
--]]
vim.cmd([[
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
  \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
  \,sm:block-blinkwait175-blinkoff150-blinkon175
]])

-- Highlight the line that the cursor is on
vim.api.nvim_create_augroup("Cursorline", {clear = true})
vim.api.nvim_create_autocmd({ "VimEnter", "BufWinEnter", "WinEnter" }, {
  group   = "Cursorline",
  pattern = {'*'},
  callback = function()
    vim.wo.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave" }, {
  group   = "Cursorline",
  pattern = {'*'},
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Show line numbers and make them relative to current line
vim.opt.number = true
vim.opt.relativenumber = false

-- Set vertical split window to appear on the right by default
vim.opt.splitright = true

-- Don't show cmdline
-- vim.opt.cmdheight = 0

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildoptions = {'pum'}
vim.cmd('set wildcharm=<Tab>')

-- Number of lines/columns to keep around the cursor
vim.opt.scrolloff = 0
vim.opt.sidescrolloff = 999

-- Number of lines to scroll at a time horizontally
vim.opt.sidescroll = 1

-- Don't show mode on cmdline
vim.opt.showmode = false

-- Show matching symmetric delimiter when typing
vim.opt.showmatch = true

-- Make tilde act like an operator
vim.opt.tildeop = true

-- Set messages that show in command line
vim.opt.shortmess:append('c')
vim.opt.shortmess:remove('S')

-- Set events that don't ring the bell
vim.opt.belloff = {'esc', 'cursor', 'error'}

-- Turn on signcolumn
vim.opt.signcolumn = "yes:1"

-- Global statusline
vim.opt.laststatus = 3

-- Default .tex filetype
vim.g.tex_flavor = "latex"

-- Set format options
vim.api.nvim_create_augroup('FormatOptions', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
  command = 'set formatoptions=qnjp',
  group = 'FormatOptions',
  pattern = {'*'}
})

-- Set relative number line for help windows
vim.api.nvim_create_augroup('HelpWindowNumLine', {clear = true})
vim.api.nvim_create_autocmd('BufWinEnter', {
  command = 'if &buftype == "help" | setlocal relativenumber | endif',
  group = 'HelpWindowNumLine',
  pattern = {'*'},
  desc = 'Set relative number line for help windows'
})
-- }}}
-- Colors {{{
-- Use GUI colors in terminal, Note: must come before setting colorscheme
vim.opt.termguicolors = true

-- Highlight TODO everywhere (not just in comments) for text and markdown files
vim.api.nvim_create_augroup('Todo', {clear = true})
vim.api.nvim_create_autocmd('Syntax', {
  command = 'syn keyword myTodo TODO XXX containedin=ALL | hi! link myTodo TODO',
  group = 'Todo',
  pattern = {'*.txt', '*.md'},
  desc = "Highlight TODO everywhere (not just in comments) for text and markdown files"
})

-- Highlight yanked text
vim.api.nvim_create_augroup('HighlightYank', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
  group = 'HighlightYank',
  pattern = {'*'},
  callback = function()
    vim.highlight.on_yank{higroup="IncSearch", timeout=700}
  end
})

-- }}}
-- Whitespace {{{
-- Default indent settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

-- Indent to previous lines indentation
vim.opt.autoindent = true

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = {tab = '▸ ',eol = '↴', precedes = '‹', extends = '›'}

-- Set modes where conceal chars can be hidden on cursor line
vim.opt.concealcursor = ''

-- Set conceal level
vim.o.conceallevel = 2

-- Make wrapped lines have same indentation as original line
vim.opt.breakindent = true

-- Wrap only on "break" characters (not in the middle of words)
vim.opt.linebreak = true

-- Set string to show in beginning of wrapped lines
vim.opt.showbreak = '↪'
-- }}}
-- Searching {{{
-- Search highlighting
vim.opt.hlsearch = true

-- Search as you type
vim.opt.incsearch = true

-- Case insensitive searching unless uppercase character is typed
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- }}}
-- Folding {{{
-- Define folding using foldexpr
vim.opt.foldmethod = 'expr'

-- Set string that closed folds show
vim.cmd([[
  function! MyFoldText()
      let num_foldlevel_chars = (v:foldlevel - 1) * 2
      " let foldlevel_indicator = num_foldlevel_chars ? '╰' . repeat('─', num_foldlevel_chars-3) . ' ' : ''
      let foldlevel_indicator = repeat(' ', num_foldlevel_chars)
      let line = getline(v:foldstart)
      let fold_title = substitute(line, '^\s\+\|"\ *\|//\|/\*\|\*/\|\ *{\+\d\=', '', 'g') . ' '
      let num_of_lines = v:foldend - v:foldstart
      let fold_linecount = '(' . num_of_lines . ' Lines)'
      let last_linenr_digits = strchars(line('$'))
      let padding_length = winwidth(0) - strchars(foldlevel_indicator) - strchars(fold_title) - strchars(fold_linecount) - &numberwidth - ((last_linenr_digits >= &numberwidth) ? (last_linenr_digits - &numberwidth + 1) : 0) - 2
      " extra 2 for the signcolumn
      return foldlevel_indicator . fold_title . repeat('·', padding_length) . fold_linecount
  endfunction
]])
vim.opt.foldtext = 'MyFoldText()'
vim.opt.fillchars:append({fold = ' '})
-- }}}
-- Diff {{{
-- vim.opt.fillchars += diff:╱
vim.opt.fillchars:append({diff = '╱'})
-- vim.opt.diffopt += algorithm:histogram
vim.opt.diffopt:append('algorithm:histogram')
-- }}}
-- Terminal {{{
-- }}}
-- Timeout {{{
-- Wait indefinitely for a mapping, but a set time for key-codes
vim.opt.timeout = false
vim.opt.ttimeout = true

-- Don't wait for keycodes (instantly assume esc, etc.)
vim.opt.ttimeoutlen = 0
-- }}}
-- Backup {{{
vim.cmd([[
  let &directory = expand('~/.local/share/nvim/.nvimdata/Swap//')
  if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
  
  set backup
  let &backupdir = expand('~/.local/share/nvim/.nvimdata/Backup//')
  if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif

  set undofile
  let &undodir = expand('~/.local/share/nvim/.nvimdata/Undo//')
  if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
]])
-- }}}
-- vim: foldmethod=marker
