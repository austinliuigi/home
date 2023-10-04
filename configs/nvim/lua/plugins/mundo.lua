return {
  {
    'simnalamburt/vim-mundo',
    keys = {
      { "_", "<cmd>MundoToggle<CR>", mode = {"n"} }
    },
    cmd = "MundoToggle",
    config = function()
      vim.g.mundo_preview_bottom = 1  -- Force preview window to be below windows instead of below graph
      vim.g.mundo_mappings = {
        ['<nowait> <CR>'] = 'preview',
        ['<nowait> o'] = 'preview',
        ['<nowait> J'] = 'move_older_write',
        ['<nowait> K'] = 'move_newer_write',
        ['<nowait> gg'] = 'move_top',
        ['<nowait> G'] = 'move_bottom',
        ['<nowait> P'] = 'play_to',
        ['<nowait> d'] = 'diff',
        ['<nowait> i'] = 'toggle_inline',
        ['<nowait> /'] = 'search',
        ['<nowait> n'] = 'next_match',
        ['<nowait> N'] = 'previous_match',
        ['<nowait> p'] = 'diff_current_buffer',
        ['<nowait> r'] = 'rdiff',
        ['<nowait> ?'] = 'toggle_help',
        ['<nowait> q'] = 'quit',
        ['<nowait> <2-LeftMouse>'] = 'mouse_click',
        ['<nowait> j'] = 'move_older',
        ['<nowait> k'] = 'move_newer',
        ['<nowait> <Down>'] = 'move_older',
        ['<nowait> <Up>'] = 'move_newer'
      }
    end
  },
}
