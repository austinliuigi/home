local M = setmetatable(
  {},
  -- inherit from NativeHistoryMiniBuf base class
  require("scripts.minibuf.NativeHistoryMiniBuf")
)
M.__index = M

M.history_type = "cmd"
M.history = {}

--- Selection handler
--
---@param selection string
function M:handle_selection(selection)
  -- execute command in parent
  vim.api.nvim_win_call(self.parent_winid, function()
    local ok, res = pcall(vim.cmd, selection)
    if not ok then
      print(res)
    end
  end)
end

--- Create instance
--
function M:create()
  M:sync_history()

  local instance = require("scripts.minibuf.MiniBuf"):create(M.history)
  instance = setmetatable(instance, M)

  -- vim.defer_fn(function()
  --   vim.bo[instance.bufnr].filetype = "vim"
  -- end, 500)
  vim.bo[instance.bufnr].filetype = "vim"
  vim.wo[instance.winid].winbar = "%#Bold#   Command"
  vim.wo[instance.winid].statuscolumn = "%#String#  :"
end

return M
