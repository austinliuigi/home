vim.keymap.set('n', '<Plug>(slash-after)', '"zz"..slash#blink(3, 65)', {noremap = true, expr = true})

vim.api.nvim_create_augroup("SlashSelectModeUnmaps", {clear = true})
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
  group   = "SlashSelectModeUnmaps",
  pattern = {'*:s'},
  callback = function()
    local slash_maps = { "n", "N", "gd", "gD", "g*", "g#", "*", "#", }
    for _, v in ipairs(slash_maps) do
      vim.cmd("sunmap " .. v)
    end
  end,
  once = true,
})
