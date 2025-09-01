---@diagnostic disable: undefined-global

-- stylua: ignore start
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
  ----------------------------------------------------------------------------------------------------
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
  ----------------------------------------------------------------------------------------------------
  s("dish", fmt([[
    # {}

    ## Ingredients

    {}

    ## Steps

    {}
  ]], {
    i(1, "Dish"),
    i(2),
    i(0),
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
