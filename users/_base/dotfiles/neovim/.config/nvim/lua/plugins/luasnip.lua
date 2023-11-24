return {
  'L3MON4D3/LuaSnip',
  event = 'InsertEnter',
  cmd = "LuaSnipEdit",
  config = function()
    local ls = require('luasnip')
    local types = require("luasnip.util.types")

    require("luasnip.loaders.from_lua").load({paths = vim.fn.stdpath("config") .. "/snippets"})

    ls.setup({
      history = true,
      update_events = {"TextChanged", "TextChangedI"},
      region_check_events = { "CursorMoved", "InsertEnter" },
      delete_check_events = { "TextChanged" },
      enable_autosnippets = false,
      ext_opts = {
        [types.insertNode] = {
          passive = {
            virt_text = {{"", "Normal"}}
          },
          visited = {
            virt_text = {{""}}
          },
        },
        [types.choiceNode] = {
          passive = {
            virt_text = {{"", "Normal"}}
          },
          visited = {
            virt_text = {{""}}
          },
        },
      },
    })


    vim.keymap.set({'i', 's'}, '<Tab>', function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n")
      end
    end, {})

    vim.keymap.set({'i', 's'}, '<S-Tab>', function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n")
      end
    end, {})

    vim.keymap.set({'i', 's'}, '<S-Up>', function()
      if ls.choice_active() then
        ls.change_choice(-1)
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Up>", true, true, true), "n")
      end
    end, {})

    vim.keymap.set({'i', 's'}, '<S-Down>', function()
      if ls.choice_active() then
        ls.change_choice(1)
      else
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<S-Down>", true, true, true), "n")
      end
    end, {})

    vim.api.nvim_create_user_command('LuaSnipEdit', require("luasnip.loaders").edit_snippet_files, {})
  end
}
