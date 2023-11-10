return {
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require('alpha')
      require('alpha.term')
      local dashboard = require'alpha.themes.dashboard'


      --[[ Terminal header ]]
      -- dashboard.section.terminal.command = "kitty +kitten icat " .. os.getenv("HOME") .. "/Pictures/Pokemon/shroomish.png"
      -- dashboard.section.terminal.command = "echo 'test'"
      -- dashboard.section.terminal.opts = {
      --   width = 69,
      --   height = 8,
      -- }

      --[[ Header ]]
      local headers = require("plugins.alpha.headers")
      math.randomseed(os.time())
      dashboard.section.header.val = headers[math.random(#headers)]

      --[[ Buttons ]]
      dashboard.section.buttons.val = {
         -- dashboard.button( "e", "  New file" , ":ene <BAR><CR>"),
         dashboard.button( "<Esc>", "  Quit" , ":qa<CR>"),
      }

      --[[ Footer ]]
      local function footer()
        local total_plugins = #vim.tbl_keys(require('lazy').plugins())
        local version = vim.version()
        local nvim_version_info = "  Neovim v" .. version.major .. "." .. version.minor .. "." .. version.patch
        return " " .. total_plugins .. " plugins  " .. nvim_version_info
      end
      dashboard.section.footer.val = footer()

      --[[ Misc ]]
      -- when true,
      -- use 'noautocmd' when setting 'alpha' buffer local options.
      -- this can help performance, but it will prevent the
      -- FileType autocmd from firing, which may break integration
      -- with other plguins.
      -- default: false (disabled)
      dashboard.config.opts.noautocmd = false

      -- vim.cmd[[autocmd User AlphaReady echo 'ready']]

      --[[ Layout ]]
      local marginTopPercent = 0.18
      local headerPadding = vim.fn.max({2, vim.fn.floor(vim.fn.winheight(0) * marginTopPercent) })

      dashboard.config.layout = {
        -- { type = "padding", val = 1 },
        -- dashboard.section.terminal,
        { type = "padding", val = headerPadding },
        dashboard.section.header,
        { type = "padding", val = 4 },
        dashboard.section.buttons,
        { type = "padding", val = 2 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)


      vim.api.nvim_create_augroup("AlphaKeymaps", {clear = true})
      vim.api.nvim_create_autocmd("FileType", {
        group   = "AlphaKeymaps",
        pattern = {'alpha'},
        callback = function()
          local keys = { "i", "a", "o", "p", "q", ":", "I", "A", "O", "P", }
          for _, key in ipairs(keys) do
            vim.keymap.set("n", key, function()
              vim.cmd("enew")
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "n")
            end, { buffer = 0 })
          end
        end
      })
    end
  },
}
