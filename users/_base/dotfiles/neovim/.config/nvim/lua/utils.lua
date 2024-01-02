-- Return highlight color (hex or color name) of a given group's attribute
-- @param group Name of highlight group
-- @param attribute 'foreground' | 'background'
GetHl = function(group, attribute)
  return string.format("#%06x", vim.api.nvim_get_hl_by_name(group, true)[attribute])
end

-- Copy output of command into given register; if no registers are given, use default ones
-- syntax: Cp <cmd> [<reg>]
--   cmd: string - ex command to run, same form as :execute
--   reg: register - register to store command output in
-- e.g. `Cp "echo 'hello'" "a`
-- note: if output requires a pager, it will only get copied if you scroll to the end
vim.api.nvim_create_user_command("Cp", function(args)
  local fargs = args.fargs

  -- If a register was explicity given
  if #fargs[#fargs] == 2 and string.match(fargs[#fargs], '".') then
    -- Remove last element in fargs (provided register) and set the last char to reg
    local reg = string.sub(table.remove(fargs), -1, -1)
    print(reg)
    -- Redirect output of command to given register
    vim.cmd("redir @" .. reg .. " | execute " .. table.concat(args.fargs, " ") .. " | redir END")
  else
    -- Mapping from 'clipboard' option to register names
    local clip_to_reg = { unnamed = "*", unnamedplus = "+" }
    -- Redirect output of command to default register
    vim.cmd('redir @" | execute ' .. table.concat(args.fargs, " ") .. " | redir END")
    -- For each register in 'clipboard'
    for _, opt in ipairs(vim.opt.clipboard:get()) do
      -- Copy contents of default register into reg
      vim.cmd("let @" .. clip_to_reg[opt] .. '=@"')
    end
  end
end, { nargs = "+" })

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
