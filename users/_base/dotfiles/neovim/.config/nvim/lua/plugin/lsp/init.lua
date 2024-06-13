local lspconfig = require("lspconfig")
require("plugin.lsp._ui")
require("plugin.lsp._diagnostics")

local global_config = {
  on_attach = require("plugin.lsp._attach"),
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

for server, config in pairs(require("plugin.lsp._configurations")) do
  lspconfig[server].setup(vim.tbl_deep_extend("keep", config, global_config))
end
-- {
--   'williamboman/mason.nvim',
--   opts = function()
--     local path = require("mason-core.path")
--
--     return {
--       ui = {
--         -- Whether to automatically check for new versions when opening the :Mason window.
--         check_outdated_packages_on_open = true,
--
--         border = "double",
--
--         icons = {
--           package_installed = "",
--           package_pending = "",
--           package_uninstalled = "",
--         },
--
--         keymaps = {
--           toggle_package_expand = "<CR>",
--           install_package = "i", -- Install package under cursor
--           update_package = "u", -- Reinstall/update package under cursor
--           check_package_version = "c", -- Check package under cursor for new version
--           update_all_packages = "U", -- Update all installed packages
--           check_outdated_packages = "C", -- Check which packages are outdates
--           uninstall_package = "X", -- Uninstall package under cursor
--           cancel_installation = "<C-c>", -- Cancel package installation
--           apply_language_filter = "<C-f>",
--         },
--       },
--
--       -- The directory in which to install packages.
--       install_root_dir = path.concat { vim.fn.stdpath("data"), "mason" },
--
--       log_level = vim.log.levels.INFO,
--       max_concurrent_installers = 4,
--
--       github = {
--         download_url_template = "https://github.com/%s/releases/download/%s/%s",
--       },
--     }
--   end
-- },
-- {
--   'williamboman/mason-lspconfig.nvim',
--   dependencies = {
--     'williamboman/mason.nvim',
--   },
--   opts = {
--     ensure_installed = {},
--     automatic_installation = false,
--   },
-- },
