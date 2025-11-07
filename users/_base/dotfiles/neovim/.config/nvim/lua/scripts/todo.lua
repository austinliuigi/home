vim.g.todo_strict_dates = true -- if true, dates that don't exist will raise an error, otherwise they will roll over e.g. 2025-13-01 becomes 2026-01-01
vim.g.todo_ignore_invalid_args = true

local todo_dir = vim.fn.expand("~") .. "/todo"
local calendar_dir = todo_dir .. "/calendar"

--====================================================================================================
-- Types
--====================================================================================================

---@alias todo.Date string Format: yyyy/mm/dd (e.g. 2020/03/14)

---@alias todo.TodaySpec "today"
---@alias todo.AbsoluteDaySpec string Format: <N>d (e.g. 21d)
---@alias todo.AbsoluteMonthSpec string Format: <N>m (e.g. 8m)
---@alias todo.AbsoluteYearSpec string Format: <N>y (e.g. 2020y)
---@alias todo.RelativeDaySpec string Format: (+|-)<N>d (e.g. +21d)
---@alias todo.RelativeWeekSpec string Format: (+|-)<N>w (e.g. +5w)
---@alias todo.RelativeYearSpec string Format: (+|-)<N>y (e.g. +2y)
---@alias todo.WeekdayNameSpec string Format: "mon[day]"|"tue[sday]"|"wed[nedday]"|"thu[rsday]"|"fri[day]"

---@alias todo.Spec todo.TodaySpec|todo.AbsoluteDaySpec|todo.AbsoluteMonthSpec|todo.AbsoluteYearSpec|todo.RelativeDaySpec|todo.RelativeWeekSpec|todo.RelativeYearSpec|todo.WeekdayNameSpec

--====================================================================================================
-- Utils
--====================================================================================================

---@param date todo.Date
---@return integer time
local function date_to_time(date)
  local _, _, year, month, day = date:find("(%d%d%d%d)/(%d%d)/(%d%d)")
  return os.time({ year = year, month = month, day = day })
end

--- If current buffer is in calendar, start relative to that day, otherwise start relative to current day
---
---@return integer start_time
local function get_start_time()
  local _, _, buf_date = string.find(vim.api.nvim_buf_get_name(0), calendar_dir .. "/(%d%d%d%d/%d%d/%d%d).norg")
  return (buf_date == nil) and os.time() or date_to_time(buf_date)
end

---@param year string|integer
---@return boolean
local function is_leap_year(year)
  return year % 4 == 0 and (year % 100 ~= 0 or year % 400 == 0)
end

---@param month integer 1-12
---@param year integer
---@return integer days_in_month
local function get_days_in_month(month, year)
  local days_in_month = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
  if month == 2 and is_leap_year(year) then
    return 29
  else
    return days_in_month[month]
  end
end

--- Check if date is valid (exists in the calendar)
---
---@param date todo.Date
---@return boolean
local function is_valid_date(date)
  local _, _, year, month, day = date:find("(%d%d%d%d)/(%d%d)/(%d%d)")
  year = tonumber(year)
  month = tonumber(month)
  day = tonumber(day)

  if month < 1 or month > 12 then
    return false
  end
  ---@diagnostic disable-next-line: param-type-mismatch
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

  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
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

  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
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

  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
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
  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
  local start_year = os.date("%Y", start_time)
  local n_leap_days = 0
  if is_leap_year(start_year) then
    ---@diagnostic disable-next-line: param-type-mismatch
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
-- Commands
--====================================================================================================

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

---@param spec_list todo.Spec[] List of specs to handle sequentially
---@return integer computed_time Resulting time after handling all specs, or -1 if aborted due to invalid spec
local function process_specs(spec_list)
  local time = get_start_time()

  for _, spec in ipairs(spec_list) do
    local handler_succeeded = false
    for _, handler in ipairs(handlers) do
      ---@diagnostic disable-next-line: redundant-parameter
      local computed_time = handler(spec, time)
      if computed_time then
        time = computed_time
        handler_succeeded = true
        break
      end
    end

    -- handle invalid spec
    if not handler_succeeded then
      if vim.g.todo_ignore_invalid_args then
        vim.notify(
          string.format("unable to parse argument '%s', ignoring and continuing", spec),
          vim.log.levels.WARN,
          { title = "TODO" }
        )
      else
        vim.notify(
          string.format("unable to parse argument '%s', aborting", spec),
          vim.log.levels.ERROR,
          { title = "TODO" }
        )
        return -1
      end
    end
  end

  return time
end

------------------------------------------------------------------------------------------------------
--- :Todo <ARG>...
--    - arg can be in any of the following forms
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
------------------------------------------------------------------------------------------------------
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

  -- :Todo <arg>...
  --------------------------------------------------
  local time = process_specs(attrs.fargs)
  if time == -1 then
    return
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

------------------------------------------------------------------------------------------------------
--- :TodoReschedule <ARG>...
--    - same arguments as :Todo
------------------------------------------------------------------------------------------------------
vim.api.nvim_create_user_command("TodoReschedule", function(attrs)
  if attrs.range == 0 then
    return
  end

  local time = process_specs(attrs.fargs)
  if time == -1 then
    return
  end

  local date = os.date("%Y/%m/%d", time)
  local date_file = string.format("%s/%s.norg", calendar_dir, date)
  if not vim.uv.fs_stat(date_file) then
    vim.notify(string.format("File '%s' does not exist", date_file), vim.log.levels.WARN, { title = "TODO" })
    return
  end

  local items_to_reschedule = vim.api.nvim_buf_get_lines(0, attrs.line1 - 1, attrs.line2, true)

  -- remove items from original file
  local is_src_modified = vim.o.modified
  vim.api.nvim_buf_set_lines(0, attrs.line1 - 1, attrs.line2, true, {})
  if is_src_modified then
    vim.notify(
      "Source was in a modified state before rescheduling; not writing changes to disk",
      vim.log.levels.WARN,
      { title = "TODO" }
    )
  else
    vim.cmd("w")
  end

  -- set items in target file
  vim.cmd(string.format("edit %s", date_file))
  local is_target_modified = vim.o.modified
  local prev_last_line = vim.fn.line("$")
  vim.api.nvim_buf_set_lines(0, -1, -1, true, items_to_reschedule)
  if is_target_modified then
    vim.notify(
      "Target was in a modified state before rescheduling; not writing changes to disk",
      vim.log.levels.WARN,
      { title = "TODO" }
    )
  else
    vim.cmd("w")
  end
  vim.cmd(string.format("normal! %sGjVG$", prev_last_line)) -- visually select rescheduled changes
end, { nargs = "+", range = true })

--====================================================================================================
-- Mappings
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
      vim.keymap.set("x", "(", function()
        vim.cmd("normal!" .. vim.api.nvim_replace_termcodes("<Esc>", true, true, true)) -- leave visual mode so '< and '> marks get set
        vim.cmd(string.format("'<,'>TodoReschedule -%dd", vim.v.count1))
      end, { buffer = 0 })
      vim.keymap.set("x", ")", function()
        vim.cmd("normal!" .. vim.api.nvim_replace_termcodes("<Esc>", true, true, true)) -- leave visual mode so '< and '> marks get set
        vim.cmd(string.format("'<,'>TodoReschedule +%dd", vim.v.count1))
      end, { buffer = 0 })
    end
  end,
})

--====================================================================================================
-- Reminders
--====================================================================================================

local reminders_dir = calendar_dir .. "/reminders"
local todo_ns = vim.api.nvim_create_namespace("todo")

local function get_reminder_virt_lines(lines, map_fn)
  if map_fn then
    lines = vim.iter(lines):map(map_fn):totable()
  end

  table.insert(lines, 1, "")
  local virt_lines = vim
    .iter(lines)
    :map(function(line)
      return { { line, "Normal" } }
    end)
    :totable()

  return virt_lines
end

local function get_first_capture_node(query, tree)
  local parsed_query = vim.treesitter.query.parse("norg", query)
  local id, node = parsed_query:iter_captures(tree:root(), 0)()
  return node
end

vim.api.nvim_create_autocmd("BufRead", {
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local bufnr = vim.api.nvim_get_current_buf()
    local _, _, buf_date = string.find(bufname, calendar_dir .. "/(%d%d%d%d/%d%d/%d%d).norg")
    if buf_date and (date_to_time(buf_date)) > os.time() then
      local parse_remind_ouput = function(obj)
        local stdout = vim.split(obj.stdout, "\n")

        -- clean output to leave just a list of reminders (remove banner and empty lines)
        local reminders = vim
          .iter(stdout)
          :skip(1)
          :filter(function(line)
            return line ~= ""
          end)
          :totable()

        -- get heading nodes
        local tree = vim.treesitter.get_parser():parse()[1]
        local title_heading = get_first_capture_node("(heading1 title: (paragraph_segment) @title)", tree)
        local event_heading =
          get_first_capture_node('(heading2 title: (paragraph_segment) @events (#eq? @events "Events"))', tree)
        local task_heading =
          get_first_capture_node('(heading2 title: (paragraph_segment) @tasks (#eq? @tasks "Tasks"))', tree)

        local title_line = title_heading:start()
        local event_heading_line = event_heading:start()
        local task_heading_line = task_heading:start()

        -- categorize each reminder
        local bulletin_reminders = {}
        local event_reminders = {}
        local task_reminders = {}
        for _, reminder in ipairs(reminders) do
          local _, _, type, msg = string.find(reminder, "^%((%a+)%)%s+(.*)")
          if not type then
            _, _, msg = string.find(reminder, "(.*)")
            table.insert(bulletin_reminders, msg)
          else
            if type == "event" then
              table.insert(event_reminders, msg)
            elseif type == "task" then
              table.insert(task_reminders, msg)
            end
          end
        end

        -- set extmarks
        if not vim.tbl_isempty(bulletin_reminders) then
          vim.api.nvim_buf_set_extmark(bufnr, todo_ns, title_line, 0, {
            virt_lines = get_reminder_virt_lines(bulletin_reminders, function(rem)
              return "  • " .. rem
            end),
          })
        end

        if not vim.tbl_isempty(event_reminders) then
          vim.api.nvim_buf_set_extmark(bufnr, todo_ns, event_heading_line, 0, {
            virt_lines = get_reminder_virt_lines(event_reminders, function(rem)
              return "   • ( ) " .. rem
            end),
          })
        end

        if not vim.tbl_isempty(task_reminders) then
          vim.api.nvim_buf_set_extmark(bufnr, todo_ns, task_heading_line, 0, {
            virt_lines = get_reminder_virt_lines(task_reminders, function(rem)
              return "   • ( ) " .. rem
            end),
          })
        end
      end

      vim.system({ "remind", reminders_dir, buf_date }, { text = true }, vim.schedule_wrap(parse_remind_ouput))
    end
  end,
})
