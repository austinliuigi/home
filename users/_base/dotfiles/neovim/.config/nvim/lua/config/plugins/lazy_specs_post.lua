local utils = require("config._utils")

local function default_before_hook(plugin)
  -- https://github.com/nvim-neorocks/rocks-lazy.nvim/blob/main/lua/rocks-lazy/internal.lua#L17-L40
  local user_rocks = require("rocks.api").get_user_rocks()
  local rock_spec = user_rocks[plugin.name]
  if rock_spec then
    pcall(vim.cmd.packadd, { plugin.name, bang = true })
    require("rocks-config").configure(rock_spec)
  else
    vim.print(("lazy_specs_post: skipping rocks-config hook because %s not found in user rocks."):format(plugin.name))
  end
end

local specs = {}
for _, filename in ipairs(utils.get_files_in_directory(utils.get_current_module_directory() .. "/lazy_specs")) do
  local module_name = filename:match("(.*).lua")
  local spec = require("config.plugins.lazy_specs." .. module_name)
  local custom_before_hook = (spec.before ~= nil) and spec.before or function() end
  spec.before = function(plugin)
    custom_before_hook()
    default_before_hook(plugin)
  end
  table.insert(specs, spec)
end
return specs
