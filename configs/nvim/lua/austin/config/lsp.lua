local lspconfig = require('lspconfig')
local navic = require('nvim-navic')
local toggle = require("austin.keymaps").toggle_key



-- Add borders to floating windows
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = 'rounded',
})



-- Configure diagnostics
local diagnostic_config = {
  underline = true,
  virtual_text = false,
  virtual_lines = false,
  -- virtual_lines = { only_current_line = true },
  -- signs = false,
  signs = {
    priority = 8
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    scope = 'line',
    border = 'rounded',
    header = '',
    source = true,
    prefix = '',
  }
}
vim.diagnostic.config(diagnostic_config)

-- Define signs for diagnostics
local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end



-- Function that is called whenever a server attaches
local on_attach = function(client, bufnr)
  -- Set lsp keymaps
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', toggle..'d', vim.diagnostic.open_float, bufopts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', toggle..'D', function()
    local prev_underline = diagnostic_config.underline
    local prev_text = diagnostic_config.virtual_text
    local prev_lines = diagnostic_config.virtual_lines

    diagnostic_config.underline = not (prev_underline or prev_text or prev_lines)
    diagnostic_config.virtual_text = prev_underline
    diagnostic_config.virtual_lines = prev_text

    vim.diagnostic.config(diagnostic_config)
  end, bufopts)

  navic.attach(client, bufnr)
end

-- Make capabilities compatible with cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Set up servers
local servers = { "clangd", "julials", "pyright", "sumneko_lua", "texlab", "yamlls", }
for _, server in ipairs(servers) do
  lspconfig[server].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

lspconfig["sumneko_lua"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}

local latex_forwardsearch_executable, latex_forwardsearch_args
if vim.fn.has("macos") then
  latex_forwardsearch_executable = "/Applications/Skim.app/Contents/SharedSupport/displayline"
  latex_forwardsearch_args = {"-g", "-b", "%l", "%p", "%f",}
elseif vim.fn.has("linux") then
  latex_forwardsearch_executable = "zathura"
  latex_forwardsearch_args = {"--synctex-forward", "%l:1:%f", "%p"}
end
lspconfig["texlab"].setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    texlab = {
      auxDirectory = ".",
      bibtexFormatter = "texlab",
      build = {
        args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-shell-escape","%f" },
        executable = "latexmk",
        forwardSearchAfter = true,
        onSave = true
      },
      chktex = {
        onEdit = false,
        onOpenAndSave = false
      },
      diagnosticsDelay = 300,
      formatterLineLength = 80,
      forwardSearch = {
        executable = latex_forwardsearch_executable,
        args = latex_forwardsearch_args
      },
      latexFormatter = "latexindent",
      latexindent = {
        modifyLineBreaks = false
      }
    }
  }
}
