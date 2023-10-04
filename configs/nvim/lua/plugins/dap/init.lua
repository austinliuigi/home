return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      { "<Left>",  function() return require("dap").step_back() end },
      { "<Down>",  function() return require("dap").step_out() end },
      { "<Up>",    function() return require("dap").step_over() end },
      { "<Right>", function() return require("dap").step_into() end },

      { "<S-Left>",  function() return require("dap").reverse_continue() end },
      { "<S-Down>",  function() return require("dap").terminate() end },
      { "<S-Up>",    function() return require("dap").repl.toggle() end },
      { "<S-Right>", function() return require("dap").continue() end },

      { "<CR>", function() return require("dap").toggle_breakpoint() end },
      { "<S-CR>", function() return require("dap").set_breakpoint(vim.fn.input("Breakpoint Condition: ")) end },
    },
    config = function()
      local dap = require("dap")

      for lang, configuration in pairs(require("plugins.dap.configurations")) do
        dap.configurations[lang] = configuration
      end

      for lang, adapter in pairs(require("plugins.dap.adapters")) do
        dap.adapters[lang] = adapter
      end

      -- TODO: Decouple from kitty
      dap.defaults.fallback.external_terminal = {
        command = tostring(io.popen("command -v kitty"):read("*line"));
        args = {};
      }

      vim.fn.sign_define("DapBreakpoint", {text="ﴫ", texthl="GitSignsDelete", linehl="", numhl=""}) -- ●    ﴫ
      vim.fn.sign_define("DapBreakpointCondition", {text="ﴫ", texthl="GitSignsChange", linehl="", numhl=""})
    end,
    dependencies = {
      {
        'rcarriga/cmp-dap',
        dependencies = {
          "hrsh7th/nvim-cmp",
        }
      },
      {
        'rcarriga/nvim-dap-ui',
        config = function()
          local dap, dapui = require("dap"), require("dapui")

          dap.listeners.after.event_initialized["dapui"] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated["dapui"] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited["dapui"] = function()
            dapui.close()
          end
          dap.listeners.before.event_terminated["repl"] = function()
            dap.repl.close()
          end
          dap.listeners.before.event_exited["repl"] = function()
            dap.repl.close()
          end

          require("dapui").setup({
            icons = { expanded = "▾", collapsed = "▸" },
            mappings = {
              -- Use a table to apply multiple mappings
              expand = { "<CR>", "<2-LeftMouse>" },
              open = "o",
              remove = "d",
              edit = "e",
              repl = "r",
              toggle = "t",
            },
            -- Expand lines larger than the window
            -- Requires >= 0.7
            expand_lines = vim.fn.has("nvim-0.7"),
            layouts = {
              {
                elements = {
                -- Elements can be strings or table with id and size keys.
                  { id = "breakpoints", size = 0.25 },
                  "stacks",
                  "scopes",
                  "watches",
                },
                size = 40, -- 40 columns
                position = "left",
              },
              {
                elements = {
                  -- "repl",
                  "console",
                },
                size = 0.25, -- 25% of total lines
                position = "bottom",
              },
            },
            floating = {
              max_height = nil, -- These can be integers or a float between 0 and 1.
              max_width = nil, -- Floats will be treated as percentage of your screen.
              border = "rounded", -- Border style. Can be "single", "double" or "rounded"
              mappings = {
                close = { "q" },
              },
            },
            windows = { indent = 1 },
            render = {
              max_type_length = nil, -- Can be integer or nil.
              max_value_lines = 100, -- Can be integer or nil.
            }
          })
        end
      },
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {
          enabled = true,                        -- enable this plugin (the default)
          enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,               -- show stop reason when stopped for exceptions
          commented = false,                     -- prefix virtual text with comment string
          only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
          all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
          filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
          -- experimental features:
          virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
          all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                                 -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        },
      },
    },
  },
}
