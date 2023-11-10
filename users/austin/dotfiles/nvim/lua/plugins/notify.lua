return {
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")

      local term_bg = os.getenv('TERM') == 'xterm-kitty' and vim.fn.system("awk '$1 ~ /^background$/ {print $2}' ~/.config/kitty/current-theme.conf") or "#000000"
      require("notify").setup {
        background_colour = term_bg
      }

      vim.keymap.set("n", "<esc>", "<cmd>nohl<CR><cmd>echo ''<CR><cmd>lua require('notify').dismiss()<CR>", { remap = true })
    end
  },
}
