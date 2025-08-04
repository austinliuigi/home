local todo_dir = vim.fn.expand("~") .. "/todo"
local calendar_dir = todo_dir .. "/calendar"

--====================================================================================================
-- Handlers
--====================================================================================================

-- If current buffer is in calendar, start relative to that day, otherwise start relative to current day
local function get_start_time()
  local _, _, buf_year, buf_month, buf_day =
    string.find(vim.api.nvim_buf_get_name(0), calendar_dir .. "/(%d%d%d%d)/(%d%d)/(%d%d).norg")
  return (buf_year == nil) and os.time() or os.time({ year = buf_year, month = buf_month, day = buf_day })
end

------------------------------------------------------------------------------------------------------
-- Absolute days, months, years
------------------------------------------------------------------------------------------------------

---@param spec string -- Expected format: <N>d (e.g. 21d)
---@return string? computed_date
local function handle_absolute_day(spec)
  local _, _, day = string.find(spec, "^(%d+)d$")
  if day == nil then
    return nil
  end

  local computed_date = os.date("%Y/%m/" .. string.format("%02d", day), get_start_time())
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "Todo" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

---@param spec string -- Expected format: <N>m (e.g. 8m)
---@return string? computed_date
local function handle_absolute_month(spec)
  local _, _, month = string.find(spec, "^(%d+)m$")
  if month == nil then
    return nil
  end

  local computed_date = os.date("%Y/" .. string.format("%02d", month) .. "/%d", get_start_time())
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "Todo" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

---@param spec string -- Expected format: <N>y (e.g. 2020y)
---@return string? computed_date
local function handle_absolute_year(spec)
  local _, _, year = string.find(spec, "^(%d+)y$")
  if year == nil then
    return nil
  end

  local computed_date = os.date(string.format("%04d", year) .. "/%m/%d", get_start_time())
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "Todo" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

------------------------------------------------------------------------------------------------------
-- Relative days, months, years
------------------------------------------------------------------------------------------------------

---@param spec string -- Expected format: (+|-)<N>d (e.g. +21d)
---@return string? computed_date
local function handle_relative_day(spec)
  local _, _, direction, n_days = string.find(spec, "^([+-])(%d+)d$")
  if direction == nil then
    return nil
  end

  local start_time = get_start_time()
  local computed_time = (direction == "+") and (start_time + (60 * 60 * 24 * n_days))
    or (start_time - (60 * 60 * 24 * n_days))

  local computed_date = os.date("%Y/%m/%d", computed_time)
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "Todo" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

---@param spec string -- Expected format: (+|-)<N>m (e.g. +8m)
---@return string? computed_date
local function handle_relative_month(spec)
  local _, _, direction, n_months = string.find(spec, "^([+-])(%d+)m$")
  if direction == nil then
    return nil
  end

  local y_delta = math.floor(n_months / 12)
  local m_delta = n_months % 12
  local computed_year = (direction == "+") and (tonumber(os.date("%Y")) + y_delta)
    or (tonumber(os.date("%Y")) - y_delta)
  local computed_month = (direction == "+") and (tonumber(os.date("%m")) + m_delta)
    or (tonumber(os.date("%m")) - m_delta)

  local computed_date = string.format("%04d/%02d/%s", computed_year, computed_month, os.date("%d"))
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "Todo" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

---@param spec string -- Expected format: (+|-)<N>y (e.g. +2y)
---@return string? computed_date
local function handle_relative_year(spec)
  local _, _, direction, n_years = string.find(spec, "^([+-])(%d+)y$")
  if direction == nil then
    return nil
  end

  local start_time = get_start_time()
  local computed_time = (direction == "+") and (start_time + (60 * 60 * 24 * 365 * n_years))
    or (start_time - (60 * 60 * 24 * 365 * n_years))

  local computed_date = os.date("%Y/%m/%d", computed_time)
  local computed_date_file = string.format("%s/%s.norg", calendar_dir, computed_date)
  if vim.uv.fs_stat(computed_date_file) then
    vim.cmd(string.format("edit %s/%s.norg", calendar_dir, computed_date))
  else
    vim.notify(string.format("File '%s' does not exist", computed_date_file), vim.log.levels.WARN, { title = "TODO" })
  end

  ---@diagnostic disable-next-line: return-type-mismatch
  return computed_date
end

------------------------------------------------------------------------------------------------------
-- Exact dates
------------------------------------------------------------------------------------------------------

-- TODO: Finish implementing this
local function handle_exact_date(spec)
  local _, _, year, month, day = string.find(spec, "^(%d%d%d%d)[-/]?(%d%d)[-/]?(%d%d)$")
end

--====================================================================================================
-- Command
--====================================================================================================
--- :Todo <ARG>...
--    - arg can be in the following forms
--      - "today"
--      - "<N>d"
--      - "<N>m"
--      - "<N>y"
--      - "(+|-)<N>d"
--      - "(+|-)<N>m"
--      - "(+|-)<N>y"
--      - "<Y><M><D>"
--      - "<Y>-<M>-<D>"
--      - "<Y>/<M>/<D>"
--    - if multiple args are supplied, they will be executed in sequence, one after another
vim.api.nvim_create_user_command("Todo", function(attrs)
  local nargs = #attrs.fargs

  if nargs == 0 then
    vim.cmd(string.format("edit %s/inbox.norg", todo_dir))
    vim.cmd(string.format("split %s/%s.norg", calendar_dir, os.date("%Y/%m/%d")))
  end

  for _, arg in ipairs(attrs.fargs) do
    if arg == "today" then
      vim.cmd(string.format("edit %s/inbox.norg", todo_dir))
    elseif handle_absolute_day(arg) then
    elseif handle_absolute_month(arg) then
    elseif handle_absolute_year(arg) then
    elseif handle_relative_day(arg) then
    elseif handle_relative_month(arg) then
    elseif handle_relative_year(arg) then
    elseif handle_exact_date(arg) then
    end
  end
end, { nargs = "?" })
