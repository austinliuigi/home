local M = setmetatable(
  {},
  -- inherit from MiniBuf base class
  require("scripts.minibuf.MiniBuf")
)
M.__index = M

function M:update_history(selection)
  local disk_lines = vim.fn.readfile(self.history)

  -- append selection to history file on disk
  if selection ~= disk_lines[#disk_lines] then
    vim.fn.writefile({ selection }, self.history, "a")
  end
end

return M
