local M = setmetatable(
  {},
  -- inherit from FileHistoryMiniBuf base class
  require("scripts.minibuf.FileHistoryMiniBuf")
)
M.__index = M

M.history = vim.fn.stdpath("cache") .. "/.execute_history"

--- Selection handler
--
---@param selection string
function M:handle_selection(selection)
  -- set makeprg in parent buffer
  vim.bo[self.parent_bufnr].makeprg = selection:gsub("|", "\\|")

  -- run :make in parent buffer
  vim.api.nvim_win_call(self.parent_winid, function()
    vim.cmd("make")
  end)
end

--- Create instance
--
function M:create()
  local instance = require("scripts.minibuf.MiniBuf"):create(M.history)
  instance = setmetatable(instance, M)

  vim.bo[instance.bufnr].filetype = vim.fs.basename(vim.o.shell)
  vim.wo[instance.winid].winbar = "%#Bold#   Execute"
  vim.wo[instance.winid].statuscolumn = "%#String#  $"
end

return M
