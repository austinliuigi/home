--==================================================================================================
-- ENABLED SERVERS
--
-- To add a server:
--   - add its name to this enabled_servers list
--     - use the name that lspconfig uses: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
--   - add any custom configuration to ~/.config/nvim/lsp/<name>.lua
--==================================================================================================
local enabled_servers = {
  "clangd",
  "lua_ls",
  "nixd",
  "pyright",
  "tailwindcss",
  "texlab",
  "ts_ls",
  "tinymist",
}

for _, server in ipairs(enabled_servers) do
  vim.lsp.enable(server)
end

--==================================================================================================
-- BASE CONFIG
--==================================================================================================
vim.lsp.config("*", {
  root_markers = { ".git" },
})

vim.api.nvim_create_augroup("LspKeybinds", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = "LspKeybinds",
  pattern = { "*" },
  callback = function()
    local bufopts = { remap = false, silent = true, buffer = 0 }
    vim.lsp.inlay_hint.enable(false, {})

    -- Misc
    --------------------------------------------------------------------------------------------
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, bufopts)

    -- Documentation
    --------------------------------------------------------------------------------------------
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover({ border = "rounded" })
    end, bufopts)
    vim.keymap.set("n", "<leader>K", function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end, bufopts)

    -- Hints
    --------------------------------------------------------------------------------------------
    vim.keymap.set("n", vim.g.toggle_key .. "H", function()
      local enabled = vim.lsp.inlay_hint.is_enabled()
      vim.lsp.inlay_hint.enable(not enabled, {})
    end, bufopts)
  end,
})

--==================================================================================================
-- CUSTOM HANDLERS
--==================================================================================================

----------------------------------------------------------------------------------------------------
-- LSP Progress Notifications
--   - reference: https://github.com/echasnovski/mini.nvim/blob/8f2ea1e69546d2606b97cb1c0e9458a1a0d2e73f/lua/mini/notify.lua#L665
----------------------------------------------------------------------------------------------------
local lsp_progress = {}
vim.lsp.handlers["$/progress prev"] = vim.lsp.handlers["$/progress"]
vim.lsp.handlers["$/progress"] = function(err, result, ctx, config)
  -- First call original LSP handler. On Neovim>=0.10 this is crucial to not override `LspProgress` event.
  if vim.is_callable(vim.lsp.handlers["$/progress prev"]) then
    vim.lsp.handlers["$/progress prev"](err, result, ctx, config)
  end

  if err ~= nil then
    return vim.notify(vim.inspect(err), vim.log.levels.ERROR)
  end
  if not (type(result) == "table" and type(result.value) == "table") then
    return
  end

  local value = result.value
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client == nil then
    return
  end

  -- Construct LSP progress id
  local buf_id = ctx.bufnr or "nil"
  local lsp_progress_id = buf_id .. client.name .. (result.token or "")
  local progress_info = lsp_progress[lsp_progress_id] or {}

  -- Store percentage to be used if no new one was sent
  progress_info.percentage = (value.kind == "end" and 100 or value.percentage) or progress_info.percentage or 0

  -- Cache title because it is only supplied on 'begin'
  if value.kind == "begin" then
    progress_info.title = value.title
  end

  -- Construct message
  local title, message = progress_info.title or "", value.message or ""
  local msg = string.format(
    "%s: %s%s%s%s(%s%%)",
    client.name,
    title,
    title == "" and "" or " ",
    message,
    message == "" and "" or " ",
    progress_info.percentage
  )

  -- Notify
  if progress_info.notif_id ~= -1 then
    progress_info.notif_id = vim.notify(msg, vim.log.levels.INFO, {
      title = "LSP",
      replace = progress_info.notif_id,
      on_close = function()
        progress_info.notif_id = -1
      end,
    })
  end

  -- Cache progress info
  lsp_progress[lsp_progress_id] = progress_info
end
