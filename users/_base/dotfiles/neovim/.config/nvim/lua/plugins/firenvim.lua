return {
  "glacambre/firenvim",

  -- Lazy load firenvim
  -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  dependencies = {
    "bartender.nvim",
  },
  config = function()
    -- firenvim configuration
    vim.g.firenvim_config = {
      globalSettings = { alt = "all" },
      localSettings = {
        [".*"] = {
          cmdline = "neovim",
          content = "text",
          selector = "textarea",
          takeover = "never",
          priority = 0,
        },
      },
    }

    -- set font for firenvim
    vim.o.guifont = "Mononoki Nerd Font:h12"

    -- remove bars
    if vim.g.started_by_firenvim == true then
      vim.o.laststatus = 0
      vim.o.showtabline = 0
      vim.o.winbar = ""

      vim.api.nvim_create_autocmd({ "UIEnter" }, {
        callback = function(event)
          vim.defer_fn(function()
            local min_lines = 5
            if vim.o.lines < min_lines then
              vim.o.lines = min_lines
            end
          end, 1000)
        end,
      })
    end

    -- firenvim specific autocmds
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end,
}
