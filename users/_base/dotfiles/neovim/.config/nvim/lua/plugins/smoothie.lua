return {
  {
    'psliwka/vim-smoothie',
    config = function()
      vim.keymap.set("n", toggle_key.."s", function()
        vim.g.smoothie_enabled = not vim.g.smoothie_enabled
      end, {})
    end
  },
}
