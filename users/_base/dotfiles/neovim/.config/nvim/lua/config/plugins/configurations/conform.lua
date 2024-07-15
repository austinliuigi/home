require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    javascript = { "prettierd" },
    -- nix = { "nixfmt" },
  },
})

-- format command
vim.api.nvim_create_user_command("Format", function(args)
  vim.g.conform_cmd_ran = true
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

-- format on save
vim.api.nvim_create_augroup("ConformFormatOnSave", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = "ConformFormatOnSave",
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
