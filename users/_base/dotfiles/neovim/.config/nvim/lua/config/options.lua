-- CLIPBOARD {{{
--------------------------------------------------
vim.opt.clipboard:append("unnamedplus") -- set default clipboard

-- Use osc52 clipboard in ssh sessions
if vim.env.SSH_CLIENT then
  vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
      -- HACK: wait after vim.g.termfeatures.osc52 is potentially set by the autocmd in https://github.com/neovim/neovim/blob/release-0.11/runtime/plugin/osc52.lua
      vim.defer_fn(function()
        -- vim.print(vim.g.termfeatures)
        if vim.g.termfeatures.osc52 then
          vim.notify("Using OSC52 as clipboard provider", vim.log.levels.INFO, { title = "Clipboard" })
          vim.g.clipboard = "osc52"
          -- HACK: manually trigger clipboard provider to re-execute, otherwise the manually set vim.g.clipboard won't take effect
          -- - to reload, we re-source autoload/provider/clipboard.vim, because eval_has_provider() is dependent on the value of vim.g.loaded_clipboard_provider, which is set only when the script is executed
          --   - https://github.com/neovim/neovim/blob/release-0.11/runtime/autoload/provider/clipboard.vim#L356
          --   - https://github.com/neovim/neovim/blob/release-0.11/src/nvim/eval.c#L8590
          vim.cmd("unlet g:loaded_clipboard_provider")
          vim.cmd("runtime autoload/provider/clipboard.vim")
        end
      end, 500)
    end,
  })
end
-- }}}

-- CURSOR {{{
--------------------------------------------------
vim.opt.mouse = "a" -- modes to enable mouse in

vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor/lCursor",
  "i-ci-ve:ver25-Cursor/lCursor",
  "r-cr:hor20",
  "o:hor50-Cursor/lCursor",
  "t:block-blinkon500-blinkoff500-TermCursor",
  "a:blinkwait700-blinkoff400-blinkon250",
  "sm:block-blinkwait175-blinkoff150-blinkon175",
}, ",")
-- }}}

-- STATUS BARS {{{
--------------------------------------------------
vim.opt.number = true -- show line numbers
vim.opt.relativenumber = false -- make line numbers relative to current position
vim.opt.signcolumn = "auto:1" -- set signcolumn visibility and width
vim.opt.foldcolumn = "auto:1"

vim.opt.laststatus = 3 -- set statusline visibility
vim.opt.showtabline = 2 -- set tabline visibility
-- }}}

-- SCROLL {{{
--------------------------------------------------
vim.opt.scrolloff = 0 -- number of lines to keep around the cursor
vim.opt.sidescrolloff = 999 -- number of columns to keep around the cursor
vim.opt.sidescroll = 1 -- number of lines to scroll at a time horizontally
vim.opt.smoothscroll = true -- scroll by number of screen lines rather than text lines (matters when wrap is set)
-- }}}

-- CMDLINE {{{
--------------------------------------------------
vim.opt.cmdheight = 1 -- height of command line

vim.opt.showmode = false -- show mode on cmdline

-- Messages that show in command line
vim.opt.shortmess:append("c")
vim.opt.shortmess:remove("S")

-- Command-line completion
vim.opt.wildmenu = true
vim.opt.wildoptions = { "pum" }
vim.cmd("set wildcharm=<Tab>")
-- }}}

-- SEARCH {{{
--------------------------------------------------
vim.opt.hlsearch = true -- turn on search highlighting
vim.opt.incsearch = true -- search as you type

vim.opt.ignorecase = true -- make searching case insesitive
vim.opt.smartcase = true -- if ignorecase is on, make search case sensitive if it contains uppercase characters
-- }}}

-- WHITESPACE {{{
--------------------------------------------------
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.shiftwidth = 4 -- amount of whitespace to use for `>`, `<`, and 'cindent'
vim.opt.smarttab = true -- use shiftwidth for amount of whitespace <Tab>/<BS> insert/delete in the *beginning* of lines
vim.opt.softtabstop = 0 -- the number of cells between soft tab stops
vim.opt.tabstop = vim.o.shiftwidth -- the number of cells between tab stops

vim.opt.autoindent = true -- copy indent from current line when creating a new line via `I_<CR>`, `o`, or `O`
vim.opt.smartindent = false -- like autoindent, but recognizes some C syntax to increase or decrease automatic indentation in some cases
vim.opt.cindent = false -- enable automatic C program indenting; more configurable than the smartindent
vim.opt.indentexpr = "" -- expression that computes the indent of each line

vim.opt.list = true -- show whitespace characters
vim.opt.listchars = { tab = "▸-", eol = "↴", precedes = "‹", extends = "›" } -- map whitespace characters to on-screen representation

vim.opt.concealcursor = "" -- set modes where conceal chars can be hidden on cursor line
vim.o.conceallevel = 2 -- set conceal level

vim.o.wrap = false -- wrap lines longer than window width
vim.opt.linebreak = true -- wrap only after certain "break" characters set in 'breakat'
vim.opt.breakat = " 	!@*-+;:,./?" -- characters that can precede a virtual line break when `'wrap'` and `'linebreak'` are on
vim.opt.breakindent = true -- make wrapped lines have same indentation as original line
vim.opt.breakindentopt = "list:-1" -- options to control alter the amount of `'breakindent'`
vim.opt.showbreak = "" -- set string to show in beginning of wrapped lines, e.g. "↪"
vim.opt.textwidth = 0 -- insert a physical linebreak when typing in insert mode passes 'textwidth' columns.

-- override formatoptions from any builtin filetype plugins
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt.formatoptions = "qnjp"
  end,
})
-- }}}

-- FOLDING {{{
--------------------------------------------------
vim.opt.foldmethod = "expr" -- method used to compute folds
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmarker = "{{{,}}}" -- strat and end marker to use when 'foldmethod' is "marker"
vim.opt.foldtext = "" -- expression used to evaluate the text displayed for a closed fold
vim.opt.fillchars:append({ fold = "·", foldopen = "", foldclose = "", foldsep = "│" }) -- "╰"
vim.opt.foldlevelstart = 99 -- initial value of 'foldlevel' when opening a new buffer

vim.api.nvim_create_user_command("TSFoldRefresh", function()
  -- HACK: Manually refresh treesitter folds
  --   - https://github.com/neovim/neovim/blob/release-0.11/runtime/lua/vim/treesitter/_fold.lua#L424-L442
  vim.api.nvim_exec_autocmds("OptionSet", { pattern = "foldnestmax" })
end, { nargs = 0 })

-- function _foldtext()
--   local line = vim.fn.getline(vim.v.foldstart)
-- end
-- vim.opt.foldtext = "v:lua._foldtext()"
-- }}}

-- KEYBINDS {{{
--------------------------------------------------
vim.opt.timeout = false -- whether to wait for when a mapping
vim.opt.ttimeout = true -- whether to wait for a keycode sequence
vim.opt.ttimeoutlen = 0 -- how long to wait for a keycode sequence when 'ttimeout' is true
-- }}}

-- DIFF {{{
--------------------------------------------------
vim.opt.fillchars:append({ diff = "╱" })
vim.opt.diffopt:append("algorithm:histogram")
-- }}}

-- BACKUP {{{
--------------------------------------------------
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

-- MISC {{{
--------------------------------------------------
vim.opt.termguicolors = true -- use 24-bit colors in compatible terminal; NOTE: must come before setting colorscheme
vim.opt.splitbelow = true -- new split windows are created below the current by default
vim.opt.splitright = true -- new vsplit windows are created below the current by default
vim.opt.splitkeep = "screen" -- how to current buffer when a split is opened
vim.opt.showmatch = true -- show matching symmetric delimiter when typing
vim.opt.tildeop = true -- make tilde act like an operator
vim.opt.belloff = { "esc", "cursor", "error" } -- set events that don't ring the bell
vim.g.tex_flavor = "latex" -- default .tex format; "plain"|"context"|"latex"
--- }}}

-- vim: foldmethod=marker
