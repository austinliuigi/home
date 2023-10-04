local function create_colorscheme_refresh_autocmd(setup_func)
  vim.api.nvim_create_autocmd("User", {
    pattern = {"RefreshColorschemeConfigs"},
    callback = function()
      local transparent = require("config.colors").transparent
      setup_func(transparent)
    end
  })
  vim.api.nvim_exec_autocmds("User", { pattern = "RefreshColorschemeConfigs" })
end



return {
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require('nightfox').setup({
          options = {
            -- Compiled file's destination location
            compile_path = vim.fn.stdpath("cache") .. "/nightfox",
            compile_file_suffix = "_compiled" .. (transparent and "_transparent" or ""), -- Compiled file suffix
            -- compile_file_suffix = "_compiled", -- Compiled file suffix
            transparent = transparent,    -- Disable setting background
            terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
            dim_inactive = false,   -- Non focused panes set to alternative background
            styles = {              -- Style to be applied to different syntax groups
              comments = "italic",    -- Value is any valid attr-list value `:help attr-list`
              conditionals = "NONE",
              constants = "NONE",
              functions = "NONE",
              keywords = "NONE",
              numbers = "NONE",
              operators = "NONE",
              strings = "NONE",
              types = "NONE",
              variables = "NONE",
            },
            inverse = {             -- Inverse highlight for different types
              match_paren = false,
              visual = false,
              search = false,
            },
            modules = {             -- List of various plugins and additional options
              -- ...
            },
          },
          palettes = {},
          specs = {},
          groups = {},
        })
      end)
    end
  },
  {
    "sainnhe/everforest",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        -- vim.g.everforest_background = "hard"
        vim.g.everforest_transparent_background = transparent and 1 or 0
      end)
    end
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require("gruvbox").setup({
          undercurl = true,
          underline = true,
          bold = true,
          italic = true,
          strikethrough = true,
          invert_selection = false,
          invert_signs = false,
          invert_tabline = false,
          invert_intend_guides = false,
          inverse = true, -- invert background for search, diffs, statuslines and errors
          contrast = "", -- can be "hard", "soft" or empty string
          palette_overrides = {},
          dim_inactive = false,
          transparent_mode = transparent,
          overrides = {
            -- Normal = require("gruvbox").config.transparent_mode and { fg = "#fbf1c7", bg = nil } or { fg = "#fbf1c7", bg = "#282828" },
          }
        })
      end)
    end
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require("tokyonight").setup({
          style = "storm",
          light_style = "day",
          transparent = transparent,
          terminal_colors = true,
          styles = {
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark", -- style for floating windows
          },
          sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
          day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
          hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
          dim_inactive = false,
          lualine_bold = false,

          --- You can override specific color groups to use other groups or a hex color
          --- function will be called with a ColorScheme table
          ---@param colors ColorScheme
          on_colors = function(colors) end,

          --- You can override specific highlights to use other groups or a hex color
          --- function will be called with a Highlights and ColorScheme table
          ---@param highlights Highlights
          ---@param colors ColorScheme
          on_highlights = function(highlights, colors) end,
        })
      end)
    end
  },
  {
    "marko-cerovac/material.nvim",
    lazy = true,
    config = function()
      vim.g.material_style = "palenight"
      create_colorscheme_refresh_autocmd(function(transparent)
        require('material').setup({
            contrast = {
                terminal = false, -- Enable contrast for the built-in terminal
                sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
                floating_windows = false, -- Enable contrast for floating windows
                cursor_line = false, -- Enable darker background for the cursor line
                non_current_windows = false, -- Enable darker background for non-current windows
                filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
            },
            styles = {
                comments = { italic = true },
                strings = { --[[ bold = true ]] },
                keywords = { --[[ underline = true ]] },
                functions = { --[[ bold = true, undercurl = true ]] },
                variables = {},
                operators = {},
                types = {},
            },
            plugins = {
                -- Available plugins:
                "dap",
                -- "dashboard",
                "gitsigns",
                -- "hop",
                "indent-blankline",
                -- "lspsaga",
                -- "mini",
                "neogit",
                "nvim-cmp",
                "nvim-navic",
                "nvim-tree",
                "nvim-web-devicons",
                -- "sneak",
                "telescope",
                "trouble",
                "which-key",
            },
            disable = {
                colored_cursor = false,
                borders = false, -- Disable borders between verticaly split windows
                background = transparent,
                term_colors = false,
                eob_lines = false -- Hide the end-of-buffer lines
            },
            high_visibility = {
                lighter = false, -- Enable higher contrast text for lighter style
                darker = false -- Enable higher contrast text for darker style
            },
            lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
            async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)
            custom_colors = nil, -- If you want to everride the default colors, set this to a function
            custom_highlights = {}, -- Overwrite highlights with your own
        })
      end)
    end
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        local c = require('vscode.colors')
        require('vscode').setup({
            transparent = transparent,
            italic_comments = true,
            disable_nvimtree_bg = true,
            -- Override colors (see ./lua/vscode/colors.lua)
            color_overrides = {
                -- vscLineNumber = '#FFFFFF',
            },
            -- Override highlight groups (see ./lua/vscode/theme.lua)
            group_overrides = {
                -- this supports the same val table as vim.api.nvim_set_hl
                -- use colors from this colorscheme by requiring vscode.colors!
                -- Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
            }
        })
      end)
    end
  },
  {
    "navarasu/onedark.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require('onedark').setup({
            -- Main options --
            style = 'dark', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
            transparent = transparent,
            term_colors = true, -- Change terminal color as per the selected theme style
            ending_tildes = true, -- Show the end-of-buffer tildes. By default they are hidden
            cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
            toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
            toggle_style_list = {'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light'}, -- List of styles to toggle between
            -- Change code style; Options are italic, bold, underline, none
            -- You can configure multiple style with comma seperated, For e.g., keywords = 'italic,bold'
            code_style = {
                comments = 'italic',
                keywords = 'none',
                functions = 'none',
                strings = 'none',
                variables = 'none'
            },
            -- Lualine options --
            lualine = {
                transparent = false, -- lualine center bar transparency
            },
            -- Custom Highlights --
            colors = {}, -- Override default colors
            highlights = {}, -- Override highlight groups
            -- Plugins Config --
            diagnostics = {
                darker = true, -- darker colors for diagnostic
                undercurl = true,   -- use undercurl instead of underline for diagnostics
                background = true,    -- use background color for virtual text
            },
        })
      end)
    end
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require('kanagawa').setup({
            undercurl = true,           -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = false},
            statementStyle = { bold = true },
            typeStyle = {},
            variablebuiltinStyle = { italic = true},
            specialReturn = true,       -- special highlight for the return keyword
            specialException = true,    -- special highlight for exception handling keywords
            transparent = transparent,
            dimInactive = false,        -- dim inactive window `:h hl-NormalNC`
            globalStatus = true,        -- adjust window separators highlight for laststatus=3
            terminalColors = true,      -- define vim.g.terminal_color_{0,17}
            colors = {},
            overrides = function(colors)
              return {}
            end,
            theme = "default"           -- Load "default" theme or the experimental "light" theme
        })
      end)
    end
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require('rose-pine').setup({
          --- @usage 'main' | 'moon'
          dark_variant = 'main',
          bold_vert_split = false,
          dim_nc_background = false,
          disable_background = transparent,
          disable_float_background = false,
          disable_italics = false,

          --- @usage string hex value or named color from rosepinetheme.com/palette
          groups = {
            background = 'base',
            panel = 'surface',
            border = 'highlight_med',
            comment = 'muted',
            link = 'iris',
            punctuation = 'subtle',
            error = 'love',
            hint = 'iris',
            info = 'foam',
            warn = 'gold',
            headings = {
              h1 = 'iris',
              h2 = 'foam',
              h3 = 'rose',
              h4 = 'gold',
              h5 = 'pine',
              h6 = 'foam',
            }
            -- or set all headings at once
            -- headings = 'subtle'
          },
          -- Change specific vim highlight groups
          highlight_groups = {
            -- ColorColumn = { bg = 'rose' }
          }
        })
      end)
    end
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        vim.g.nord_disable_background = transparent
      end)
    end
  },
  {
    "shaunsingh/seoul256.nvim",
    lazy = true,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        vim.g.seoul256_disable_background = transparent
      end)
    end
  },
  {
    "austinliuigi/smoke.nvim",
    dev = false,
    config = function()
      create_colorscheme_refresh_autocmd(function(transparent)
        require('smoke').setup({
          bold_vert_split = false,
          dim_nc_background = false,
          disable_background = transparent,
          disable_float_background = false,
          disable_italics = false,
          disable_undercurl = true,

          -- Change specific vim highlight groups
          highlight_groups = {
            Cursor = { reverse = true }
          }
        })
      end)
    end
  },
}
