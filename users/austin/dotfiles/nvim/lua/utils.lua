-- Print lua table
-- @param table Table to print
P = function(table)
  print(vim.inspect(table))
  return table
end



-- Return highlight color (hex or color name) of a given group's attribute
-- @param group Name of highlight group
-- @param attribute 'foreground' | 'background'
GetHiVal = function (group, attribute)
  return string.format("#%06x", vim.api.nvim_get_hl_by_name(group, true)[attribute])
end



-- Copy output of command into given register
-- If no registers are given, use default ones
-- e.g. `Cp "echo 'hello'" "a`
vim.api.nvim_create_user_command("Cp", function(args)
  local fargs = args.fargs

  -- If a register was explicity given
  if #fargs[#fargs] == 2 and string.match(fargs[#fargs], '".') then
    -- Remove last element in fargs (provided register) and set the last char to reg
    local reg = string.sub(table.remove(fargs), -1, -1)
    print(reg)
    -- Redirect output of command to given register
    vim.cmd('redir @' .. reg .. ' | execute ' .. table.concat(args.fargs, " ") .. ' | redir END')
  else
    -- Mapping from 'clipboard' option to register names
    local clip_to_reg = { unnamed = "*", unnamedplus = "+" }
    -- Redirect output of command to default register
    vim.cmd('redir @" | execute ' .. table.concat(args.fargs, " ") .. ' | redir END')
    -- For each register in 'clipboard'
    for _, opt in ipairs(vim.opt.clipboard:get()) do
      -- Copy contents of default register into reg
      vim.cmd("let @" .. clip_to_reg[opt] .. '=@"')
    end
  end
end, { nargs = "+" })

vim.api.nvim_create_user_command("Cd", function(args)
  vim.cmd("tcd %:p:h")
end, { nargs = 0 })

vim.api.nvim_create_user_command("Cdr", function(args)
  local buffer_dir = vim.fn.expand("%:p:h")
  local project_root = vim.fn.trim(vim.fn.system(string.format("cd %s; git rev-parse --show-toplevel", buffer_dir)))
  local msg_hl = "Error"
  if not project_root:find("fatal") then
    vim.cmd("tcd "..project_root)
    msg_hl = "Type"
  end
  vim.api.nvim_echo({ { project_root, msg_hl } }, true, {})
end, { nargs = 0 })

vim.api.nvim_create_user_command("StripTrailing", function(args)
  vim.cmd(args.line1..","..args.line2 .. "s/\\s\\+$//")
end, { nargs = 0, range = true })
