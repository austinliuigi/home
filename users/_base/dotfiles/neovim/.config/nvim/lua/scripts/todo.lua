vim.g.todo_strict_dates = true -- if true, dates that don't exist will raise an error, otherwise they will roll over e.g. 2025-13-01 becomes 2026-01-01
vim.g.todo_ignore_invalid_args = true

local todo_dir = vim.fn.expand("~") .. "/todo"
local calendar_dir = todo_dir .. "/calendar"

local function date_to_time(date)
  local _, _, year, month, day = date:find("(%d%d%d%d)/(%d%d)/(%d%d)")
  return os.time({ year = year, month = month, day = day })
end

-- If current buffer is in calendar, start relative to that day, otherwise start relative to current day
local function get_start_time()
  local _, _, buf_date = string.find(vim.api.nvim_buf_get_name(0), calendar_dir .. "/(%d%d%d%d/%d%d/%d%d).norg")
  return (buf_date == nil) and os.time() or date_to_time(buf_date)
end

local function is_leap_year(year)
  return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

local function get_days_in_month(month, year)
  local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
  if month == 2 and is_leap_year(year) then
    return 29
  else
    return days_in_month[month]
  end
end

local function is_valid_date(date)
  local _, _, year, month, day = date:find("(%d%d%d%d)/(%d%d)/(%d%d)")
  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)

  if month < 1 or month > 12 then
    return false
  end
  if day < 1 or day > get_days_in_month(month, year) then
    return false
  end
  return true
end

--====================================================================================================
-- Handlers
--====================================================================================================

------------------------------------------------------------------------------------------------------
-- Today
------------------------------------------------------------------------------------------------------
---@param spec string -- Expected format: "today"
---@return number? computed_time
local function handle_today(spec)
  if spec == "today" then
    ---@diagnostic disable-next-line: return-type-mismatch
    return os.time()
  end
  return nil
end

------------------------------------------------------------------------------------------------------
-- Absolute days, months, years
------------------------------------------------------------------------------------------------------

---@param spec string -- Expected format: <N>d (e.g. 21d)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_absolute_day(spec, start_time)
  local _, _, day = spec:find("^(%d+)d$")
  if day == nil then
    return nil
  end

  local computed_date = os.date("%Y/%m/" .. string.format("%02d", day), start_time or get_start_time())
  if not is_valid_date(computed_date) and vim.g.todo_strict_dates then
    return nil
  end
  return date_to_time(computed_date)
end

---@param spec string -- Expected format: <N>m (e.g. 8m)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_absolute_month(spec, start_time)
  local _, _, month = spec:find("^(%d+)m$")
  if month == nil then
    return nil
  end

  local computed_date = os.date("%Y/" .. string.format("%02d", month) .. "/%d", start_time or get_start_time())
  if not is_valid_date(computed_date) and vim.g.todo_strict_dates then
    return nil
  end
  return date_to_time(computed_date)
end

---@param spec string -- Expected format: <N>y (e.g. 2020y)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_absolute_year(spec, start_time)
  local _, _, year = spec:find("^(%d+)y$")
  if year == nil then
    return nil
  end

  local computed_date = os.date(string.format("%04d", year) .. "/%m/%d", start_time or get_start_time())
  if not is_valid_date(computed_date) and vim.g.todo_strict_dates then
    return nil
  end
  return date_to_time(computed_date)
end

------------------------------------------------------------------------------------------------------
-- Relative days, months, years
------------------------------------------------------------------------------------------------------

---@param spec string -- Expected format: (+|-)<N>d (e.g. +21d)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_relative_day(spec, start_time)
  local _, _, direction, n_days = spec:find("^([+-])(%d+)d$")
  if direction == nil then
    return nil
  end

  local computed_time = (direction == "+") and (start_time + (60 * 60 * 24 * n_days))
    or (start_time - (60 * 60 * 24 * n_days))
  return computed_time
end

---@param spec string -- Expected format: (+|-)<N>w (e.g. +5w)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_relative_week(spec, start_time)
  local _, _, direction, n_weeks = spec:find("^([+-])(%d+)w$")
  if direction == nil then
    return nil
  end

  local computed_time = (direction == "+") and (start_time + (60 * 60 * 24 * 7 * n_weeks))
    or (start_time - (60 * 60 * 24 * 7 * n_weeks))
  return computed_time
end

---@param spec string -- Expected format: (+|-)<N>y (e.g. +2y)
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_relative_year(spec, start_time)
  local _, _, direction, n_years = spec:find("^([+-])(%d+)y$")
  if direction == nil then
    return nil
  end

  -- account for leap years
  local start_year = os.date("%Y", start_time)
  local n_leap_days = 0
  if is_leap_year(start_year) then
    if start_time > date_to_time(os.date(start_year .. "/02/29", start_time)) then
      n_leap_days = (direction == "+") and 0 or 1
    else
      n_leap_days = (direction == "-") and 0 or 1
    end
  end
  for year = start_year + 1, start_year + n_years do
    if is_leap_year(year) then
      n_leap_days = n_leap_days + 1
    end
  end

  local computed_time = (direction == "+")
      and (start_time + (60 * 60 * 24 * 365 * n_years) + (60 * 60 * 24 * n_leap_days))
    or (start_time - (60 * 60 * 24 * 365 * n_years) - (60 * 60 * 24 * n_leap_days))
  return computed_time
end

------------------------------------------------------------------------------------------------------
-- Weekday names
------------------------------------------------------------------------------------------------------

--- Go to the closest date in the future with given weekday name
--- If already at that day, don't move
--
---@param spec string -- Expected format: "mon[day]"|"tue[sday]"|"wed[nedday]"|"thu[rsday]"|"fri[day]"
---@param start_time number -- Time to start from, as encoded by os.time()
---@return number? computed_time
local function handle_weekday_name(spec, start_time)
  local weekdays = {
    Sunday = 0,
    Monday = 1,
    Tuesday = 2,
    Wednesday = 3,
    Thursday = 4,
    Friday = 5,
    Saturday = 6,
  }

  local target_day
  if spec:match("^sun") then
    target_day = "Sunday"
  elseif spec:match("^mon") then
    target_day = "Monday"
  elseif spec:match("^tue") then
    target_day = "Tuesday"
  elseif spec:match("^wed") then
    target_day = "Wednesday"
  elseif spec:match("^thu") then
    target_day = "Thursday"
  elseif spec:match("^fri") then
    target_day = "Friday"
  elseif spec:match("^sat") then
    target_day = "Saturday"
  else
    return nil
  end

  local start_day = os.date("%A", start_time)

  local delta_days = (weekdays[target_day] - weekdays[start_day]) % 7
  return handle_relative_day("+" .. delta_days .. "d", start_time)
end

------------------------------------------------------------------------------------------------------
-- Exact dates
------------------------------------------------------------------------------------------------------

---@param spec string -- Expected format: (+|-)<N>y (e.g. +2y)
---@return number? computed_time
local function handle_exact_date(spec)
  local _, _, year, month, day = spec:find("^(%d%d%d%d)[-/]?(%d%d)[-/]?(%d%d)$")
  if year == nil then
    return nil
  end
  return date_to_time(string.format("%s/%s/%s", year, month, day))
end

--====================================================================================================
-- Command
--====================================================================================================
--- :Todo <ARG>...
--    - arg can be in the following forms
--      - "today"
--      - "mon[day]"|"tues[day]"|"wed[nedday]"|"thurs[day]"|"fri[day]"
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

local handlers = {
  -- PERF: order by most common to least common
  handle_today,
  handle_relative_day,
  handle_relative_week,
  handle_weekday_name,
  handle_absolute_day,
  handle_absolute_month,
  handle_absolute_year,
  handle_exact_date,
  handle_relative_year,
}

vim.api.nvim_create_user_command("Todo", function(attrs)
  local nargs = #attrs.fargs

  -- :Todo
  --------------------------------------------------
  if nargs == 0 then
    local cell_aspect_ratio = 2.2 / 1 -- heuristic; it actually depends on the font
    vim.cmd(string.format("edit %s/inbox.norg", todo_dir))
    if vim.api.nvim_win_get_height(0) * cell_aspect_ratio > vim.api.nvim_win_get_width(0) then
      vim.cmd(string.format("split %s/%s.norg", calendar_dir, os.date("%Y/%m/%d")))
    else
      vim.cmd(string.format("vsplit %s/%s.norg", calendar_dir, os.date("%Y/%m/%d")))
    end
    return
  end

  -- :Todo[!] <arg>...
  --------------------------------------------------
  local start_buf = vim.api.nvim_win_get_buf(0)
  local time = get_start_time()

  -- handle each arg
  for _, arg in ipairs(attrs.fargs) do
    local handler_succeeded = false
    for _, handler in ipairs(handlers) do
      local computed_time = handler(arg, time)
      if computed_time then
        time = computed_time
        handler_succeeded = true
        break
      end
    end

    -- handle invalid arg
    if not handler_succeeded then
      if vim.g.todo_ignore_invalid_args then
        vim.notify(
          string.format("unable to parse argument '%s', ignoring and continuing", arg),
          vim.log.levels.WARN,
          { title = "TODO" }
        )
      else
        vim.notify(
          string.format("unable to parse argument '%s', aborting", arg),
          vim.log.levels.ERROR,
          { title = "TODO" }
        )
        vim.api.nvim_win_set_buf(0, start_buf)
        break
      end
    end
  end

  -- navigate to computed date file
  local date = os.date("%Y/%m/%d", time)
  local date_file = string.format("%s/%s.norg", calendar_dir, date)
  if vim.uv.fs_stat(date_file) then
    vim.cmd(string.format("edit %s", date_file))
  else
    vim.notify(string.format("File '%s' does not exist", date_file), vim.log.levels.WARN, { title = "TODO" })
  end
end, { nargs = "*" })

--====================================================================================================
-- Mapping
--====================================================================================================
vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    if string.match(vim.api.nvim_buf_get_name(0), todo_dir) then
      vim.keymap.set("n", "(", function()
        vim.cmd(string.format("Todo -%dd", vim.v.count1))
      end, { buffer = 0 })
      vim.keymap.set("n", ")", function()
        vim.cmd(string.format("Todo +%dd", vim.v.count1))
      end, { buffer = 0 })
    end
  end,
})
