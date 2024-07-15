local utils = require("config._utils")

local function default_before_hook(plugin_name)
  vim.cmd("packadd! " .. plugin_name)
  require("rocks-config").configure(plugin_name)
end

local specs = {}
for _, filename in ipairs(utils.get_files_in_directory(utils.get_current_module_directory() .. "/lazy_specs")) do
  local module_name = filename:match("(.*).lua")
  local spec = require("config.plugins.lazy_specs." .. module_name)
  local custom_before_hook = (spec.before ~= nil) and spec.before or function() end
  spec.before = function()
    custom_before_hook()
    default_before_hook(spec[1])
  end
  table.insert(specs, spec)
end
return specs
