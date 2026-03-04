local M = setmetatable(
  {},
  -- inherit from NativeHistoryMiniBuf base class
  require("scripts.minibuf.NativeHistoryMiniBuf")
)
M.__index = M

M.history_type = "search"
M.history = {}

--- Selection handler
--
---@param selection string
function M:handle_selection(selection)
  -- search command in parent
  -- we don't use keeppatterns because it doesn't save it as the last search to use with n/N
  vim.api.nvim_win_call(self.parent_winid, function()
    vim.cmd("normal! " .. self.key .. selection .. vim.api.nvim_replace_termcodes("<CR>", true, true, true))
  end)
end

--- Create instance
--
function M:create(forwards)
  M:sync_history()

  local instance = require("scripts.minibuf.MiniBuf"):create(M.history)
  instance = setmetatable(instance, M)
  instance.key = forwards and "/" or "?"

  vim.wo[instance.winid].winbar = "%#Bold#   Search"
  vim.wo[instance.winid].statuscolumn = "%#String#  " .. instance.key
end

return M
