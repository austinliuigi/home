local fterm = require("FTerm")

fterm.setup({
    ---Filetype of the terminal buffer
    ---@type string
    ft = 'FTerm',

    ---Command to run inside the terminal
    ---NOTE: if given string[], it will skip the shell and directly executes the command
    ---@type fun():(string|string[])|string|string[]
    cmd = os.getenv('SHELL'),

    ---Neovim's native window border. See `:h nvim_open_win` for more configuration options.
    border = 'single',

    ---Close the terminal as soon as shell/command exits.
    ---Disabling this will mimic the native terminal behaviour.
    ---@type boolean
    auto_close = true,

    ---Highlight group for the terminal. See `:h winhl`
    ---@type string
    hl = 'Normal',

    ---Transparency of the floating window. See `:h winblend`
    ---@type integer
    blend = 0,

    ---Object containing the terminal window dimensions.
    ---The value for each field should be between `0` and `1`
    ---@type table<string,number>
    dimensions = {
        height = 0.8, -- Height of the terminal window
        width = 0.8, -- Width of the terminal window
        x = 0.5, -- X axis of the terminal window
        y = 0.5, -- Y axis of the terminal window
    },

    ---Callback invoked when the terminal exits.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_exit = nil,

    ---Callback invoked when the terminal emits stdout data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stdout = nil,

    ---Callback invoked when the terminal emits stderr data.
    ---See `:h jobstart-options`
    ---@type fun()|nil
    on_stderr = nil,
})

vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })     -- open the terminal
vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })   -- close the terminal but preserve session
vim.api.nvim_create_user_command('FTermExit', require('FTerm').exit, { bang = true })     -- close and remove terminal session
vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true }) -- toggle terminal (open/close)

vim.keymap.set('n', '<C-CR>', function()
  require("FTerm").open()
end)


local lazygit = fterm:new({
    ft = 'fterm_gitui', -- You can also override the default filetype, if you want
    cmd = "lazygit",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})
-- vim.keymap.set('n', '<M-g>', function()
--     lazygit:toggle()
-- end)
