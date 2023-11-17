local dap = require("dap")

dap.defaults.fallback.external_terminal = {
  command = tostring(io.popen("command -v kitty"):read("*line"));
  args = {};
}

-- Debugpy
dap.adapters.python = {
  type = "executable",
  command = "debugpy-adapter",
  -- command = "python",
  -- args = { "-m", "debugpy.adapter" },
}

dap.configurations.python = {
  {
    -- Options for debugpy: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
      local default_python3 = vim.fn.trim(vim.fn.system("command -v python3"))
      local default_python = vim.fn.trim(vim.fn.system("command -v python"))

      if venv_path ~= nil and venv_path ~= '' then
        return venv_path .. "/bin/python"
      elseif default_python3 ~= "" then
        return default_python3
      elseif default_python ~= "" then
        return default_python
      end
      return nil
    end,
    console = "integratedTerminal",
  },
}

--[[ -- Neovim Lua
dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host, port = config.port }
end

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input 'Host [127.0.0.1]: '
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input 'Port: ')
      assert(val, 'Please provide a port number')
      return val
    end,
  },
}

-- lldb
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = 'lldb',
}

dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
    runInTerminal = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp ]]

vim.fn.sign_define("DapBreakpoint", {text="ﴫ", texthl="GitSignsDelete", linehl="", numhl=""}) -- ●    ﴫ
vim.fn.sign_define("DapBreakpointCondition", {text="ﴫ", texthl="GitSignsChange", linehl="", numhl=""})
