local is_reg = function(register)
  local ascii = string.byte(register)
  if ascii >= string.byte("a") and ascii <= string.byte("z") then
    return true
  end
  if ascii >= string.byte("A") and ascii <= string.byte("Z") then
    return true
  end
  if register == '"' then
    return true
  end
  if register == "*" then
    return true
  end
  if register == "+" then
    return true
  end
  return false
end

-- Copy output of command into given register; if no registers are given, use default ones
-- syntax: Cp [<reg>] <cmd>
--   reg: char - register to store command output in
--   cmd: vimscript commands
-- e.g. `Cp a echo 'hello'`
-- note: we pass args instead of fargs to :execute because fargs will remove backslashes to escape characters
vim.api.nvim_create_user_command("Cp", function(attrs)
  local args = attrs.args
  local fargs = attrs.fargs

  local registers = {}

  -- if a register was explicity given
  --   - note: we don't use the `register` command-attribute because
  --     it could falsely consume e.g. the first double quote
  if #fargs[1] == 1 then
    local reg = fargs[1]
    if not is_reg(reg) then
      vim.notify(string.format("Cp: %s is not a valid register", reg), vim.log.levels.ERROR)
      return
    end
    table.insert(registers, reg)

    args = string.gsub(args, "^.%s+", "") -- remove register from args
  else
    -- mapping from 'clipboard' option to register names
    local clip_to_reg = { unnamed = "*", unnamedplus = "+" }

    table.insert(registers, '"')
    for _, opt in ipairs(vim.opt.clipboard:get()) do
      table.insert(registers, clip_to_reg[opt])
    end
  end

  local output = vim.api.nvim_exec2(args, { output = true }).output

  if output == "" then
    vim.notify("Cp: Output is empty, skipped copy", vim.log.levels.WARN)
  end

  for _, reg in ipairs(registers) do
    vim.fn.setreg(reg, output)
  end

  -- execute output so user can see what was copied
  vim.api.nvim_exec2(args, { output = false })
end, { nargs = "+", register = false })

--- Change directory relative to head of current buffer
--
vim.api.nvim_create_user_command("Cd", function(attrs)
  local head = require("config._utils").get_buf_dir()
  local path = head .. "/" .. attrs.args -- if no arg provided, attrs.args is "" and this just appends a trailing slash
  local finfo = vim.uv.fs_stat(path)

  if finfo == nil then
    vim.notify("Cd: `" .. path .. "` does not exist", vim.log.levels.ERROR)
    return
  end

  if finfo.type ~= "directory" then
    vim.notify("Cd: `" .. path .. "` is not a directory", vim.log.levels.ERROR)
    return
  end

  -- print(path)
  vim.cmd("cd " .. path)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Tcd", function(attrs)
  local head = require("config._utils").get_buf_dir()
  local path = head .. "/" .. attrs.args -- if no arg provided, attrs.args is "" and this just appends a trailing slash
  local finfo = vim.uv.fs_stat(path)

  if finfo == nil then
    vim.notify("Tcd: `" .. path .. "` does not exist", vim.log.levels.ERROR)
    return
  end

  if finfo.type ~= "directory" then
    vim.notify("Tcd: `" .. path .. "` is not a directory", vim.log.levels.ERROR)
    return
  end

  -- print(path)
  vim.cmd("tcd " .. path)
end, { nargs = "?" })

vim.api.nvim_create_user_command("Lcd", function(attrs)
  local head = require("config._utils").get_buf_dir()
  local path = head .. "/" .. attrs.args -- if no arg provided, attrs.args is "" and this just appends a trailing slash
  local finfo = vim.uv.fs_stat(path)

  if finfo == nil then
    vim.notify("Lcd: `" .. path .. "` does not exist", vim.log.levels.ERROR)
    return
  end

  if finfo.type ~= "directory" then
    vim.notify("Lcd: `" .. path .. "` is not a directory", vim.log.levels.ERROR)
    return
  end

  -- print(path)
  vim.cmd("lcd " .. path)
end, { nargs = "?" })

--- Change directory to containing git repository
--
vim.api.nvim_create_user_command("Cdr", function(args)
  -- local buffer_dir = vim.fn.expand("%:p:h")
  -- local project_root = vim.fn.trim(vim.fn.system(string.format("cd %s; git rev-parse --show-toplevel", buffer_dir)))
  local cwd = vim.fn.getcwd()
  local project_root = vim.fn.trim(vim.fn.system(string.format("cd %s; git rev-parse --show-toplevel", cwd)))
  local msg_hl = "Error"
  if not project_root:find("fatal") then
    vim.cmd("tcd " .. project_root)
    msg_hl = "Type"
  end
  vim.api.nvim_echo({ { project_root, msg_hl } }, true, {})
end, { nargs = 0 })

--- Strip trailing whitespace
--
vim.api.nvim_create_user_command("StripTrailing", function(args)
  vim.cmd(args.line1 .. "," .. args.line2 .. "s/\\s\\+$//")
end, { nargs = 0, range = true })

--- Launcher mode (dmenu)
--
vim.api.nvim_create_user_command("Launcher", function(args)
  if vim.api.nvim_buf_get_name(0) ~= "" then
    print("Launcher can only be activated from an empty buffer")
    return
  end

  local parent_buf = vim.api.nvim_get_current_buf()
  local saved = {
    showtabline = vim.o.showtabline,
    laststatus = vim.o.laststatus,
    cmdheight = vim.o.cmdheight,
    notify = vim.notify,
  }

  vim.o.showtabline = 0
  vim.o.laststatus = 0
  vim.o.cmdheight = 0
  vim.notify = function() end

  require("telescope.builtin").builtin({
    layout_config = { height = vim.o.lines, width = vim.o.columns },
  })

  vim.api.nvim_create_autocmd("WinEnter", {
    buffer = parent_buf,
    callback = function()
      vim.o.showtabline = saved.showtabline
      vim.o.laststatus = saved.laststatus
      vim.o.cmdheight = saved.cmdheight
      vim.notify = saved.notify
      vim.cmd("q")
    end,
  })
end, { nargs = 0, range = true })
