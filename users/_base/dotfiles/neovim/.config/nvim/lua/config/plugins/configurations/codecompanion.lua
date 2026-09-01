-- variables vs. slash commands vs. prompt library
--   - variables are effectively macros that expand to the variable's value
--   - slash commands dynamically add context to the chat
--   - the prompt library is a collection of pre-built prompts
-- inline assistant vs editor agent
--   - inline assistant has some niceties, like creating diffs of the changes
-- user vs system roles

-- ========== Decrypt API Keys ==========
if vim.fn.executable("sops") == 0 then
  vim.notify("CodeCompanion config: sops not available, skipping configuration", vim.log.levels.ERROR)
  return
end

-- ----- OpenAI -----
local openai_key_cmd_object = vim
  .system({ "sops", "decrypt", vim.env.HOME .. "/.secrets/openai-enc.env" }, {
    cwd = vim.env.HOME,
    text = true,
  })
  :wait()

if openai_key_cmd_object.code ~= 0 then
  vim.notify("CodeCompanion config: openai key not available, skipping configuration", vim.log.levels.ERROR)
  return
end

local openai_key = vim.trim(openai_key_cmd_object.stdout):gsub("OPENAI_API_KEY=", "")

-- ========== Configuration ==========
require("codecompanion").setup({
  -- ========== Adapters ==========
  -- builtin adapters: https://github.com/olimorris/codecompanion.nvim/tree/main/lua/codecompanion/adapters
  adapters = {
    acp = {
      opencode = function()
        return require("codecompanion.adapters").extend("opencode", {
          env = { OPENAI_API_KEY = openai_key },
        })
      end,
    },
    http = {
      -- openai models documentation: https://platform.openai.com/docs/models
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            api_key = openai_key,
          },
          schema = {
            model = {
              default = "gpt-4o-mini",
            },
          },
        })
      end,
    },
  },
  -- ========== Assistants ==========
  strategies = {
    cli = {
      agent = "opencode",
      agents = {
        opencode = {
          cmd = "opencode",
          args = {},
          description = "Opencode CLI",
          provider = "terminal",
        },
      },
    },
    chat = {
      adapter = "opencode", -- selects default adapter (possible values are keys configured in adapters.acp or adapters.http)
      -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/utils/keymaps.lua
      -- available keymaps: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/strategies/chat/keymaps.lua
      keymaps = {
        options = {
          modes = {
            n = "g?",
          },
          callback = "keymaps.options",
          description = "Options",
          hide = true, -- whether to show in the keymap.options menu
          condition = function() -- whether to create keymap when creating new chat buffer
            return true
          end,
        },
        completion = {
          modes = {
            i = "<C-_>",
          },
          index = 1,
          callback = "keymaps.completion",
          description = "Completion Menu",
          condition = function()
            return false
          end,
        },
        send = {
          modes = {
            n = { "<CR>" },
            i = "<C-CR>",
          },
          index = 2,
          callback = "keymaps.send",
          description = "Send",
          condition = function()
            return true
          end,
        },
        regenerate = {
          modes = {
            n = "<localleader>r",
          },
          index = 3,
          callback = "keymaps.regenerate",
          description = "Regenerate the last response",
          condition = function()
            return false
          end,
        },
        close = {
          modes = {
            n = "q",
          },
          index = 4,
          callback = "keymaps.close",
          description = "Close Chat",
          condition = function()
            return false
          end,
        },
        stop = {
          modes = {
            i = "<C-c>",
          },
          index = 5,
          callback = "keymaps.stop",
          description = "Stop Request",
          condition = function()
            return true
          end,
        },
        clear = {
          modes = {
            n = "gx",
          },
          index = 6,
          callback = "keymaps.clear",
          description = "Clear Chat",
          condition = function()
            return false
          end,
        },
        codeblock = {
          modes = {
            n = "gc",
          },
          index = 7,
          callback = "keymaps.codeblock",
          description = "Insert Codeblock",
          condition = function()
            return false
          end,
        },
        yank_code = {
          modes = {
            n = "gy",
          },
          index = 8,
          callback = "keymaps.yank_code",
          description = "Yank Code",
          condition = function()
            return false
          end,
        },
        pin = {
          modes = {
            n = "gp",
          },
          index = 9,
          callback = "keymaps.pin_reference",
          description = "Pin Reference",
          condition = function()
            return false
          end,
        },
        watch = {
          modes = {
            n = "gw",
          },
          index = 10,
          callback = "keymaps.toggle_watch",
          description = "Watch Buffer",
          condition = function()
            return false
          end,
        },
        next_chat = {
          modes = {
            n = "}",
          },
          index = 11,
          callback = "keymaps.next_chat",
          description = "Next Chat",
          condition = function()
            return false
          end,
        },
        previous_chat = {
          modes = {
            n = "{",
          },
          index = 12,
          callback = "keymaps.previous_chat",
          description = "Previous Chat",
          condition = function()
            return false
          end,
        },
        next_header = {
          modes = {
            n = "]]",
          },
          index = 13,
          callback = "keymaps.next_header",
          description = "Next Header",
          condition = function()
            return true
          end,
        },
        previous_header = {
          modes = {
            n = "[[",
          },
          index = 14,
          callback = "keymaps.previous_header",
          description = "Previous Header",
          condition = function()
            return true
          end,
        },
        change_adapter = {
          modes = {
            n = "ga",
          },
          index = 15,
          callback = "keymaps.change_adapter",
          description = "Change adapter",
          condition = function()
            return false
          end,
        },
        fold_code = {
          modes = {
            n = "gf",
          },
          index = 15,
          callback = "keymaps.fold_code",
          description = "Fold code",
          condition = function()
            return false
          end,
        },
        debug = {
          modes = {
            n = "<localleader>d",
          },
          index = 16,
          callback = "keymaps.debug",
          description = "View debug info",
          condition = function()
            return true
          end,
        },
        system_prompt = {
          modes = {
            n = "gs",
          },
          index = 17,
          callback = "keymaps.toggle_system_prompt",
          description = "Toggle the system prompt",
          condition = function()
            return false
          end,
        },
        auto_tool_mode = {
          modes = {
            n = "gta",
          },
          index = 18,
          callback = "keymaps.auto_tool_mode",
          description = "Toggle automatic tool mode",
          condition = function()
            return false
          end,
        },
      },
    },
    inline = {
      adapter = "openai",
      -- available keymaps: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/strategies/inline/keymaps.lua
      keymaps = {
        accept_change = {
          modes = {
            n = "ga",
          },
          index = 1,
          callback = "keymaps.accept_change",
          description = "Accept change",
          condition = function()
            return false
          end,
        },
        reject_change = {
          modes = {
            n = "gr",
          },
          index = 2,
          callback = "keymaps.reject_change",
          description = "Reject change",
          condition = function()
            return false
          end,
        },
      },
    },
  },
  display = {
    chat = {
      intro_message = "",
      show_header_separator = false, -- Show header separators in the chat buffer? Set this to false if you're using an external markdown formatting plugin
      separator = "─", -- The separator between the different messages in the chat buffer
      show_references = true, -- Show references (from slash commands and variables) in the chat buffer?
      show_settings = true, -- Show LLM settings at the top of the chat buffer?
      show_token_count = true, -- Show the token count for each response?
      start_in_insert_mode = true, -- Open the chat buffer in insert mode?

      window = {
        width = 0.35,
      },

      debug_window = {
        width = function()
          return vim.o.columns
        end,
        height = function()
          return vim.o.lines
        end,
      },
    },
  },
  opts = {
    log_level = "TRACE", -- INFO|ERROR|DEBUG|TRACE
  },
})

-- local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
--
-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = "CodeCompanionRequest*",
--   group = group,
--   callback = function(request)
--     vim.notify("CodeCompanion: " .. request.match)
--   end,
-- })
