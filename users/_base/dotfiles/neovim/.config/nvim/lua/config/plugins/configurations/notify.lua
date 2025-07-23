-- :h notify.config
require("notify").setup({
  top_down = false,
  level = vim.log.levels.TRACE,
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
  on_open = function(win, record)
    --------------------------------------------------------------------------------------------
    -- Show title in window border
    --   - https://github.com/rcarriga/nvim-notify/issues/200
    --------------------------------------------------------------------------------------------
    -- vim.print("on_open:", record)
    local win_title = " " .. record.icon .. " "
    local win_title_hl = string.format("%s%s%s", "Notify", record.level, "Title")
    local title = record.title[1]
    if type(title) == "string" and #title > 0 then
      win_title = win_title .. title .. " "
    end
    vim.api.nvim_win_set_config(win, { title = { { win_title, win_title_hl } }, title_pos = "left" })
  end,
  render = function(bufnr, notif, highlights)
    --------------------------------------------------------------------------------------------
    -- Show only message body in window
    --   - see the following for reference: https://github.com/rcarriga/nvim-notify/blob/master/lua/notify/render/compact.lua
    --------------------------------------------------------------------------------------------
    -- vim.print("render:", notif)
    local message = {
      notif.message[1],
      unpack(notif.message, 2),
    }

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)
  end,
})

vim.keymap.set("n", "<esc>", "<cmd>nohl<CR><cmd>echo ''<CR><cmd>lua require('notify').dismiss()<CR>", { remap = true })

vim.notify = require("notify")
