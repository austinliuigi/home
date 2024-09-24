return {
  "vim-matchup",
  event = "DeferredUIEnter",
  -- FIX: this doesn't run on a file opened through the command line, e.g. `test.lua` in `nvim test.lua`
}
