vim.g.registers_return_symbol = "↴" -- Symbol shown for newline characters
vim.g.registers_tab_symbol = "▸" -- Symbol shown for tab characters
vim.g.registers_space_symbol = " " -- Symbol shown for space characters

vim.g.registers_delay = 0 -- Milliseconds to wait before opening the popup window
vim.g.registers_register_key_sleep = 0 -- Seconds to wait before closing the window when a register key is pressed

vim.g.registers_show_empty_registers = 1 -- An additional line with the registers without content

vim.g.registers_trim_whitespace = 0 -- Don't show whitespace at the begin and end of the registers
vim.g.registers_hide_only_whitespace = 1 -- Don't show registers filled exclusively with whitespace

vim.g.registers_window_border = "rounded" -- Can be "none", "single", "double", "rounded", "solid", or "shadow"
vim.g.registers_window_min_height = 3 -- Minimum height of the window when there is the cursor at the bottom
vim.g.registers_window_max_width = 100 -- Maximum width of the window

vim.g.registers_normal_mode = 1 -- Open the window in normal mode
vim.g.registers_paste_in_normal_mode = 0 -- "0" - Default Neovim behavior, "1" Paste when selecting a register with the register key and `Return`, "2" - Paste when selecting a register only with `Return`
vim.g.registers_visual_mode = 0 -- Open the window in visual mode
vim.g.registers_insert_mode = 0 -- Open the window in insert mode
vim.g.registers_show = "*+\"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:" -- Which registers to show and in what order
vim.g.system_clip = 0 -- Transfer selected register to system clipboard
