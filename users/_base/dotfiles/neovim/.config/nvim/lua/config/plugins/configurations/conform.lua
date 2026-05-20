require("conform").setup({
  formatters_by_ft = {
    c = { "clang_format" },
    cpp = { "clang_format" },
    lua = { "stylua" },
    java = { "clang-format" },
    javascript = { "prettierd" },
    nix = { "alejandra" },
    norg = { "vim_indent", "injected" },
    python = { "black" },
    typst = { "typstyle" },
  },
  formatters = { -- custom formatters
    vim_indent = {
      -- NOTE: we don't use a temp buffer b/c neorg's sets 'indentexpr' to a buffer-specific value
      --       since indents on a line depend on how the lines before it were indenting (in the same `=` operation)
      format = function(_, ctx, lines, callback)
        local view = vim.fn.winsaveview()
        local cmd = (ctx.range ~= nil) and "=" or "gg=G"

        -- create a new undo block so that the indentation gets undone on its own
        -- even if the formatting was triggered by a script/function
        --   - see `:h undo-close-block`
        vim.go.undolevels = vim.go.undolevels

        vim.cmd("keepjumps normal! " .. cmd)
        local out_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
        vim.cmd("normal! u")

        callback(nil, out_lines)
        vim.fn.winrestview(view)
      end,
    },
  },
})

--==============================================================================
-- Formatter Overrides
--==============================================================================
require("conform").formatters.typstyle = {
  append_args = { "--wrap-text", "--tab-width", "2" },
}

--==============================================================================
-- :Format command
--==============================================================================
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

--==============================================================================
-- Format on save
--==============================================================================
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
