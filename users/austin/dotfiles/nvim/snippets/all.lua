--[[ 
- if multiple insert nodes with same placeholder number, all but one are rendered useless
- if there are multiple jumpable nodes, but a jump_number is skipped (e.g. there is i(0) and i(2) but no i(1)),
  any node after the skipped jump_number will do nothing
- fmt: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#fmt
]]

local snippets = {
  s("todo", fmt([[
    {} TODO: {}
  ]], {
    f(function(_, parent, _)
      local env = parent.snippet.env
      return env.LINE_COMMENT
    end),
    i(0),
  }), {
    -- callbacks = {
    --   [0] = {
    --     [events.enter] = function()
    --       require("Comment.api").toggle.linewise.current()
    --     end
    --   }
    -- },
  }),
  s("modeline", fmt([[
    {} vim: set {} :{}
  ]], {
    f(function(_, parent, _)
      local env = parent.snippet.env
      return env.LINE_COMMENT == "//" and env.BLOCK_COMMENT_START or env.LINE_COMMENT
    end),
    i(0, "opt=value opt=value"),
    f(function(_, parent, _)
      local env = parent.snippet.env
      return env.LINE_COMMENT == "//" and " " .. env.BLOCK_COMMENT_END or ""
    end),
  }), {
    -- callbacks = {
    --   [0] = {
    --     [events.enter] = function()
    --       require("Comment.api").toggle.linewise.current()
    --     end
    --   }
    -- },
  }),
  s("dish", fmt([[
    # {}

    ## Ingredients

    {}

    ## Steps

    {}
  ]], {
    i(1, "Dish"),
    i(2),
    i(3),
  }), {
    condition = function()
      return vim.fn.expand("%:t") == "cookbook.md"
    end,
    show_condition = function()
      return vim.fn.expand("%:t") == "cookbook.md"
    end,
  }),
}

return snippets
