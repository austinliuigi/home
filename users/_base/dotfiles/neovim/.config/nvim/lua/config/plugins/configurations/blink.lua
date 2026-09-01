require("blink.cmp").setup({
  enabled = function()
    return true
  end,
  -- ================================================================================
  -- Keybinds
  -- ================================================================================
  keymap = {
    preset = "none",
    ["<Left>"] = { "cancel", "fallback" },
    ["<Down>"] = { "select_next", "fallback" },
    ["<Up>"] = { "select_prev", "fallback" },
    ["<Right>"] = { "accept", "fallback" },
  },
  -- ================================================================================
  -- GENERAL
  -- ================================================================================
  completion = {
    menu = {
      auto_show = true,
      border = "rounded", -- 'none' | 'single' | 'double' | 'rounded' | 'solid' | 'shadow' | 'padded'
      draw = {
        gap = 2,
        -- available components for each column: https://cmp.saghen.dev/configuration/completion.html#available-components
        columns = function(ctx)
          if ctx.mode ~= "cmdline" then
            return { { "label" }, { "kind_icon", "kind", gap = 1 }, { "source_name" } }
          end
          return { { "kind_icon", "label", gap = 1 } }
        end,
        -- custom components
        -- components = {
        --   kind_icon = {
        --     text = function(ctx)
        --       if require("blink.cmp.completion.windows.render.tailwind").get_hex_color(ctx.item) then
        --         return "󱓻"
        --       end
        --       return ctx.kind_icon .. ctx.icon_gap
        --     end,
        --   },
        -- },
        treesitter = { "lsp" }, -- use treesitter to highlight the label text
      },
    },
    documentation = {
      window = { border = "single" },
      auto_show = true,
      auto_show_delay_ms = 50,
      treesitter_highlighting = true,
    },
    keyword = {
      -- "prefix" will fuzzy match on the text before the cursor
      -- "full" will fuzzy match on the text before *and* after the cursor
      -- example: "foo_|_bar" will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      range = "prefix",
    },
    trigger = {
      show_on_keyword = true, -- show the completion window after typing any alphanumerics, `-` or `_`
      show_on_trigger_character = true, -- show the completion window after typing a trigger character
      show_on_insert_on_trigger_character = true, -- show the completion window after entering insert mode on top of a trigger character
    },
    list = {
      selection = {
        preselect = true, -- automatically select first item when menu opens
        auto_insert = false, -- automatically insert when changing selecting (like ghost text but text actually stays)
      },
    },
    ghost_text = { enabled = true },
  },
  -- ================================================================================
  -- SOURCES
  -- ================================================================================
  sources = {
    -----------------------------------------------------
    -- Enabled sources
    -----------------------------------------------------
    default = function()
      return { "git", "lsp", "path", "snippets", "buffer" }
    end,
    per_filetype = {
      -- <ft> = { "lsp", "path" },
    },
    -----------------------------------------------------
    -- Per-source configurations
    --   - https://cmp.saghen.dev/configuration/reference.html#sources
    -----------------------------------------------------
    providers = {
      -----------------------------------------------------
      -- Builtin
      -----------------------------------------------------
      buffer = {
        opts = {
          get_bufnrs = function()
            return { vim.api.nvim_get_current_buf() }
          end,
        },
      },
      snippets = {
        -- available options depends on the value of `snippets.preset'`
        opts = {
          use_show_condition = true, -- whether to use show_condition for filtering snippets
          show_autosnippets = true, -- whether to show autosnippets in the completion list
        },
      },
      -----------------------------------------------------
      -- External
      -----------------------------------------------------
      example = {
        module = "scripts.blink.example",
        name = "Example",
      },
      git = {
        module = "blink-cmp-git",
        name = "Git",
        enabled = function()
          return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
        end,
        opts = {
          use_items_cache = true, -- use items in the cache instead of fetching from github every time completion is triggered
          use_items_pre_cache = true, -- fetch and cache available completion itmes from github when the source is loaded
        },
      },
    },
  },
  cmdline = {
    enabled = true,
    keymap = { preset = "inherit" },
    sources = function()
      local type = vim.fn.getcmdtype()
      if type == "" then
        type = vim.fn.getcmdwintype()
      end
      -- Search
      if type == "/" or type == "?" then
        return { "buffer" }
      end
      -- Commands
      if type == ":" or type == "@" then
        return { "cmdline", "path" }
      end
      return {}
    end,
    completion = {
      list = {
        selection = {
          preselect = true, -- When `true`, will automatically select the first item in the completion list
          auto_insert = false, -- When `true`, inserts the completion item automatically when selecting it
        },
      },
      menu = {
        auto_show = true,
      },
      ghost_text = {
        enabled = true,
      },
    },
  },
  -- ================================================================================
  -- Signature-help
  --   - signature help is automatically triggered when typing trigger characters, defined by the LSP, such as ( for lua
  --   - the menu will be updated when pressing a retrigger character, such as ,
  -- ================================================================================
  signature = {
    enabled = true,
    window = {
      border = "single",
      show_documentation = false, -- show documentation along with the function signature
    },
  },
  -- ================================================================================
  -- Snippets
  -- ================================================================================
  snippets = {
    -- presets automatically define the `expand`, `active`, and `jump` functions
    -- - "default" will use builtin vim.snippet api
    -- - "luasnip" will use luasnip
    -- - "mini_snippets" will use mini_snippets
    preset = "luasnip",
  },
  -- ================================================================================
  -- Fuzzy-matching
  -- ================================================================================
  fuzzy = {
    -- Allows for a number of typos relative to the length of the query
    -- - set this to 0 to match the behavior of fzf
    max_typos = function(keyword)
      return math.floor(#keyword / 4)
    end,

    frecency = { -- frecency tracks the most recently/frequently used items and boosts the score of the item
      enabled = true,
    },
    use_proximity = true, -- proximity bonus boosts the score of items matching nearby words

    -- Controls which sorts to use and in which order, falling back to the next sort if the first one returns nil
    -- You may pass a function instead of a string to customize the sorting
    sorts = { "score", "sort_text" },

    prebuilt_binaries = {
      -- Whether or not to automatically download a prebuilt binary from github. If this is set to `false`
      -- you will need to manually build the fuzzy binary dependencies by running `cargo build --release`
      download = true,
    },
  },
  -- ================================================================================
  -- Appearance
  -- ================================================================================
  appearance = {
    highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
    nerd_font_variant = "mono", -- "mono"|"normal"
    kind_icons = {
      Class = "󰠱",
      Color = "󰏘",
      Constant = "󰏿",
      Constructor = "",
      Enum = "",
      EnumMember = "",
      Event = "",
      Field = "",
      File = "󰈙",
      Folder = "󰉋",
      Function = "󰊕",
      Interface = "󱐥",
      Keyword = "",
      Method = "󰊕",
      Module = "",
      Operator = "󰆕",
      Property = "",
      Reference = "󰶭",
      Snippet = "",
      Struct = "",
      Text = "󰉿",
      TypeParameter = "󰓼",
      Unit = "󰳂",
      Value = "󰎠",
      Variable = "󰀫",
    },
  },
})
