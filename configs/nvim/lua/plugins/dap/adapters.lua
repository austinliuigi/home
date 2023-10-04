local adapters = {}

adapters.python = {
  type = "executable",
  command = "debugpy-adapter",
  -- command = "python",
  -- args = { "-m", "debugpy.adapter" },
}

return adapters
