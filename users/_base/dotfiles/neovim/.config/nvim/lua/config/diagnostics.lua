--==================================================================================================
-- CONFIG
--==================================================================================================
local base_diagnostic_config = {
  virtual_lines = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    scope = "line",
    border = "rounded",
    header = "",
    source = true,
    prefix = "",
  },
}

local diagnostic_index = 1
local diagnostic_toggle_order = {
  {
    underline = true,
    virtual_text = false,
  },
  {
    underline = true,
    virtual_text = true,
  },
  {
    underline = false,
    virtual_text = true,
  },
  {
    underline = false,
    virtual_text = false,
  },
}
local toggle_diagnostics = function()
  diagnostic_index = (diagnostic_index % #diagnostic_toggle_order) + 1

  vim.diagnostic.config(diagnostic_toggle_order[diagnostic_index])
end

vim.diagnostic.config(vim.tbl_deep_extend("force", base_diagnostic_config, diagnostic_toggle_order[1]))

--==================================================================================================
-- KEYBINDS
--==================================================================================================
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { noremap = true, silent = true })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { noremap = true, silent = true })

vim.keymap.set("n", vim.g.toggle_key .. "d", vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set("n", vim.g.toggle_key .. "D", toggle_diagnostics, { noremap = true, silent = true })
