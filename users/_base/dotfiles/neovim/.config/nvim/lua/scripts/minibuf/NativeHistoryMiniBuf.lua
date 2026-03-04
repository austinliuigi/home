local M = setmetatable(
  {},
  -- inherit from MiniBuf base class
  require("scripts.minibuf.MiniBuf")
)
M.__index = M

--- Sync history table to native history
--
function M:sync_history()
  local new_hist_entries = {}

  local i = 1
  local num_hist_entries = vim.fn.histnr(self.history_type)
  -- iterate through history entries in reverse
  while i <= num_hist_entries do
    local entry = vim.fn.histget(self.history_type, -i)

    -- if entries match then we already have the rest stored, early exit
    if entry == self.history[#self.history] then
      break
    end

    -- skip empty lines caused vim removing back-to-back duplicate entries
    if entry ~= "" then
      table.insert(new_hist_entries, entry)
    end

    i = i + 1
  end

  -- add each new entry to stored history
  for n = #new_hist_entries, 1, -1 do
    local entry = new_hist_entries[n]
    table.insert(self.history, entry)
  end
end

--- Update history after selection
--
---@param selection string
function M:update_history(selection)
  -- append selection to native history manually if it wasn't already added by vim
  if vim.fn.histget(self.history_type) ~= selection then
    vim.fn.histadd(self.history_type, selection)
  end

  self:sync_history()
end

return M
