local configurations = {}

configurations.python = {
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

return configurations
