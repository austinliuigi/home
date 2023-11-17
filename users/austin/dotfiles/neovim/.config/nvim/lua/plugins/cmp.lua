-- local nvim_autopairs = {
--   'windwp/nvim-autopairs',
--   config = function()
--     require('nvim-autopairs').setup {
--       check_ts = true,
--       break_undo = false,
--       ignored_next_char = "[%S]",
--     }
--
--     -- Insert `(` after completing function or method item
--     local cmp = require('cmp')
--     local cmp_autopairs = require('nvim-autopairs.completion.cmp')
--     local handlers = require('nvim-autopairs.completion.handlers')
--     cmp.event:on(
--       'confirm_done',
--       cmp_autopairs.on_confirm_done({
--         filetypes = {
--           -- "*" is a alias to all filetypes
--           ["*"] = {
--             ["("] = {
--               kind = {
--                 cmp.lsp.CompletionItemKind.Function,
--                 cmp.lsp.CompletionItemKind.Method,
--               },
--               handler = handlers["*"]
--             }
--           },
--           -- Disable for tex
--           tex = false,
--           plaintex = false,
--         }
--       })
--     )
--   end
-- }

return {
  {
    'hrsh7th/nvim-cmp',
    version = false,
    event = {"InsertEnter", "CmdlineEnter"},
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      -- 'rcarriga/cmp-dap',
      -- 'dmitmel/cmp-digraphs',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      -- nvim_autopairs,
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup {
        enabled = function()
          local dap_loaded, dap pcall(require, "cmp_dap")
          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
              or (dap_loaded and dap.is_dap_buffer())
        end,
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        mapping = cmp.mapping.preset.insert({
          ['<Left>'] = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
          ['<Right>'] = cmp.mapping(cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }), { 'i', 'c' }),
          -- ['<Esc>'] = cmp.mapping(cmp.mapping.close(), { 'i', 'c' }),
          -- ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }), { 'i', 'c' }),
          ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
          ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c' }),
          ['<C-Up>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
          ['<C-Down>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
          -- ['<S-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        }),
        sources = {
          { name = 'neorg' },
          { name = 'luasnip' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'nvim_lua' },
          { name = 'path' },
          { name = 'calc' },
          { name = 'buffer', keyword_length = 2, max_item_count = 4, },
          -- { name = 'buffer-lines', keyword_length = 4, max_item_count = 4, leading_whitespace = false, },
          -- { name = 'digraphs' },
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end
        },
        formatting = {
          fields = { 'abbr', 'kind', 'menu' },
          format = function(entry, vim_item)
            local kind_icons = {
              Text = "",
              Method = "",
              Function = "",
              Constructor = "",
              Field = "ﰠ",
              Variable = "",
              Class = "ﴯ",
              Interface = "",
              Module = "",
              Property = "ﰠ",
              Unit = "塞",
              Value = "",
              Enum = "",
              Keyword = "",
              Snippet = "",
              Color = "",
              File = "",
              Reference = "",
              Folder = "",
              EnumMember = "",
              Constant = "",
              Struct = "פּ",
              Event = "",
              Operator = "",
              TypeParameter = ""
            }
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
            vim_item.menu = ({
              buffer = '[BUF]',
              -- ["buffer-lines"] = '[LINE]',
              calc = '[CALC]',
              cmdline = '[CMD]',
              cmdline_history = '[HIST]',
              dap = '[DAP]',
              luasnip = '[SNIP]',
              nvim_lsp_signature_help = '[SIG]',
              nvim_lsp = '[LSP]',
              nvim_lua = '[API]',
              path = '[PATH]',
            })[entry.source.name]
            return vim_item
          end
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        experimental = {
          ghost_text = true
        }
      }

      cmp.setup.filetype({ "dap-repl", "dapui_watches" }, {
        sources = {
          { name = "dap", trigger_characters = { "." }  },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
        },
      })

      cmp.setup.cmdline(':', {
        -- completion = {
        --   keyword_length = 2
        -- },
        sources = {
          { name = 'path' },
          { name = 'cmdline', max_item_count = 10 },
          -- { name = 'cmdline_history', max_item_count = 2, keyword_length = 3 },
        },
        formatting = {
          fields = { 'kind', 'abbr', 'menu' },
        },
        window = {
          completion = cmp.config.window.bordered()
        }
      })

      for _, cmd_type in ipairs({'/', '?'}) do
        cmp.setup.cmdline(cmd_type, {
          -- completion = {
          --   keyword_length = 2
          -- },
          sources = {
            { name = 'buffer', max_item_count = 5 },
            { name = 'cmdline_history', max_item_count = 2, keyword_length = 3 },
          },
          formatting = {
            fields = { 'kind', 'abbr', 'menu' },
          },
          window = {
            completion = cmp.config.window.bordered()
          }
        })
      end

      -- Overall max_item_count
      -- vim.o.pumheight = 10

      vim.api.nvim_exec_autocmds("User", { pattern = "CmpConfigLoaded" })
    end
  },
}
