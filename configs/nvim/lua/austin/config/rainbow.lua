local toggle_key = require("austin.keymaps").toggle_key

vim.g.rainbow_active = 0

vim.g.rainbow_conf = {
  ['guifgs'] = {'#afd7d7', '#d7d75f', '#d7af00', '#af5f5f'},
  ['ctermfgs'] = {'lightblue', 'lightyellow', 'lightcyan', 'lightred'},
  ['guis'] = {},
  ['cterms'] = {}
}

vim.keymap.set('n', toggle_key..'r', '<cmd>RainbowToggle<CR>', {noremap = true, silent = true})
