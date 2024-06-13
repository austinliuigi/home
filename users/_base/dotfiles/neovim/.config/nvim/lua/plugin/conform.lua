require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
  },
})

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})

-- formatexpr for `gq` or textwidth being exceeded in insert mode
--   if triggered by textwidth being exceeded in insert mode
--     use internal formatting
--   if triggered by gq
--     if filetype has configured formatters, use those
--     elseif lsp_fallback is set, use that
--     else do nothing
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
