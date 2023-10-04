local iron = require("iron.core")
local view = require("iron.view")
local toggle = require("austin.keymaps").toggle_key

iron.setup{
  config = {
    -- Highlights the last sent block with bold
    highlight_last = "IronLastSent",

    -- Toggling behavior is on by default.
    -- Other options are: `single` and `focus`
    visibility = require("iron.visibility").toggle,

    -- Scope of the repl
    -- By default it is one for the same `pwd`
    -- Other options are `tab_based` and `singleton`
    scope = require("iron.scope").path_based,

    -- Whether the repl buffer is a "throwaway" buffer or not
    scratch_repl = false,

    -- Automatically closes the repl window on process end
    close_window_on_exit = true,

    repl_definition = {
      -- forcing a default
      python = require("iron.fts.python").python
      -- new, custom repl
      --[[ lua = {
        command = {"my-lua-repl", "-arg"}
      } ]]
    },

    -- Whether iron should map the `<plug>(..)` mappings
    should_map_plug = false,

    -- Window settings of repl
    repl_open_cmd = view.split.vertical.botright(0.4),

    -- If the repl buffer is listed
    buflisted = false,
  },

  -- All the keymaps are set individually
  keymaps = {
    -- send_motion = "<space>sc",
    visual_send = "<leader><right>",
    -- send_file = "<space>sf",
    -- send_line = "<space>sl",
    -- send_mark = "<space>sm",
    -- mark_motion = "<space>mc",
    -- mark_visual = "<space>mc",
    -- remove_mark = "<space>md",
    -- cr = "<space>s<cr>",
    -- interrupt = "<space>s<space>",
    -- exit = "<space>sq",
    -- clear = "<space>cl",
  },

  -- If the highlight is on, you can change how it looks
  -- For the available options, check nvim_set_hl
  highlight = {
    italic = true
  }
}

vim.keymap.set("n", "<leader><CR>", "<cmd>IronRepl<CR><Esc>", { remap = false, silent = true })
vim.keymap.set("n", toggle.."<CR>", "<cmd>IronRepl<CR><Esc>", { remap = false, silent = true })
