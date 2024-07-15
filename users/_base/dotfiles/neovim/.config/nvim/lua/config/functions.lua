-- Return highlight color (hex or color name) of a given group's attribute
-- @param group Name of highlight group
-- @param attribute 'foreground' | 'background'
hl = function(group, attribute)
  return string.format("#%06x", vim.api.nvim_get_hl_by_name(group, true)[attribute])
end
