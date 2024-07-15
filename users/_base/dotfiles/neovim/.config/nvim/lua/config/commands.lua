-- Copy output of command into given register; if no registers are given, use default ones
-- syntax: Cp [<reg>] <cmd>
--   reg: char - register to store command output in
--   cmd: string - ex command to run, passed directly to :execute
-- e.g. `Cp a "echo 'hello'"`
-- note: if output requires a pager, it will only get copied if you scroll to the end
-- note: we pass args instead of fargs to :execute because fargs replaces every pair of backslashes with one backslash
vim.api.nvim_create_user_command("Cp", function(attrs)
  local args = attrs.args
  local fargs = attrs.fargs
  vim.print("args: ", args)
  vim.print("fargs: ", fargs)

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

  -- if a register was explicity given
  --   - note: we don't use the `register` command-attribute because
  --     it could falsely consume e.g. the first double quote
  if #fargs[1] == 1 then
    local reg = fargs[1]
    if not is_reg(reg) then
      vim.notify(string.format("Cp: %s is not a valid register", reg), vim.log.levels.ERROR)
      return
    end
    args = string.gsub(args, "^.%s+", "") -- remove register from args
    vim.notify(string.format("Cp: copied output into register %s", reg), vim.log.levels.INFO) -- printing before executing preserves output in cmdline
    vim.cmd("redir @" .. reg .. " | execute " .. args .. " | redir END") -- redirect output of command to supplied register
  else
    local clip_to_reg = { unnamed = "*", unnamedplus = "+" } -- mapping from 'clipboard' option to register names
    vim.notify("Cp: copied output", vim.log.levels.INFO)
    vim.cmd('redir @" | execute ' .. args .. " | redir END") -- redirect output of command to default register
    -- copy contents of default register into reg
    for _, opt in ipairs(vim.opt.clipboard:get()) do
      vim.cmd("let @" .. clip_to_reg[opt] .. '=@"') -- :h let-@
    end
  end
end, { nargs = "+", register = false })

--- Change directory to head of current buffer
--
vim.api.nvim_create_user_command("Cd", function(args)
  vim.cmd("tcd %:p:h")
end, { nargs = 0 })

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
