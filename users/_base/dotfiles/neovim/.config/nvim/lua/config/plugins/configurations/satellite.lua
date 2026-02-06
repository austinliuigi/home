require("satellite").setup({
  current_only = true,
  winblend = 50,
  zindex = 40,
  excluded_filetypes = {},
  width = 2,
  handlers = {
    cursor = {
      enable = true,
      -- Supports any number of symbols
      symbols = { "⎺", "⎻", "⎼", "⎽" },
      -- symbols = { '⎻', '⎼' }
      -- Highlights:
      -- - SatelliteCursor (default links to NonText
    },
    search = {
      enable = false,
      overlap = false,
      -- Highlights:
      -- - SatelliteSearch (default links to Search)
      -- - SatelliteSearchCurrent (default links to SearchCurrent)
    },
    diagnostic = {
      enable = true,
      overlap = true,
      signs = { "·", "·", "·" },
      min_severity = vim.diagnostic.severity.HINT,
      -- Highlights:
      -- - SatelliteDiagnosticError (default links to DiagnosticError)
      -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
      -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
      -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
    },
    gitsigns = {
      enable = false,
      signs = { -- can only be a single character (multibyte is okay)
        add = "│",
        change = "│",
        delete = "-",
      },
      -- Highlights:
      -- SatelliteGitSignsAdd (default links to GitSignsAdd)
      -- SatelliteGitSignsChange (default links to GitSignsChange)
      -- SatelliteGitSignsDelete (default links to GitSignsDelete)
    },
    marks = {
      enable = true,
      overlap = false,
      show_builtins = false, -- shows the builtin marks like [ ] < >
      key = "m",
      -- Highlights:
      -- SatelliteMark (default links to Normal)
    },
    quickfix = {
      enable = false,
      signs = { "-", "=", "≡" },
      -- Highlights:
      -- SatelliteQuickfix (default links to WarningMsg)
    },
  },
})

local function autoset()
  if vim.fn.line("$") > 500 then
    vim.cmd("SatelliteDisable")
  else
    vim.cmd("SatelliteEnable")
  end
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = autoset,
  desc = "Disable Satellite on large files",
})

autoset()
