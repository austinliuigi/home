local util = require("lspconfig").util

local python_root_files = {
  'pyproject.toml',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'pyrightconfig.json',
  '.git',
}

return {
  root_dir = util.root_pattern(unpack(python_root_files))
}
