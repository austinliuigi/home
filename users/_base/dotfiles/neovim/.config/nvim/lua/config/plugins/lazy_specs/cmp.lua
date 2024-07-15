local separator = "/"
local pattern = table.concat({ "after", "plugin" }, separator)
local function detect_after_plugin(name, plugin_path)
  local after_path = plugin_path .. separator .. pattern
  local path_iter = vim
    .iter(vim.fs.dir(after_path, { depth = 99 }))
    :filter(function(relpath, type)
      return relpath:sub(-4) == ".lua" or relpath:sub(-4) == ".vim"
    end)
    :map(function(relpath, type)
      return after_path .. separator .. relpath
    end)
  return path_iter:totable()
end

return {
  "nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  after = function()
    local sources = {
      "cmp-buffer",
      "cmp-calc",
      "cmp-cmdline",
      "cmp-cmdline-history",
      "cmp-dap",
      "cmp-digraphs",
      "cmp-luasnip",
      "cmp-nvim-lsp",
      "cmp-nvim-lsp-signature-help",
      "cmp-nvim-lua",
      "cmp-path",
    }
    for _, source in ipairs(sources) do
      -- vim.print(detect_after_plugin(source, table.concat({ require("rocks-git.config").path, "opt", source }, "/")))
      local after_files =
        detect_after_plugin(source, table.concat({ require("rocks-git.config").path, "opt", source }, "/"))
      vim.cmd("packadd! " .. source) -- add plugin dir to runtimepath
      require("rocks-config").configure(source) -- run config for plugin
      vim.cmd("packadd " .. source) -- source files in plugin's plugin dir
      for _, file in ipairs(after_files) do -- source files in plugin's after/plugin dir
        vim.cmd('silent exe "source ' .. file .. '"')
      end
    end
    vim.api.nvim_exec_autocmds("User", { pattern = "CmpLoadPost", modeline = false })
    vim.g.cmp_loaded = true
  end,
}
