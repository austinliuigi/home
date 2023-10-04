return {
  {
    "iamcco/markdown-preview.nvim",
    ft = "Markdown",
    build = "cd app && npm install",
  },
  {
    "toppair/peek.nvim",
    ft = "Markdown",
    build = "deno task --quiet build:fast",
    config = function()
      require('peek').setup({
        auto_load = true,             -- whether to automatically load preview when entering another markdown buffer
        close_on_bdelete = true,      -- close preview window on buffer delete
        syntax = true,                -- enable syntax highlighting, affects performance
        theme = 'light',              -- 'dark' or 'light'
        app = 'webview',              -- 'webview', 'browser', string or a table of strings
        filetype = { 'markdown' },    -- list of filetypes to recognize as markdown
        update_on_change = true,
        throttle_at = 200000,         -- start throttling when file exceeds this amount of bytes in size
        throttle_time = 'auto',       -- minimum amount of time in milliseconds that has to pass before starting new render
      })

      vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
      vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
    end
  },
  {
    "austinliuigi/clipboard-image.nvim",
    config = function()
      require'clipboard-image'.setup {
        default = {
          img_dir = function()
            local dir = {vim.fn.expand("%:p:h"), "media"} -- Use table for nested dir (New feature form PR #20)
            -- P(dir)
            return dir
          end,
          img_dir_txt = "./media",
          img_name = function()
            return vim.fn.input("Filename: ")
          end,
          -- img_handler = function(img)
          --   local size = string.match(vim.fn.input("Size (300x300): "), "%d+x%d+") or "300x300"
          --   os.execute(string.format(
          --     'mogrify -unsharp 0x0.25+8+0.065 -resize "%s" "%s"', size, img.path
          --   ))
          -- end,
          affix = "<\n  %s\n>" -- Multi-line affix
        },
        markdown = {
          affix = '<div align="center">\n\n<img src=%s width=300 />\n\n**\n\n</div>'
        },
        norg = {
          affix = '.image %s'
        }
      }
    end
  },
  -- {
  --   "lervag/vimtex",
  --   config = function()
  --   end
  -- },
}
