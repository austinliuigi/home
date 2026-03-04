require("nvim-treesitter").setup({
  -- Directory to install parsers and queries to
  install_dir = vim.fn.stdpath("data") .. "/site",
})

--------------------------------------------------------------------------------
-- AUTOMATE TREESITTER
--   - automatically install parser for filetype if missing
--   - automatically enable treesitter in filetypes with a treesitter parser
--------------------------------------------------------------------------------
local function ts_start(bufnr, parser_name)
  vim.notify("Enabling treesitter parser for " .. parser_name, vim.log.levels.INFO, { title = "Treesitter" })
  vim.treesitter.start(bufnr, parser_name)
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Enable treesitter",
  callback = function(event)
    local bufnr = event.buf
    local filetype = event.match

    if filetype == "" then
      return
    end

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      vim.notify(vim.inspect("No treesitter parser found for filetype: " .. filetype), vim.log.levels.WARN)
      return
    end

    -- Parser not available through nvim-treesitter
    if not vim.tbl_contains(require("nvim-treesitter").get_available(), parser_name) then
      return
    end

    -- Check if parser is already installed
    if not vim.tbl_contains(require("nvim-treesitter").get_installed("parsers"), parser_name) then
      vim.notify("Installing treesitter parser for " .. parser_name, vim.log.levels.INFO)
      require("nvim-treesitter").install({ parser_name }):await(function()
        ts_start(bufnr, parser_name)
      end)
    else
      ts_start(bufnr, parser_name)
    end
  end,
})
