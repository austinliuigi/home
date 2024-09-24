local lint = require("lint")

lint.linters_by_ft = {
  python = { "pylint" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- try linting after immediately b/c the first buffer's BufEnter occurs before nvim-lint loads
lint.try_lint()
