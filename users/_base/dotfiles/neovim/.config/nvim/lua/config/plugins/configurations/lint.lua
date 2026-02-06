local lint = require("lint")

lint.linters_by_ft = {
  -- NOTE: on nixos, if pylint is install using python.withPackages, it will be executed with
  --       that python s.t. PYTHONPATH is always overridden by the nix specific PYTHONPATH
  --         - in nix shells using their own python, you need to override the system pylint
  --           by including it in the shell's python with python.withPackages
  --         - in python virtual envs, you need to temporarily use an unpatched version of pylint
  --           e.g. uv add pylint && source .venv/bin/activate
  python = { "pylint" },
  c = { "cppcheck", "clangtidy" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
  callback = function()
    lint.try_lint()
  end,
})

-- try linting after immediately b/c the first buffer's BufEnter occurs before nvim-lint loads
lint.try_lint()
