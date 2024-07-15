-- configuration gets merged on multiple levels (highest priority first):
--  (1) user configuration, i.e. the one we assign to when we execute e.g. require("lspconfig")["lua_ls"].setup(<config>)
--  (2) server-specific default configuration, located in e.g. require("lspconfig.server_configurations.lua_ls").default_config
--  (3) global default configuration, located in require("lspconfig.util").default_config

-- to add a server:
--   create a module with name equal to the desired server in https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

--- Get absolute path to this module
--
---@return string
local function get_current_module_directory()
  -- get the abs path to current module
  local path = debug.getinfo(2, "S").source

  -- remove the "@" character at the beginning if it's there
  if path:sub(1, 1) == "@" then
    path = path:sub(2)
  end

  -- get the directory part of the path
  return vim.fn.fnamemodify(path, ":h")
end

--- Get list of files in a directory
--
---@param dir string
---@return table? list of files if dir exists else nil
local function get_files_in_directory(dir)
  local files = {}
  local p = io.popen('ls "' .. dir .. '"')
  if p then
    for file in p:lines() do
      table.insert(files, file)
    end
    p:close()
  else
    vim.notify("unable to open directory " .. dir, vim.log.levels.ERROR)
    return nil
  end
  return files
end

local configurations = {}
local blacklist = {
  ["init"] = true, -- this file is an exception
}
for _, filename in ipairs(get_files_in_directory(get_current_module_directory())) do
  local module_name = filename:match("(.*).lua")
  if not blacklist[module_name] then
    configurations[module_name] = require("config.plugins.configurations.lspconfig._configurations." .. module_name)
  end
end
return configurations
